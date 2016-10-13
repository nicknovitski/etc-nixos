{ pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/amazon-image.nix> ];
  ec2.hvm = true;

  programs.mosh.enable = true;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    newSession = true;
    shortcut = "a";
    terminal = "screen-256color";
    extraTmuxConf = ''
      set -sg repeat-time 600

      set -g quiet on

      ## note when something's happened in other windows
      set-window-option -g monitor-activity on
      set -g visual-activity on

      # MOUSE
      set -g mouse on
      ## scroll history with mouse
      bind -n WheelUpPane   select-pane -t= \; copy-mode -e \; send-keys -M
      bind -n WheelDownPane select-pane -t= \;                 send-keys -M
      
      # KEY BINDINGS
      # (list with prefix-?)

      # prefix-r: reload config file
      bind r source-file /etc/tmux.conf \; display "/etc/tmux.conf reloaded"

      # create new windows with prefix-c, and in the current path
      bind c new-window -c '#{pane_current_path}'

      ### split windows with prefix-v or |, and prefix-s or -
      unbind %
      unbind "
      bind s split-window -v -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      bind v split-window -h -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'

      ### cycle windows with with prefix-ctrl-(movement)
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      ## Copy Mode
      
      ## ESC (Ctrl-[) to enter copy mode
      bind Escape copy-mode
      
      ### prefix-H and L to move to the start or end of the line
      bind -t vi-copy H start-of-line
      bind -t vi-copy L end-of-line
      
      ### v to select select text
      bind -t vi-copy 'v' begin-selection
      
      ### y to copy
      bind -t vi-copy 'y' copy-selection
      
      ### ctrl-c to exit
      bind -t vi-copy C-c cancel
      
      ### paste with prefix-p
      unbind [
      unbind p
      bind p paste-buffer
    '';
  };
  
  i18n.defaultLocale = "en_US.UTF-8";

  users.extraUsers.nick = {
    isNormalUser = true;
    description = "Nick Novitski";
    extraGroups = [ "wheel" ];
  };
  
  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    rlwrap
    vim emacs25 sdcv
    git gitAndTools.hub silver-searcher ctags global
    typespeed gtypist 
    wget links weechat mutt parallel
    taskwarrior ledger newsbeuter
    awscli bashCompletion bashInteractive rcm
  ];
  
}
