if status is-interactive
    if type exa >/dev/null 2>&1
        abbr ls exa
        abbr ll exa -lh
        abbr la exa -lah
    else
        echo "dotfiles: exa is not installed" >&2
        abbr ll ls --color=auto -lh
        abbr la ls --color=auto -lah
    end

    if type z >/dev/null 2>&1
        abbr cd z
    else
        echo "dotfiles: zoxide is not installed" >&2
    end

    if type systemctl >/dev/null 2>&1
        abbr s systemctl
        abbr j journalctl
    end

    if type ranger >/dev/null 2>&1
        abbr r ranger
    else
        echo "dotfiles: ranger is not installed" >&2
    end

    if type bat >/dev/null 2>&1
        abbr b bat -P
    else
        echo "dotfiles: bat is not installed" >&2
    end

    if type git >/dev/null 2>&1
        abbr g git
        abbr gc git commit
        abbr gca git commit --amend --no-edit
        abbr gs git status
        abbr gb git branch
        abbr gw git worktree
        abbr gr git rebase
        abbr gri git rebase -i
        abbr grc git rebase --continue
        abbr gra git reabse --abort
        abbr gp git push --force
        abbr gpf git push --force
    end

    if type nvim >/dev/null 2>&1
        abbr e nvim
    end

    # if type bat >/dev/null 2>&1
    #     abbr lsblk "lsblk | bat -l conf -p"
    # end
end
