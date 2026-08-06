get_os_logo() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
      "ubuntu")
        echo "%F{#E95420}󰕈%f";;
      "debian")
        echo "%F{#A80030}󰣚%f";;
      "fedora")
        echo "%F{#55A4E4}󰣛%f";;
      "arch")
        echo "%F{#1793D1}󰣇%f";;
      *) 
        echo "%F{#EEEEEE}%f";;
    esac
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "%F{#A6A6A6}󰀵%f"
  else
    echo "%F{#AAAAAA}%f"
  fi
}

get_git_info() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi

  local branch_name
  branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    branch_name="(initial)"
  fi
  
  local status_indicator=""
  if [[ -n "$(git status --porcelain)" ]]; then
    status_indicator="%F{yellow}*"
  fi

  echo "%F{green}[%F{yellow}$status_indicator%F{blue}$branch_name%F{green}]%f"
}

setopt PROMPT_SUBST

PS1="%B$(get_os_logo) %F{blue}%n@%M%F{green} [%~]%b%f %(!.#.$) "
RPROMPT='$(get_git_info)'

# HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Directory
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB

# Completion
setopt AUTO_MENU
setopt COMPLETE_IN_WORD

# Alias
## Navigation
alias ..="cd .."
alias ...="cd ../.."

## Listing files
alias ls='ls --color=auto' 
alias ll='ls -lha'        
alias la='ls -A'           

## Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

## Random
alias ssh='kitten ssh'
alias cat='bat'
alias man='batman'


# Exports
export EDITOR='nvim'
export VISUAL='nvim'

path+=(
  "$HOME/dev/flutter/bin"
  "$HOME/.pub-cache/bin"
  "$HOME/go/bin"
  "$HOME/.fly/bin"
  "$HOME/.fvm_flutter/bin"
)


eval "$(zoxide init zsh)"

source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$HOME/.zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

zstyle ':autocomplete:*' min-input 3
zstyle ':autocomplete:*' delay 0.5  # seconds (float)

\cat .cache/wal/sequences
fastfetch
