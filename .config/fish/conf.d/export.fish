set --export PATH $HOME/bin $HOME/.local/bin $HOME/.config/emacs/bin $PATH

if type nvim >/dev/null 2>&1
    set --export EDITOR nvim
else if type vim >/dev/null 2>&1
    set --export EDITOR vim
else
    set --export EDITOR vi
end
