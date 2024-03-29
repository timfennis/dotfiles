# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/bin:$HOME/.cargo/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# Some programs may use these variables to figure out what editor to use
export VISUAL=nvim
export EDITOR="$VISUAL"

# SSH_AUTH_SOCK stuff.. is this still needed?
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Enable sparse registry for cargo
export CARGO_UNSTABLE_SPARSE_REGISTRY=true

# Aliasses for various applications or commands running in docker
alias k=kubectl
alias noswifi="nmcli --ask device wifi connect \"NOS_InternetOnly\""
alias dc=docker-compose
alias ghci="docker run -it haskell"
alias vim="nvim"

# Run nodejs inside docker as if it was installed on your machine
function node-sh() {
  local TAG=latest
  local PORTS=()

  while getopts ":p:v:" OPTION; do
    case "$OPTION" in
      p)
	PORTS+=(-p "$OPTARG")
	;;
      v)
	TAG="$OPTARG"
	;;
    esac
  done

  shift $((OPTIND - 1))

  docker run \
	  --rm \
	  -u 1000:1000 \
      --net="host" \
	  -it --pull always \
	  "${PORTS[@]}" \
	  -v "$(pwd):/app" \
	  -w "/app" \
	  "node:$TAG" ${@:-bash} 
}

alias ns=node-sh

# Run gitleaks in docker 
function gitleaks() {
    docker run -v $(pwd):/data zricethezav/gitleaks $@
}

# These functions are for quick switching between main and external displays on the framework laptop
function edp() {
    xrandr --output DP1 --auto && xrandr --output eDP1 --off
    bash /home/tim/.fehbg
}

function mdp() {
    xrandr --output DP1 --off && xrandr --output eDP1 --auto
    bash /home/tim/.fehbg
}

# Git aliasses
unalias gpf
gpf () {
    local current_branch=$(git branch --show-current)
    local branch=${1:-$current_branch}
    echo "Pushing branch: $branch"
    git push --force origin $branch
}
alias gff="git pull --ff-only origin"
alias gpr="git pull --rebase origin"
alias core-proxy="oc -n nos-core port-forward svc/prod-proxy-core 8888:8080"

# Put the line below in ~/.zshrc:
#
#   eval "$(jump shell zsh)"
#
# The following lines are autogenerated:
# __jump_chpwd() {
#   jump chdir
# }
# 
# jump_completion() {
#   reply="'$(jump hint "$@")'"
# }
# 
# j() {
#   local dir="$(jump cd $@)"
#   test -d "$dir" && cd "$dir"
# }
# 
# typeset -gaU chpwd_functions
# chpwd_functions+=__jump_chpwd
# compctl -U -K jump_completion j

# Run Keychain when it's installed (currently only for the laptop)
if command -v keychain >/dev/null 2>&1; then
    eval `keychain --eval --agents ssh id_nos`
fi

exec fish
