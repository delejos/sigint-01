if status is-interactive
  fastfetch  
  starship init fish | source
end

set -x EDITOR nano
set -x TERMINAL kitty
set -x BROWSER firefox

alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias cat='bat'
alias top='btop'
alias vim='nvim'

