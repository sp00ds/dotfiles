#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
PS1='[\u@\h \W]\$ '

complete -cf sudo
# fastfetch: photo strip in kitty, small Arch logo elsewhere (see ~/.config/fastfetch)
if [[ $TERM == xterm-kitty ]]; then
    fastfetch
else
    fastfetch -c ~/.config/fastfetch/small.jsonc
fi
