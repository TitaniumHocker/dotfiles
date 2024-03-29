from const import colors
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget as extwidget
from utils import is_wayland, powerline

contrast = "#1d2021"

leftbar = bar.Bar(
    [
        widget.Systray(background=colors[6], padding=8)
        if not is_wayland()
        else widget.StatusNotifier(background=colors[6]),
        widget.Sep(padding=8, background=colors[6], linewidth=0),
        widget.Spacer(),
        widget.Wttr(location={"MSK": "Moscow"}, fmt="  {}  "),
        widget.CheckUpdates(
            distro="Arch_checkupdates",
            no_update_string="Up to date",
            fmt="  {}  ",
            background=colors[6],
        ),
    ],
    28,
    opacity=.90,
)

bottombar = bar.Bar(
    [
        widget.CurrentLayoutIcon(scale=0.75, background=colors[3]),
        widget.GroupBox(
            highlight_method="block",
            background=colors[6],
            this_current_screen_border=colors[0],
        ),
        widget.Prompt(),
        extwidget.GlobalMenu(),
        widget.Spacer(),
        widget.CPU(),
        widget.ThermalSensor(),
        widget.Memory(fmt="RAM {}"),
        widget.DF(fmt="HDD {}", visible_on_warn=False, warn_space=80),
        widget.Net(fmt="NET {}"),
        widget.Spacer(),
        widget.KeyboardLayout(fmt=" LANG: {} ", configured_keyboards=["us", "ru"]),
        widget.Volume(fmt=" VOL: {} ", background=colors[5]),
        widget.Battery(
            charge_char="now ",
            discharge_char="left",
            format="{percent:2.0%} {char}",
            background=colors[4],
            fmt=" BAT: {} "
        ),
        widget.Clock(format="%d/%m/%y | %H:%M", background=colors[1], fmt=" {} "),
    ],
    26,
    opacity=.90,
)

__all__ = ("leftbar", "bottombar")
