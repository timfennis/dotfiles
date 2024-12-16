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
