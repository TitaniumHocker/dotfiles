if [ ! -z "$FISH_NO_TMUX" ]
    return
end

if status is-interactive && command -v tmux >/dev/null 2>&1 && [ -d "$HOME/.tmux" ]
    if ! type tmux >/dev/null 2>&1
        echo "dotfiles: tmux is not installed" >&2
        return
    end
    tmux new -As S >/dev/null 2>&1
    if [ "$TERM" = "tmux-256color" ]
        set --global --export TERM "screen-256color"
    end
end

