{ pkgs }:

let
  vimrc = import ./vimrc.nix { inherit pkgs;};
in
pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = vimrc.config;
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    # full documentation at github.com/MarcWeber/vim-addon-manager
    vimrcConfig.vam.pluginDictionaries = [
      { names = [
        "Solarized"
        "Syntastic"
        "Tabular"
        "Tagbar"
        "commentary"
        "ctrlp"
        "fugitive"
        "rainbow_parentheses"
        "sensible"
        "sleuth"
        "surround"
        "unite-vim"
        "vim-airline"
        "vim-eunuch"
        "vim-signify"
        "vinegar"
        ];
      }
      { name = "elm-vim"; filename_regex = "^.elm\$"; }
      { name = "vim-nix"; filename_regex = "^.nix\$"; }
      { name = "rust-vim"; filename_regex = "^.rs\$"; }
      # TODO: make all these available
      #"dispatch"
      # { name = "elixir-lang/vim-elixir"; }
      # { name = "calebsmith/vim-lambdify"; }
      # https://github.com/editorconfig/editorconfig-vim#readme
      # { name = "matze/vim-move"; }
      # { name = "moll/vim-node"; }
      # { name = "othree/html5.vim"; }
      # { name = "paredit.vim"; }
      # { name = "phongvcao/vim-stardict"; }
      # { name = "rodjek/vim-puppet"; filename_regex = "^.pp\$"; }
      # { name = "guns/vim-clojure-highlight"; }
      #{ name = "jeffkreeftmeijer/vim-numbertoggle"; }
      # Plug 'Quramy/vison'
      # 'tmux-plugins/vim-tmux'
      # 'tpope/vim-abolish'
      # 'tpope/vim-bundler'
      # 'tpope/vim-dispatch'
      # 'tpope/vim-endwise'
      # 'tpope/vim-fireplace'
      # 'tpope/vim-leiningen'
      # 'tpope/vim-projectionist'
      # 'tpope/vim-repeat'
      # 'tpope/vim-rails'
      # 'tpope/vim-rake'
      # 'tpope/vim-rsi'
      # 'tpope/vim-tbone'
      # 'tpope/vim-unimpaired'
    ];
  }
