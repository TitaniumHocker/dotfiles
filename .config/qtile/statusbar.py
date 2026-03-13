from const import colors
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from utils import is_wayland, powerline, parse_mic
import subprocess

contrast = "#1d2021"

topbar = bar.Bar(
    [
        widget.CurrentLayout(mode='icon', scale=0.75, background=colors[3]),
        widget.GroupBox(
            highlight_method="block",
            background=colors[6],
            this_current_screen_border=colors[0],
        ),
        widget.CheckUpdates(
            distro="Arch_checkupdates",
            no_update_string="Up to date",
            fmt="  {}  ",
            background=colors[1],
        ),
        widget.Prompt(),
        widget.Spacer(),
        widget.Wttr(location={"MSK": "Moscow"}, fmt="  {}  ", background=colors[4]),
        widget.Clock(format="%d/%m/%y | %H:%M", background=colors[4], fmt=" {} "),
        widget.Spacer(),
        widget.Systray(padding=8)
        if not is_wayland()
        else widget.StatusNotifier(padding=8),
        widget.Sep(padding=8, linewidth=0),
        widget.GenPollCommand(
            cmd=["xkblayout-state", "print", "%s"],
            parse=lambda v: f"{v.strip().upper()}",
            update_interval=.25,
            mouse_callbacks={
                'Button1': lambda: subprocess.run([
                    'xkblayout-state', 'set', '+1'
                ])
            },
            background=colors[1]
        ),
        widget.Volume(
            fmt="VOL: {}",
            background=colors[6],
            mouse_callbacks={"Button3": lazy.spawn("pavucontrol")}
        ),
        widget.GenPollCommand(
            background=colors[6],
            cmd=["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"],
            parse=lambda v: f"MIC: {parse_mic(v)}",
            update_interval=.25,
            mouse_callbacks={
                'Button1': lazy.spawn('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),
                'Button4': lazy.spawn('wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 1%+'),
                'Button5': lazy.spawn('wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-'),
            },
        ),
        widget.Bluetooth(
            default_show_battery=True,
            background=colors[3],
            mouse_callbacks={"Button1": lazy.spawn("blueman-manager")}
        ),
    ],
    24,
    opacity=1,
)

__all__ = ("topbar")
