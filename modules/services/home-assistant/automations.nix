{ lib, ... }:
let
  # Fades a light from dim red to bright warm white, ending at wake time.
  sunrise =
    { entity
    , wake ? { h = 6; m = 15; }
    , minutes ? 30
    , days ? [ "mon" "tue" "wed" "thu" "fri" ]
    , maxPct ? 90
    , warmK ? 3000 # end colour temp, tune to taste/bulb range
    }:
    let
      start = wake.h * 60 + wake.m - minutes;
      pad = lib.fixedWidthNumber 2;
      turnOn = data: { action = "light.turn_on"; target.entity_id = entity; inherit data; };
    in
    {
      alias = "Sunrise ${entity}";
      triggers = [{ trigger = "time"; at = "${pad (start / 60)}:${pad (lib.mod start 60)}:00"; }];
      conditions = [{ condition = "time"; weekday = days; }];
      # Bulb fades in a straight xy line, so red -> white goes via pink; stop at orange first to bend the path.
      actions = [
        (turnOn { hs_color = [ 0 100 ]; brightness_pct = 1; })
        (turnOn { hs_color = [ 25 100 ]; brightness_pct = maxPct / 3; transition = minutes * 20; }) # first third
        { delay.seconds = minutes * 20; }
        (turnOn { color_temp_kelvin = warmK; brightness_pct = maxPct; transition = minutes * 40; })
      ];
    };
in
{
  den.aspects.home-assistant.nixos.services.home-assistant.config.automation = [
    (sunrise { entity = "light.sunlamp"; })
    {
      alias = "Coffee machine left on";
      triggers = [{
        trigger = "state";
        entity_id = "switch.kaffemaskin";
        to = "on";
        for.hours = 1;
      }];
      actions = [{
        action = "notify.mobile_app_pixel_9_pro_xl";
        data = {
          message = "Coffee machine has been on for over an hour";
          data = { priority = "high"; ttl = 0; }; # bypass Android doze batching
        };
      }];
    }
    {
      alias = "Sunlamp at sunset";
      triggers = [{ trigger = "sun"; event = "sunset"; offset = "-01:00:00"; }];
      actions = [{
        action = "light.turn_on";
        target.entity_id = "light.sunlamp";
        data = { hs_color = [ 25 100 ]; brightness_pct = 50; transition = 60; };
      }];
    }
    {
      alias = "Sunlamp controller";
      triggers = map (command: {
        trigger = "event";
        event_type = "zha_event";
        event_data = { device_ieee = "b4:35:22:ff:fe:0b:06:24"; inherit command; };
      }) [ "on" "off" ];
      actions = [{
        "if" = "{{ trigger.event.data.command == 'on' }}";
        "then" = [{ action = "scene.turn_on"; target.entity_id = "scene.cozy_orange"; }];
        "else" = [{ action = "light.turn_off"; target.entity_id = "light.sunlamp"; }];
      }];
    }
    {
      alias = "Door notification";
      mode = "queued"; # quick open/close would otherwise be dropped as "Already running"
      triggers = map (command: {
        trigger = "event";
        event_type = "zha_event";
        event_data = { device_ieee = "d4:48:67:ff:fe:d3:64:f6"; inherit command; };
      }) [ "on" "off" ];
      actions = map (action: {
        inherit action;
        data = {
          message = "Door {{ 'opened' if trigger.event.data.command == 'on' else 'closed' }} at {{ now().strftime('%H:%M') }}";
          data = { priority = "high"; ttl = 0; }; # bypass Android doze batching
        };
      }) [ "notify.mobile_app_pixel_9_pro_xl" "notify.mobile_app_pixel7pro" ];
    }
    {
      alias = "Stereo follows TV";
      triggers = [{
        trigger = "state";
        entity_id = "media_player.samsungtv";
        to = [ "on" "off" ]; # ignore unavailable/unknown blips
      }];
      actions = [{
        action = "switch.turn_{{ trigger.to_state.state }}";
        target.entity_id = "switch.stereo";
      }];
    }
    {
      alias = "Klipper notification";
      mode = "queued";
      triggers = [{
        trigger = "webhook";
        webhook_id = "klipper-c50141fae98c1d52";
        allowed_methods = [ "POST" ];
        local_only = true;
      }];
      actions = [{
        action = "notify.mobile_app_pixel_9_pro_xl";
        data = {
          title = "{{ trigger.json.title | default('Klipper', true) }}";
          message = "{{ trigger.json.message }}";
          data = { priority = "high"; ttl = 0; }; # bypass Android doze batching
        };
      }];
    }
  ];
}
