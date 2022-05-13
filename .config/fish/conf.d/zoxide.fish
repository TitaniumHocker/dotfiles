if type zoxide >/dev/null 2>&1 and not type z >/dev/null 2>&1
    zoxide init fish | source
    zoxide init fish > $HOME/.config/fish/conf.d/_zoxide.fish
end
