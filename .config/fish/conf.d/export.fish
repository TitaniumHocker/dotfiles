set --export PATH $HOME/bin $HOME/.local/bin $HOME/.cargo/bin $PATH
if type nvim >/dev/null 2>&1
    set --export EDITOR nvim
else if type vim >/dev/null 2>&1
    set --export EDITOR vim
else
    set --export EDITOR vi
end

if type pi >/dev/null 2>&1
    set --export PI_SKIP_VERSION_CHECK 1
end

set --export PYTHONSTARTUP $HOME/.pythonstartup
