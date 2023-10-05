"""Some utility functions for qtile config."""
from os import environ
from subprocess import run as cmd

from libqtile import widget


def has_cmd(name: str) -> bool:
    return cmd(["type", name, ">/dev/null", "2>&1"]).returncode == 0


def is_wayland() -> bool:
    return environ.get("XDG_SESSION_TYPE") == "wayland"


def powerline(rl, fg, bg):
    if rl == 0:
        uc = ""
    else:
        uc = ""
    return widget.TextBox(text=uc, padding=0, fontsize=24, foreground=fg, background=bg)


__all__ = ("has_cmd", "is_wayland", "powerline")
