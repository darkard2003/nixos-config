{ config, pkgs, username, ... }:

{
  home.shellAliases = {
    nswitch = "sudo nixos-rebuild switch --flake '/home/${username}/nixos-config#dark-nix'";
    nboot = "sudo nixos-rebuild boot --flake '/home/${username}/nixos-config#dark-nix'";
    ntest = "nix build '/home/${username}/nixos-config#nixosConfigurations.dark-nix.config.system.build.toplevel' --dry-run";
    nclean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    ".." = "cd ..";
    "..." = "cd ../..";
    ls = "ls --color=auto";
    ll = "ls -lha";
    la = "ls -A";
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline --graph --decorate";
    ssh = "kitten ssh";
    cat = "bat";
    man = "batman";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      share = true;
      ignoreAllDups = true;
    };

    initContent = ''
      get_git_info() {
        if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          return
        fi
        local branch_name
        branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(initial)")
        local status_indicator=""
        if [[ -n "$(git status --porcelain)" ]]; then
          status_indicator="%F{yellow}*"
        fi
        echo "%F{green}[%F{yellow}$status_indicator%F{blue}$branch_name%F{green}]%f"
      }

      setopt PROMPT_SUBST
      PS1="%B%F{#7ebbe6}%f %F{blue}%n@%M%F{green} [%~]%b%f %(!.#.$) "
      RPROMPT='$(get_git_info)'

      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt EXTENDED_GLOB
      setopt AUTO_MENU
      setopt COMPLETE_IN_WORD

      [ -f "$HOME/.cache/wallust/colors.sh" ] && source "$HOME/.cache/wallust/colors.sh"
      command -v fastfetch &>/dev/null && fastfetch
    '';
  };
}
