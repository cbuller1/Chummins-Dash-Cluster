#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$PROJECT_ROOT/hardware.ini"
VENV_DIR="$HOME/.platformio-venv"
DASHBOARD_VENV="$PROJECT_ROOT/.venv-direct"

install_packages() {
    if ! command -v apt-get >/dev/null 2>&1; then
        echo "Missing required command: $1"
        echo "Install it manually, then run this script again."
        exit 1
    fi

    echo "Installing required packages: $*"
    sudo apt-get update
    sudo apt-get install -y "$@"
}

if ! command -v git >/dev/null 2>&1; then
    install_packages git
fi

if ! command -v python3 >/dev/null 2>&1; then
    install_packages python3 python3-venv
fi

if [[ ! -x "$DASHBOARD_VENV/bin/pip" ]]; then
    echo "Creating dashboard Python environment..."
    python3 -m venv "$DASHBOARD_VENV"
fi

echo "Installing dashboard requirements..."
"$DASHBOARD_VENV/bin/pip" install --upgrade pip
"$DASHBOARD_VENV/bin/pip" install -r "$PROJECT_ROOT/requirements.txt"

if [[ -x "$VENV_DIR/bin/pio" ]]; then
    PIO="$VENV_DIR/bin/pio"
elif command -v pio >/dev/null 2>&1; then
    PIO="$(command -v pio)"
else
    if ! python3 -m venv --help >/dev/null 2>&1; then
        install_packages python3-venv
    fi
    echo "Installing PlatformIO in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install --upgrade pip platformio
    PIO="$VENV_DIR/bin/pio"
fi

config_value() {
    python3 - "$CONFIG" "$1" "$2" <<'PY'
import configparser
import sys

config = configparser.ConfigParser()
config.read(sys.argv[1])
print(config.get(sys.argv[2], sys.argv[3], fallback="").strip())
PY
}

flash() {
    local target="$1"
    local section="$2"
    local key="$3"
    local port
    port="$(config_value "$section" "$key")"

    if [[ -z "$port" ]]; then
        echo "Missing [$section] $key in hardware.ini"
        exit 1
    fi
    if [[ ! -e "$port" ]]; then
        echo "Port not found for $target: $port"
        exit 1
    fi

    echo "Flashing $target on $port..."
    "$PIO" run --project-dir "$PROJECT_ROOT/firmware/$target" --target upload --upload-port "$port"
}

cd "$PROJECT_ROOT"
git pull --ff-only

flash waveshare waveshare port
flash feather_gps feather_gps port

echo "Waveshare and Feather GPS firmware flashed successfully."