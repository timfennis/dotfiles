if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    set -g fish_greeting
    if command -sq starship
        starship init fish | source
    end
    if command -sq zoxide
        zoxide init --cmd j fish | source
    end
end

# Abbreviations
abbr -a -- k kubectl
abbr -a -- c cargo
abbr -a -- dc docker compose

# Curl
abbr -a -- ch curl -D - -o /dev/null -s
abbr --add cj --set-cursor "curl -s % | jq -C | less -x4FRs"

# Git
abbr -a -- g git

function current_branch
    set branch (git branch --show-current 2>/dev/null) && echo "$branch"
end

abbr --command git cb --function current_branch

abbr -a -- gff git pull --ff-only origin
abbr --command git o origin

alias php='docker run --rm -it -u (id -u):(id -g) -v (pwd):/app -w /app php:8.5-cli php'
alias composer='docker run --rm -it -u (id -u):(id -g) -v (pwd):/app -w /app -e COMPOSER_HOME=/tmp composer:2 composer'

alias docs='gocryptfs ~/Documents/Enc ~/Documents/Dec'
alias undocs='fusermount -u ~/Documents/Dec'
