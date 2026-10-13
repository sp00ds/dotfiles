if status is-interactive
    # no "Welcome to fish" banner (fastfetch replaces it)
    set -g fish_greeting

    alias grep='grep --color=auto'
    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # fastfetch: photo strip in kitty, small Arch logo elsewhere (see ~/.config/fastfetch)
    if test "$TERM" = xterm-kitty
        fastfetch
    else
        fastfetch -c ~/.config/fastfetch/small.jsonc
    end

    # Ctrl+R fuzzy history, Ctrl+T fuzzy file picker, Alt+C fuzzy cd
    type -q fzf; and fzf --fish | source
    # z <partial-name> jumps to frequently used dirs
    type -q zoxide; and zoxide init fish | source
end
