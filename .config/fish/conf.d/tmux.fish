if status is-interactive && command -v tmux >/dev/null 2>&1 && [ -d "$HOME/.tmux" ]
    tmux new -As S >/dev/null 2>&1
end

if [ "$TERM" = "tmux-256color" ]
    set --global --export TERM "screen-256color"
end
