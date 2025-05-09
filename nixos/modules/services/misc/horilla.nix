{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.horilla;
in
{
  options.services.horilla = {
    enable = lib.mkEnableOption "horilla";

    package = lib.mkPackageOption pkgs "horilla" {
      default = [ "horilla" ];
    };
  };

  user = lib.mkOption {
    type = lib.types.str;
    default = "horilla";
    description = ''
      The user horilla runs as. Should be left at default unless
      you have very specific needs.
    '';
  };

  group = lib.mkOption {
    type = lib.types.str;
    default = "horilla";
    description = ''
      The group horilla runs as. Should be left at default unless
      you have very specific needs.
    '';
  };

  restartIfChanged = lib.mkOption {
    type = lib.types.bool;
    description = ''
      Automatically restart the service on config change.
    '';
    default = true;
  };

  config = lib.mkIf cfg.enable {
    systemd.services.horilla = {
      description = "horilla";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      inherit (cfg) restartIfChanged;

      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package}
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
