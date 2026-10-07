{
  flake.modules.nixos.home-assistant.services.home-assistant.config.automation = [
    {
      alias = "Klaras remote";
      mode = "restart"; # wheel spams move_to_level, latest wins
      triggers = [{
        trigger = "event";
        event_type = "zha_event";
        event_data.device_ieee = "10:35:97:00:00:18:d7:3a";
      }];
      actions = [{
        choose = [
          {
            conditions = "{{ trigger.event.data.command == 'on' }}";
            sequence = [{ action = "light.turn_on"; target.entity_id = "light.klaras_kontorslampa"; }];
          }
          {
            conditions = "{{ trigger.event.data.command == 'off' }}";
            sequence = [{ action = "light.turn_off"; target.entity_id = "light.klaras_kontorslampa"; }];
          }
          {
            conditions = "{{ trigger.event.data.command == 'move_to_level' }}";
            sequence = [{
              action = "light.turn_on";
              target.entity_id = "light.klaras_kontorslampa";
              data.brightness = "{{ trigger.event.data.args[0] }}";
            }];
          }
        ];
      }];
    }
    {
      # PARASOLL (no ZHA quirk) sends on/off commands, binary_sensor never changes
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
