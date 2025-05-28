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
abbr -a -- g git
abbr -a -- k kubectl
abbr -a -- c cargo
abbr -a -- dc docker compose

# Curl headers
abbr -a -- ch curl -D - -o /dev/null -s
