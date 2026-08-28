#!/bin/bash

PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"

echo "LAUNCHER: starting dashboard at $(cat /proc/uptime)" >&2

exec "$PYTHON" "$APP"