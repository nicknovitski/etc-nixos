{ pkgs, ... }:

let
  pkg = pkgs.callPackage ./occupado { };
in

{
  config = {
    systemd.services.shutter = {
      description = "Shut down the system when no-one's been logged in for an hour";
      script = "${pkg}/bin/occupado";
      serviceConfig.Type = "simple";
      onFailure = [ "halt.target" ];
    };

    systemd.timers.shutter = {
      description = "runs shutter service every hour, ten minutes before billing time";
      timerConfig = { OnBootSec = "50minutes"; OnUnitActiveSec = "1hour"; };
      wantedBy = [ "timers.target" ];
    };
  };
}
