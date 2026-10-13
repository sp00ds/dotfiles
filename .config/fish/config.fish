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
    # fzf colors from Noctalia's wallpaper theme. The template appends to a
    # universal var, so clear it first or it grows on every new shell.
    if test -f ~/.config/fzf/themes/noctalia.fish
        set -eU FZF_DEFAULT_OPTS
        source ~/.config/fzf/themes/noctalia.fish
    end
    # z <partial-name> jumps to frequently used dirs
    type -q zoxide; and zoxide init fish | source
    # blinking line cursor at the prompt; back to kitty's default (block)
    # while a command runs, so vim/less etc. look normal
    function __beam_cursor --on-event fish_prompt
        echo -en "\e[5 q"
    end
    function __default_cursor --on-event fish_preexec
        echo -en "\e[0 q"
    end

    # prompt; colors come from Noctalia's starship template (~/.config/starship.toml)
    type -q starship; and starship init fish | source
end
