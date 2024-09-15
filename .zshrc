# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null ; then
            arch+=("${pkg}")
        else 
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Helpful aliases
alias sdn="shutdown now"
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list

# alias ls='eza -1   --icons=auto' # short list
# alias code='zed' # runs zed code editor

alias ls='lsd' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -

# Neovim alias
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias bcount='{ echo -n "battery cycle count: " ; cat /sys/class/power_supply/BAT*/cycle_count; }'

# Arduino related alias
# Arduino CLI Aliases

alias opusb='sudo chmod a+rw /dev/ttyUSB0 '
alias arduino-board="arduino-cli board attach /dev/ttyUSB0 arduino:avr:uno"
alias arduino-compile="arduino-cli compile --fqbn arduino:avr:uno"
alias arduino-upload="arduino-cli upload -p /dev/ttyUSB0 --fqbn arduino:avr:uno"
alias arduino-monitor="arduino-cli monitor -p /dev/ttyUSB0"

alias arduino-make="make -f ~/Arduino/ArduinoMakefile"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Display Pokemon
pokemon-colorscripts --no-title -r

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$HOME/.local/bin:$PATH

# Set up fzf key bindings and fuzzy bash_completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --typed=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
#  - The first argument to hte function ($1) is the base path to start traversal
#  - See the source ode (completion.{bash,zsh}) for the details.

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list of directoriy completion
_fzf_compgen_dir() {
  fd --typed=d --hidden --exclude .git . "$1"
}

source ~/GitHub/fzf-git.sh/fzf-git.sh

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization for fzf options via _fzf_comprun function
#  - The first argument to the function is the name of the command,
#  - You should make sure to pass the rest of the arguments to fzf,

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in 
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$0" ;;
    export|unset) fzf --preview "eval 'echo \$ {}"          "$0" ;;
    ssh)          fzf --preview 'dig {]'                     "$0" ;;
    *)            fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$0" ;;
  esac
}


# ---- Bat (better cat) ----
export BAT_THEME="Catppuccin Mocha"
