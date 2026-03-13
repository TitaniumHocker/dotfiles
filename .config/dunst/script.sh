#!/usr/bin/env bash
case "$DUNST_URGENCY" in
    LOW)
        canberra-gtk-play -i message
        ;;
    NORMAL)
        canberra-gtk-play -i message-new-instant
        ;;
    CRITICAL)
        canberra-gtk-play -i dialog-warning
        ;;
esac
