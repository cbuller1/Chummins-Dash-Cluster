#!/bin/bash

PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"
SPLASH="/home/chummins/Github/Chummins-Dash-Cluster/splash.py"

echo "LAUNCHER: entered at $(cat /proc/uptime)" >&2

# Start Qt splash
"$PYTHON" "$SPLASH" &

echo "LAUNCHER: splash started at $(cat /proc/uptime)" >&2

# Start the real dashboard
exec "$PYTHON" "$APP"