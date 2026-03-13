from libqtile.config import Group, Key, Match
from libqtile.lazy import lazy

from const import mod
from keys import keys

groups_template = {
    "a": ["kitty", "yandex-browser"],
    "s": ["Mail", "teams-for-linux"],
    "d": ["claude-desktop", "obsidian"],
    "z": [],
    "x": [],
    "c": ["steam", "ts3client_linux_amd64"],
}
groups = [Group(k, matches=[Match(wm_class=i) for i in v]) for k, v in groups_template.items()]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

__all__ = ("groups",)
