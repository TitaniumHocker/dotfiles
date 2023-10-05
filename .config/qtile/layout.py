from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

from const import colors, mod
from statusbar import bottombar, leftbar

border_focus = "#d75f5f"
border_normal = colors[0]

## LAYOUTS
layouts = [
    layout.Columns(
        border_focus=border_focus,
        border_normal=border_normal,
        border_width=2,
        margin=6,
    ),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    layout.Bsp(
        border_focus=border_focus,
        border_normal=border_normal,
        border_width=2,
        margin=6,
    ),
    # layout.Matrix(),
    layout.MonadTall(
        border_focus=border_focus,
        border_normal=border_normal,
        border_width=2,
        margin=6,
    ),
    # jlayout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


widget_defaults = dict(
    font="Roboto Semibold",
    fontsize=14,
    padding=4,
    background=colors[0],
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        left=leftbar,
        bottom=bottombar,
        wallpaper="~/.config/qtile/wallpaper.jpg",
        wallpaper_mode="fill",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)


__all__ = (
    "layouts",
    "widget_defaults",
    "extension_defaults",
    "screens",
    "floating_layout",
    "mouse",
)
