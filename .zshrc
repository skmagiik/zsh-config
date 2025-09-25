export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git fzf-tab)

source $ZSH/oh-my-zsh.sh

# User configuration


# Set to 1 to print version information and other debug during zsh init for the dependency checking.
local -i deps_check_debug=0

if (( $+commands[git] )); then
  (( deps_check_debug )) && git --version
  # Ensure nvim is our git editor of choice
  git config --global core.editor nvim
else
  echo "git not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y git; then
      echo "git installed."
    else
      echo "Failed to install git with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install eza via your package manager."
  fi
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -Uz is-at-least
local req_fzf="0.65.2"
local fzf_acceptable=0

if (( $+commands[fzf] )); then
  # Grab just the version number from: "0.65.2 (commit)"
  local cur_ver=${"$(fzf --version 2>/dev/null)%% *"}
  if is-at-least "$req_fzf" "$cur_ver"; then
    (( deps_check_debug )) && echo "fzf $cur_ver OK (>= $req_fzf)."
    fzf_acceptable=1
  else
    echo "fzf $cur_ver is older than required $req_fzf."
  fi
else
  (( deps_check_debug )) && echo "fzf not found."
fi

if (( ! fzf_acceptable )); then
  if (( ! $+commands[git] )); then
    echo "git is required to install fzf. Please install git first. (NOTE: This should never show up since git is checked before fzf)"
  else
    echo "Installing/updating fzf in ~/.fzf ..."
    if [[ -d "$HOME/.fzf/.git" ]]; then
      git -C "$HOME/.fzf" fetch --depth 1 origin && git -C "$HOME/.fzf" reset --hard FETCH_HEAD || echo "Update attempt failed; proceeding to run installer anyway."
    else
      rm -rf "$HOME/.fzf"
      git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" || echo "git clone failed."
    fi
    "$HOME/.fzf/install"
  fi
fi

if (( $+commands[eza] )); then
  eza_ver="$(eza --version | sed -n '2p')"
  (( deps_check_debug )) && echo "eza $eza_ver"
  alias ls="eza --color=always --icons=always"
else
  echo "eza not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y eza; then
      echo "eza installed."
      alias ls="eza --color=always --icons=always"
    else
      echo "Failed to install eza with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install eza via your package manager."
  fi
fi

if (( $+commands[curl] )); then
  (( deps_check_debug )) && curl --version | head -n 1
else
  echo "curl not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y curl; then
      echo "curl installed."
    else
      echo "Failed to install curl with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install curl via your package manager."
  fi
fi


if (( $+commands[starship] )); then
  (( deps_check_debug )) && starship --version | head -n 1
else
  echo "starship not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y starship; then
      echo "starship installed."
    else
      echo "Failed to install starship with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install starship via your package manager."
  fi
fi

if (( $+commands[cargo] )); then
  (( deps_check_debug )) && cargo --version
else
  echo "cargo not found. Attempting to install via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi


if [ ! -x "$HOME/.cargo/bin/binwalkv3" ]; then
  echo "Cargo binwalk (v3) not found; installing…"
  if command -v cargo >/dev/null 2>&1; then
    cargo install binwalk
    mv "$HOME/.cargo/bin/binwalk" "$HOME/.cargo/bin/binwalkv3"
  else
    echo "cargo not found. Install Rust (rustup) first: https://rustup.rs"
  fi
else
  (( deps_check_debug )) && cargo install --list | grep -E '^binwalk[[:space:]]+v' | sed 's/://'
fi

if (( $+commands[glow] )); then
  (( deps_check_debug )) && glow --version
else
  echo "glow not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y glow; then
      echo "glow installed."
    else
      echo "Failed to install glow with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install glow via your package manager."
  fi
fi

if (( $+commands[tmux] )); then
  (( deps_check_debug )) && tmux -V
else
  echo "tmux not found. Attempting to install with apt..."
  if (( $+commands[apt] )); then
    # Use non-interactive sudo if possible
    if sudo -n true 2>/dev/null; then SUDO="sudo -n"; else SUDO="sudo"; fi
    if $SUDO apt update && $SUDO apt install -y tmux; then
      echo "tmux installed."
    else
      echo "Failed to install tmux with apt. Please install it manually."
    fi
  else
    echo "apt not found on this system. Please install tmux via your package manager."
  fi
fi

local req_nvim="0.11.4"
local nvim_acceptable=0

if (( $+commands[nvim] )); then
  # Grab just the version number from: "0.65.2 (commit)"
  local cur_ver=${"$(nvim --version | head -n 1 2>/dev/null)"}
  if is-at-least "$req_nvim" "$cur_ver"; then
    (( deps_check_debug )) && echo "$cur_ver OK (>= $req_nvim)."
    nvim_acceptable=1
  else
    echo "nvim $cur_ver is older than required $req_nvim. Attempting to refresh"
    sudo snap refresh nvim
  fi
else
  echo "nvim not found."
  if (( ! $+commands[snap] )); then
    echo "git is required to install nvim. Please install snap first or manually install neovim "
  else
    echo "Installing/updating nvim via snap..."
    sudo snap install nvim
  fi
fi


alias sv="source venv/bin/activate"
alias binwalkv3="~/.cargo/bin/binwalkv3"

readme() {
  emulate -L zsh
  setopt localoptions extendedglob         # enable (#i) etc. just here

  # expand into an array
  local -a matches=(./(#i)readme.(md|markdown|rst|txt)(N))
  if (( $#matches )); then
    glow -w 0 -- "$matches[1]"                  # first match
  else
    print -u2 "No README found."
    return 1
  fi
}

todo() {
  emulate -L zsh
  setopt localoptions extendedglob         # enable (#i) etc. just here

  # expand into an array
  local -a matches=(./(#i)todo.md(N))
  if [[ $# = 1 ]] ; then
    if [[ $1 = "e" ]] || [[ $1 = "edit" ]]; then
      if (( $#matches )); then
        nvim "$matches[1]"
      else
        nvim todo.md
      fi
    else
     print -u2 "Usage: todo [e/edit]"
    fi
  else
    if (( $#matches )); then
      clear
      glow -w 0 -- "$matches[1]"                  # first match
    else
      print -u2 "No todo.md found."
      return 1
    fi
  fi
}

eval "$(starship init zsh)"

if [[ "$TMUX" ]]; then
  bindkey -s '^h' 'tmux capture-pane -p -S -30000 | nvim -\n'
fi



