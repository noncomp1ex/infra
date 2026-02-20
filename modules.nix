{
  pkgs,
  lib,
  ...
}: {
  system.stateVersion = "25.05";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = false;
        device = "/dev/sda";
      };
    };

    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };
  };

  networking.useDHCP = lib.mkDefault true;

  networking.hostName = "noninfra";

  time.timeZone = "Europe/Amsterdam";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = ["crolbar"];
    };
  };

  users.users.crolbar = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCh30ov7jHyWo0rzawL0Fc9SrrUaDjAYrsFiPnoxdSdchYXkmApPxZtz15UwNn0q9Xs3J9XPs/52xO76l8RmnJuvNWr8FMgBCX6UPYv0mCpA7WhFtpBTmL5v/xYbbodRNe5+ZE8a1NCM7X7qZfDPbT6BSEKXjucEM+k2SOkOvsKoiVyyOyjJJedoGgTLiGNXXaRlPZ1zyWJx6SoKL9gEo46Xw+NQT0Yl+n3lc3x8V7H2GEPugfiTjuRhhar94QFKSXYouamChemoIi0KB5Q2rRFa0RaFIGNrB0jhe6O6mF9KRcj3pPgv2yq5YYUp7WVSh78eNQMQ1oqIpXbHcUmePEpqLWsPUuAm3v6nPrFDaL3CKXu4ylxDw+sXw/arD1jh6J/oQH3TEngLJ4AhvaKgnRIAWKjWgp4zmwcdPe8eu59cmL4eXsX9pimt0+JxQLcoFrd7EAicp7ww6G5MedAMmO4si2sJ0YW/4QFMBSxYd8OCNxfW52itchnLob1+2EAhXO8fAY9drZirhhNxCaXY2fVCKBMWjveR79SHg8it48bbOaZVg2j2CStjxbbyAZRCFpq80Pn31JutoCvgfHP8qHuJQusg1ca1fcPzhlYXtuZ/8nTz2ghXy/9F+ZwqCX1BMeDDBQXCaHhUutDl3p0Y2Sxyxqv/BIXurPy9KwZ/sYQ/Q== crolbar@308"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtqrRAGCPikoJLsp0N612KkbRA58gj3WJazEmZyu34+WLBQ3j27bmdD/QnnVWJTNYb9DT45hTj+yhumCJKE9iJjYH6bGl3X7k/1MsWTqvHVp7JT2k+XO51mav1meD2uEwsjq5OVGjlAMJcdtBzbXlpiyJv/14BmL2tY8c/7OfM/NqbOXQlJuMcRTBm7EN+sFr6Z3o3sYpNEuTdKnUGwAOt0Cw+dZZDImvP8JdgITMKgbw5jxTRLslgc6TuGzvb8f14wpEpInZDTHeVesxLnkHzr1CVvR6ySfYZfP2JcZxSM41zAi6PhilZdt8dqjQs0A3RnaHq1BrIYWg7VYWUx24JZcrk6j8eKSANfUCkeYdPJOqI76ZGSMF8yCD5kEOo5IxvFFzhtHDsQjz7LNwWNPb+ROhtHojoqEaVrWyVdOHcbTdnlDhnOzE1/Hu3akZxWBrycSZUVX6K9C7CwGN7FWZceG3T/IyhTBcs8NXgYftEOzJ/wvvbTfUBWvchSmCmC5c= plier@plier"
    ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$y$j9T$vRxv3vPo5oX1UuiSmJF5V/$MzK8chBLfjKPtHJ1OiMOBAXe.i/ykFvclahtkUWUh8B";
    shell = pkgs.zsh;
  };

  users.users.root = {
    hashedPassword = "$y$j9T$vRxv3vPo5oX1UuiSmJF5V/$MzK8chBLfjKPtHJ1OiMOBAXe.i/ykFvclahtkUWUh8B";
  };

  programs.zsh = {
    enable = true;

    shellInit = ''
      bindkey -v

      # Ctrl + right
      bindkey '^[[1;5C' forward-word
      # Ctrl + left
      bindkey '^[[1;5D' backward-word

      # Ctrl + BS
      bindkey '^H' backward-kill-word
      bindkey '^W' backward-kill-word

      # Ctrl + del
      bindkey '^[[3;5~' kill-word

      # Shift + tab in complete
      bindkey '^[[Z' reverse-menu-complete

      ## vim delte char bug
      bindkey "^?" backward-delete-char
      bindkey "^[[127;5u" backward-kill-word

      # edit cmd line with $EDITOR
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^E" edit-command-line
      bindkey -M vicmd "^E" edit-command-line

      bindkey -M viins '^R' history-incremental-search-backward
      bindkey -M vicmd '^R' history-incremental-search-backward

      setopt PROMPT_SUBST        # enable command substitution in prompt
      setopt MENU_COMPLETE       # Automatically highlight first element of completion menu

      zstyle ':completion:*' verbose true
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d"
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS} 'ma=48;5;197;1'
      zstyle ':completion:*:descriptions' format "%F{yellow}[-- %d --]%f"
    '';

    shellAliases = let
      zsh = lib.getExe pkgs.zsh;
    in {
      ns = "nix-shell --command \"bash -c \\\"SHELL=${zsh} && ${zsh}\\\"\"";
      nd = "nix develop --command bash -c \"SHELL=${zsh} && \"${zsh}\"\"";
      t = "tmux";
    };

    syntaxHighlighting = {
      enable = true;
      patterns = {"rm -rf *" = "fg=black,bg=red";};
      highlighters = ["brackets" "pattern"];
    };
  };

  programs.yazi.enable = true;
  programs.starship.enable = true;
  programs.git.enable = true;
  programs.lazygit.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    # neovim
    wget
    btop
    htop
    tmux

    # mcrcon
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # services.nginx = {
  #   enable = true;
  #   virtualHosts."crol.bar" = {
  #     locations."/" = {
  #       root = "/var/www/crol.bar";
  #     };
  #   };
  # };

  # services.caddy = {
  #   enable = true;
  #   virtualHosts = {
  #     "crol.bar" = {
  #       extraConfig = ''
  #         root * /var/www/html
  #         file_server
  #         handle /api/* {
  #           reverse_proxy localhost:8081
  #         }
  #       '';
  #     };
  #   };
  # };

  nixpkgs.config.allowUnfree = true;

  services.teamspeak3.enable = true;

  # services.minecraft-server = {
  #   enable = true;
  #   eula = true;

  #   declarative = true;
  #   serverProperties = {
  #     "online-mode" = false;

  #     enable-rcon = true;
  #     "rcon.password" = "1234";
  #     "rcon.port" = 25575;
  #   };
  # };

  # services.terraria = {
  #   enable = true;
  # };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
      3478
      9000

      # 7777 # terraria
      # 25565 # mc
    ];
    allowedUDPPorts = [
      3478
      5349
      9987 # teamspeak
      # 7777
    ];
    allowedUDPPortRanges = [
      {
        from = 50000;
        to = 51000;
      }
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "ext4";
  };
}
