if not type omf >/dev/null 2>&1
    echo "Oh my fish not found, installing..."
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    echo "Installing theme..."
    fish -c "omf install bira"
    fish -c "omf theme bira"
end
