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

function __sync_tmux_session_env --description "Refresh GUI/session vars from tmux when attached"
    if not set -q TMUX
        return
    end

    if not command -sq tmux
        return
    end

    for var in DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE SSH_AUTH_SOCK
        set -l value (tmux show-environment -gqv $var 2>/dev/null)
        if test -n "$value"
            set -gx $var $value
        end
    end

    if set -q XDG_RUNTIME_DIR; and set -q UID
        if not set -q SWAYSOCK; or test -z "$SWAYSOCK"; or not test -S "$SWAYSOCK"
            set -l live_swaysock (ls -t $XDG_RUNTIME_DIR/sway-ipc.$UID.*.sock 2>/dev/null | head -n 1)
            if test -n "$live_swaysock"
                set -gx SWAYSOCK $live_swaysock
                tmux set-environment -g SWAYSOCK "$live_swaysock" >/dev/null 2>&1
            end
        end
    end
end

function __sync_tmux_session_env_preexec --on-event fish_preexec
    __sync_tmux_session_env
end

if status is-interactive
    __sync_tmux_session_env
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
