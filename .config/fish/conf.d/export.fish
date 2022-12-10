set --export --global PATH $PATH:$HOME/bin:$HOME/.local/bin

if type nvim >/dev/null 2>&1
    set --export --global EDITOR nvim
else if type vim >/dev/null 2>&1
    set --export --global EDITOR vim
else
    set --export --global EDITOR vi
end

if [ -d "$HOME/Games" ];
    set --export --global PATH $PATH:$HOME/Games
end
