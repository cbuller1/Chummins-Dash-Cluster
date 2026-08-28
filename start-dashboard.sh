#!/bin/bash

SPLASH="/usr/share/plymouth/themes/chummins/boot.png"
PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"

echo "LAUNCHER: entered at $(cat /proc/uptime)" >&2

/usr/bin/swayimg \
    -C info.show=no \
    -f \
    -s real \
    "$SPLASH" &

echo "LAUNCHER: swayimg started at $(cat /proc/uptime)" >&2

exec "$PYTHON" "$APP"