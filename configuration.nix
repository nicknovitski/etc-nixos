{ pkgs, ... }:

let
  myVim = pkgs.callPackage ./vim.nix { };
  pinboard = pkgs.python27Packages.buildPythonApplication rec {
      version = "1.0.0";
      name = "${pname}-${version}";
          pname = "pinboard";
          src = pkgs.fetchurl {
            url = "mirror://pypi/p/${pname}/${name}.tar.gz";
            sha256 = "00f1khgx925691grdwvn1bqb1mbxdx33cwa7mnhbss570ja7mjqs";
          };
          checkPhase = ''
            ${pkgs.pythonPackages.python.interpreter} setup.py test
          '';
      };
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
    ./occupado/nixos.nix
    ];

  ec2.hvm = true;


  programs = {
    bash.enableCompletion = true;
    mosh.enable = true;
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      keyMode = "vi";
      shortcut = "a";
      newSession = true;
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
        ### split windows with prefix-v and prefix-s
        unbind %
        unbind '"'
        bind s split-window -v -c '#{pane_current_path}'
        bind v split-window -h -c '#{pane_current_path}'

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

        #### enter to move down a line instead of exit copy mode
        # todo
        
        ### paste with prefix-p
        unbind [
        unbind p
        bind p paste-buffer

        # TMUX Plugin Manager
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'tmux-plugins/tmux-copycat'
        set -g @plugin 'tmux-plugins/tmux-pain-control'

        run '~/.tmux/plugins/tpm/tpm'
      '';
    };
  };
  
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.allowedTCPPorts = [ 4000 8000 ];

  users.extraUsers.nick = {
    isNormalUser = true;
    description = "Nick Novitski";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmhtS3YZgxvJkPkZhqdI2Lr+x2mXVfFvZvhK5Wap5UyXu1kDQz33YVDIt+HdB0ILsi1HR7+4sQq7sIEX5LOcULAvlq7o8kq+09vBB1Vddouo+RRKPtbO6w47lfNFm4bV4qVwpXfLLt/Mch1/f/ICNW+U3hfwCgnWYkTIR87C/aCfOMvCychGcrmVmBjS2LHR+aUozJz4EHYsGsAFUVEUWw+GQp+XrKYA4ewWwKFo+zPQhUKWG5bMShuAshWp2lGDrt8aOY6IUpV173My2Lx1sDFpcfSrCcB9rl86eMer9dMAyDxop91a042jG3GsnXc+OWbQKVF+fx1EyEKA21nbVv nicknovitski@gmail.com"
      "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBF60PLb/lEXePTrESf65X9Ox18q2t1AZGKjPntnBWWCNv5AjT25SOgEYham1Wj/qPHWVBVViBfIUg4Ux+ThNu03I9hFPyor7KbxBMyfX3Il4X/fT3Wi/c83SGr4x6d/NrA== JuiceSSH"
     ];
  };
  security.sudo.wheelNeedsPassword = false;
  
  environment.variables = {
    EDITOR = "vim";
    BROWSER = "tmux new-window links";
  };

  environment.systemPackages = with pkgs; [
    rlwrap
    myVim emacs25 sdcv
    git gitAndTools.hub silver-searcher universal-ctags global
    typespeed gtypist 
    wget links weechat mutt parallel
    taskwarrior tasksh ledger newsbeuter tmuxinator
    awscli bashInteractive rcm
  ];
}
