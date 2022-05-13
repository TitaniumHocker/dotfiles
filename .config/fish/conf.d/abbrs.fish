if type exa >/dev/null 2>&1
    abbr ls exa
    abbr ll exa -lh
    abbr la exa -lah
else
    abbr ll ls --color=auto -lh
    abbr la ls --color=auto -lah
end

if type z >/dev/null 2>&1
    abbr cd z
end

abbr s systemctl
abbr j journalctl
abbr r ranger
