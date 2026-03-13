import subprocess
from os import path

from const import *
from groups import *
from keys import *
from layout import *
from libqtile import hook

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None
wmname = "Qtile"


@hook.subscribe.startup_once
def _():
    if path.isfile((script := path.expanduser("~/.config/qtile/autostart"))):
        subprocess.Popen([script])
