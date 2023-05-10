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

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export VISUAL=vim
export EDITOR="$VISUAL"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

alias k=kubectl
alias noswifi="nmcli --ask device wifi connect \"NOS_InternetOnly\""
alias dc=docker-compose
alias gff="git pull --ff-only origin"
alias gpr="git pull --rebase origin"
alias gpf="git push -f origin"
alias ghci="docker run -it haskell"

node-sh() {
  local version="latest"
  local docker_image="node:${version}"

  while getopts ":v:" opt; do
    case $opt in
      v) docker_image="node:${OPTARG}" ;;
      \?) echo "Invalid option: -$OPTARG" >&2 ;;
    esac
  done

  shift $((OPTIND - 1))

  if [[ $# -eq 0 ]]; then
    docker run -u 1000:1000 -v "$(pwd):/app" -w /app -it "$docker_image" bash
  else
    docker run -u 1000:1000 -v "$(pwd):/app" -w /app -it "$docker_image" "$@"
  fi
}

alias ns=node-sh

function youtube-dl() {
    docker run -w /app -v $(pwd):/app -it --user 1000:1000 vimagick/youtube-dl $@
}
function gitleaks() {
    echo $@;
    docker run -v $(pwd):/data zricethezav/gitleaks $@
}

function edp() {
    xrandr --output DP1 --auto && xrandr --output eDP1 --off
    bash /home/tim/.fehbg
}

function mdp() {
    xrandr --output DP1 --off && xrandr --output eDP1 --auto
    bash /home/tim/.fehbg
}

unalias gpf
gpf () {
    local current_branch=$(git branch --show-current)
    local branch=${1:-$current_branch}
    echo "Pushing branch: $branch"
    git push --force origin $branch
}

eval `keychain --eval --agents ssh id_nos`
