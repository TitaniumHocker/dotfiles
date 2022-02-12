set use_gpg_for_ssh true

if $use_gpg_for_ssh
    if [ -z "$gnupg_SSH_AUTH_SOCK_by" ];
        set gnupg_SSH_AUTH_SOCK_by -1
    end

    set --erase SSH_AGENT_PID

    if [ "$gnupg_SSH_AUTH_SOCK_by" -ne "$fish_pid" ];
        set --export --global SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end

    set --export --global GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    echo "Attached GnuPG as SSH auth method"
end
