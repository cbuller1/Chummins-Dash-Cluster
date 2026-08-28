#!/bin/bash

export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms

# Touchscreen is fixed hardware on this dashboard.
# Tell Qt exactly which evdev device to use instead of discovering it.
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS="/dev/input/event4"

PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv-direct/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"

exec "$PYTHON" -u "$APP"