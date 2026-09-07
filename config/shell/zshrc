# GQYOS Zsh Configuration
# 为顾清影而造

# ========== 基础 ========== #
setopt interactive_comments
setopt no_nomatch
setopt menu_complete
setopt glob_dots

# 历史
HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# ========== 插件 ========== #
# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
bindkey '^[[A' history-search-backward  # 上箭头搜索
bindkey '^[[B' history-search-forward

# zsh-syntax-highlighting (必须最后加载)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# zsh-completions
fpath+=(/usr/share/zsh/site-functions)
autoload -Uz compinit && compinit

# fzf
source <(fzf --zsh) 2>/dev/null

# zoxide
eval "$(zoxide init zsh)" 2>/dev/null

# ========== 补全设置 ========== #
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# ========== 别名 ========== #
# ls → eza
alias ls='eza --group-directories-first'
alias ll='eza -la --group-directories-first --git'
alias lt='eza -la --group-directories-first --tree --level=2'
alias la='eza -a --group-directories-first'

# cat → bat
alias cat='bat --paging=never'
alias catp='bat'

# cd → zoxide
alias cd='z'

# find → fd
alias find='fd'

# grep → ripgrep
alias grep='rg'

# git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gb='git branch'

# 系统
alias pac='sudo pacman'
alias pacs='pacman -Ss'
alias paci='pacman -Si'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Sc && sudo pacman -Scc'
alias mirror='sudo reflector --country China --latest 20 --sort rate --save /etc/pacman.d/mirrorlist'

# 工具
alias ports='ss -tulnp'
alias disks='df -h'
alias mem='free -h'
alias top='btop'
alias weather='curl wttr.in'
alias myip='curl -s ifconfig.me'

# ========== 快捷键 ========== #
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[3~' delete-char        # Delete
bindkey '^[[1;5C' forward-word     # Ctrl+→
bindkey '^[[1;5D' backward-word    # Ctrl+←

# ========== 函数 ========== #
# 快速创建并进入目录
mkcd() { mkdir -p "$1" && cd "$1"; }

# 解压任何压缩包
ex() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.Z)       uncompress "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "'$1' cannot be extracted" ;;
  esac
}

# 快速 git 提交
gac() {
  git add -A && git commit -m "${1:-$(date +'%Y-%m-%d %H:%M')}"
}

# 快速查找进程
psf() { ps aux | grep -i "$1" | grep -v grep; }

# ========== 提示符 ========== #
# 简洁的 git 提示符
setopt PROMPT_SUBST
PROMPT='%(?.%F{green}✓%f.%F{red}✗%f) %F{blue}%~%f%F{magenta}$(__git_ps1 " (%s)")%f
%F{cyan}❯%f '
RPROMPT='%F{yellow}%*%f'

# git prompt 支持
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %b'
