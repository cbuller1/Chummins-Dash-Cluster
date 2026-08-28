#!/bin/bash

export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms

PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv-direct/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"

exec "$PYTHON" -u "$APP"