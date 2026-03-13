from libqtile.utils import guess_terminal
from colors import get_colors


mod = "mod4"
terminal = guess_terminal("kitty")
colors = get_colors("gruvbox")

__all__ = ("mod", "terminal", "colors")
