#!/bin/bash

export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms

export QT_QPA_EGLFS_DEBUG=1
export QT_LOGGING_RULES="qt.qpa.*=true"

PYTHON="/home/chummins/Github/Chummins-Dash-Cluster/.venv-direct/bin/python"
APP="/home/chummins/Github/Chummins-Dash-Cluster/main.py"

exec "$PYTHON" -u "$APP"
