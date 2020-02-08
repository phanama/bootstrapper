if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setting PATH for Python 3.8
export PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"

export PATH="$PATH:$HOME/Library/Python/3.8/bin/"
alias k="kubectl"
alias kc="kubectl"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

#alias BSD tools to GNU tools
alias tar=gtar
alias sed=gsed
alias awk=gawk
alias find=gfind
alias date=gdate
alias time=gtime

source ~/.kube-ps1/kube-ps1.sh
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

alias vim=nvim

