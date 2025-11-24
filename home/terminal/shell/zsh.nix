{ pkgs, lib, config, ... }:

let
    cfg = config.settings.home.terminal.shell.zsh;

    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
        programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;
            envExtra = "HOSTNAME=$(hostname)";
            initContent = ''
                if [ -e "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
                  . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
                fi

            '';
        };

        home.packages = with pkgs; [
            zsh-autocomplete
            zsh-syntax-highlighting
            zsh-autosuggestions
        ];
    }; 
}
