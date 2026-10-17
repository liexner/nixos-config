{
  # Ender-3 (Creality 4.2.x board) over USB, translated from the Pi's printer.cfg.
  # ponytail: no HA power-off plug or Discord notifier yet, both need secrets
  den.aspects.klipper.nixos = {
    services.klipper = {
      enable = true;
      # run as moonraker so it can reach the API socket and the gcodes folder
      user = "moonraker";
      group = "moonraker";
      settings = {
        mcu = {
          serial = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
          restart_method = "command";
        };

        printer = {
          kinematics = "cartesian";
          max_velocity = 300;
          max_accel = 3000;
          max_z_velocity = 5;
          max_z_accel = 100;
        };

        virtual_sdcard.path = "/var/lib/moonraker/gcodes";
        display_status = { };
        pause_resume = { };
        exclude_object = { };

        stepper_x = {
          step_pin = "PB9";
          dir_pin = "PC2";
          enable_pin = "!PC3";
          microsteps = 16;
          rotation_distance = 40;
          endstop_pin = "^PA5";
          position_endstop = 0;
          position_max = 235;
          homing_speed = 50;
        };

        stepper_y = {
          step_pin = "PB7";
          dir_pin = "PB8";
          enable_pin = "!PC3";
          microsteps = 16;
          rotation_distance = 40;
          endstop_pin = "^PA6";
          position_endstop = 0;
          position_max = 235;
          homing_speed = 50;
        };

        # dual belt Z mod
        stepper_z = {
          step_pin = "PB5";
          dir_pin = "PB6";
          enable_pin = "!PC3";
          microsteps = 16;
          rotation_distance = 40;
          gear_ratio = "80:16";
          full_steps_per_rotation = 200;
          endstop_pin = "probe:z_virtual_endstop";
          position_max = 250;
          position_min = -3.5;
        };

        # BMG clone direct drive, calibrated 2026-10-12
        extruder = {
          max_extrude_only_distance = 100.0;
          step_pin = "PB3";
          dir_pin = "PB4";
          enable_pin = "!PC3";
          microsteps = 16;
          rotation_distance = 22.5293;
          gear_ratio = "50:17";
          nozzle_diameter = 0.4;
          filament_diameter = 1.75;
          heater_pin = "PA1";
          sensor_type = "EPCOS 100K B57560G104F";
          sensor_pin = "PC5";
          pressure_advance = 0.08;
          min_temp = 0;
          max_temp = 255;
          control = "pid";
          pid_Kp = 28.877;
          pid_Ki = 1.645;
          pid_Kd = 126.699;
        };

        heater_bed = {
          heater_pin = "PA2";
          sensor_type = "EPCOS 100K B57560G104F";
          sensor_pin = "PC4";
          min_temp = 0;
          max_temp = 130;
          control = "pid";
          pid_Kp = 62.180;
          pid_Ki = 1.275;
          pid_Kd = 757.819;
        };

        fan.pin = "PA0";

        bltouch = {
          sensor_pin = "^PB1";
          control_pin = "PB0";
          pin_up_touch_mode_reports_triggered = false;
          probe_with_touch_mode = true;
          x_offset = -51;
          y_offset = -6;
          z_offset = 1.265;
        };

        safe_z_home = {
          home_xy_position = "117,117";
          speed = 80;
          z_hop = 10;
          z_hop_speed = 5;
        };

        # no saved mesh needed, START_PRINT probes adaptively every print
        bed_mesh = {
          speed = 50;
          horizontal_move_z = 5;
          mesh_min = "10, 10";
          mesh_max = "166, 204";
          probe_count = "5,5";
          mesh_pps = "2,2";
        };

        screws_tilt_adjust = {
          screw1_name = "front left screw";
          screw1 = "70,30";
          screw2_name = "front right screw";
          screw2 = "215,30";
          screw3_name = "rear right screw";
          screw3 = "215,200";
          screw4_name = "rear left screw";
          screw4 = "70,200";
          horizontal_move_z = 10;
          speed = 250;
          screw_thread = "CW-M4";
        };

        "temperature_sensor host" = {
          sensor_type = "temperature_host";
          min_temp = 10;
          max_temp = 100;
        };

        "temperature_sensor mcu" = {
          sensor_type = "temperature_mcu";
          min_temp = 10;
          max_temp = 100;
        };

        "gcode_macro START_PRINT".gcode = ''
          G92 E0
          {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
          {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(190)|float %}
          M140 S{BED_TEMP}
          G28
          M190 S{BED_TEMP}
          BED_MESH_CALIBRATE ADAPTIVE=1 ADAPTIVE_MARGIN=5
          M104 S{EXTRUDER_TEMP}
          G1 Z2.0 F3000
          G1 X0.1 Y20 Z0.3 F5000.0
          M109 S{EXTRUDER_TEMP}
          G1 X0.1 Y200.0 Z0.3 F1500.0 E15
          G1 X0.4 Y200.0 Z0.3 F5000.0
          G1 X0.4 Y20 Z0.3 F1500.0 E30
          G92 E0
          G1 Z2.0 F3000
          G1 X5 Y20 Z0.3 F5000.0'';

        "gcode_macro END_PRINT".gcode = ''
          G91
          G1 E-2 F1800
          G1 Z5 F3000
          G90
          G1 X10 Y200 F2000
          M140 S0
          M104 S0
          M106 S0
          M84
          M117 Print complete'';

        "gcode_macro PAUSE" = {
          description = "Pause the actual running print";
          rename_existing = "PAUSE_BASE";
          variable_extrude = 1.0;
          gcode = ''
            {% set E = printer["gcode_macro PAUSE"].extrude|float %}
            {% set x_park = 0 %}
            {% set y_park = 0 %}
            {% set max_z = printer.toolhead.axis_maximum.z|float %}
            {% set act_z = printer.toolhead.position.z|float %}
            {% if act_z < (max_z - 2.0) %}
              {% set z_safe = 2.0 %}
            {% else %}
              {% set z_safe = max_z - act_z %}
            {% endif %}
            PAUSE_BASE
            G91
            {% if printer.extruder.can_extrude|lower == 'true' %}
              G1 E-{E} F2100
            {% else %}
              {action_respond_info("Extruder not hot enough")}
            {% endif %}
            {% if "xyz" in printer.toolhead.homed_axes %}
              G1 Z{z_safe} F900
              G90
              G1 X{x_park} Y{y_park} F6000
            {% else %}
              {action_respond_info("Printer not homed")}
            {% endif %}'';
        };

        "gcode_macro RESUME" = {
          description = "Resume the actual running print";
          rename_existing = "RESUME_BASE";
          gcode = ''
            {% set E = printer["gcode_macro PAUSE"].extrude|float %}
            {% if 'VELOCITY' in params|upper %}
              {% set get_params = ('VELOCITY=' + params.VELOCITY) %}
            {% else %}
              {% set get_params = "" %}
            {% endif %}
            {% if printer.extruder.can_extrude|lower == 'true' %}
              G91
              G1 E{E} F2100
            {% else %}
              {action_respond_info("Extruder not hot enough")}
            {% endif %}
            RESUME_BASE {get_params}'';
        };

        "gcode_macro CANCEL_PRINT" = {
          description = "Cancel the actual running print";
          rename_existing = "CANCEL_PRINT_BASE";
          gcode = ''
            TURN_OFF_HEATERS
            CANCEL_PRINT_BASE'';
        };
      };
    };

    services.moonraker = {
      enable = true;
      settings = {
        authorization.trusted_clients = [
          "127.0.0.0/8"
          "192.168.0.0/16"
          "100.64.0.0/10" # tailscale
        ];
        octoprint_compat = { }; # Orca uploads through the OctoPrint API
        history = { };
        file_manager = {
          enable_object_processing = true;
          queue_gcode_uploads = true;
        };
        job_queue.load_on_startup = true;
      };
    };

    # caddy owns 80/443, so fluidd's nginx gets its own port
    services.fluidd = {
      enable = true;
      nginx.listen = [ { addr = "0.0.0.0"; port = 8081; } ];
    };
    services.nginx.clientMaxBodySize = "1G"; # gcode uploads
    networking.firewall.allowedTCPPorts = [ 8081 ];
  };
}
