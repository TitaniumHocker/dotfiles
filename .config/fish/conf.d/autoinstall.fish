function guessos
    [ -f /etc/os-release ] || echo "dotfiles: /etc/os-release not found" >&2
    echo (cat /etc/os-release | perl -lne 'if($_ =~ /^(code)?name ?= ?[\'"](\w+)( Linux)?[\'"]$/i){print lc $2;}')
end

if status is-interactive
    # Guards
    set os (guessos)
    [ -z $os ] && return # failed to guess os
    [ -d $HOME/.config/fish/autoinstall/$os ] || return # os not supported
    [ -f $HOME/.config/fish/.autoinstall ] && return # already installed

    echo "dotfiles: making bootstrap..."

    if $os = "bullseye"
        sudo apt-get update -y
        set osinstall sudo apt-get install -y
    else if $os = "manjaro"
        sudo pacman -Sy
        set osinstall sudo pacman -Suy
    else if $os = "arch"
        sudo pacman -Sy
        set osinstall sudo pacman -Suy
    else if $os = "void"
        sudo xbps-install -Sy
        sudo xbps-install -uy void-repo-multilib void-repo-nonfree
        sudo xbps-install -Sy
        set osinstall sudo xbps-install -Suy
    end
    $osinstall (cat $HOME/.config/fish/autoinstall/$os | xargs)

    echo "dotfiles: bootstrap completed"
    echo $os >$HOME/.config/fish/.autoinstall
end
