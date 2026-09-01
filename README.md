# Chummins Dash Cluster

A custom digital instrument cluster for a 1976 Chevrolet K30 running a 1991.5 12-valve Cummins 5.9 6BT swap, built on a Raspberry Pi with a Qt Quick UI. Three embedded nodes communicate over USB serial and CAN bus to deliver live engine data, GPS speed, odometer, trip counters, turn signals, relay outputs, and drive-state coaching.

---

## Hardware Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      Raspberry Pi                               │
│  Qt Quick UI (PySide6)  ←→  Python backend (DashBackend)       │
│          ↑                        ↑                             │
│   /dev/ttyACM0              /dev/ttyACM1                        │
│   USB-CDC (20 Hz)           USB-CDC (10 Hz)                     │
└────────┬────────────────────────────┬────────────────────────────┘
         │                            │
┌────────┴──────────────┐   ┌─────────┴──────────────────┐
│  Waveshare            │   │  Adafruit Feather M4 GPS   │
│  ESP32-S3-POE-        │   │  + Ultimate GPS FeatherWing │
│  ETH-8DI-8DO          │   │  + MB85RC256V FRAM (I2C)   │
│                       │   │                             │
│  • RPM (DI1/GPIO4)    │   │  • GPS speed (UART 9600→   │
│  • 7× digital inputs  │   │    57600 baud)              │
│    via optocouplers   │   │  • Odometer, trip counters  │
│    (DI2–DI8)          │   │    persisted in FRAM        │
│  • 8× relay outputs   │   └─────────────────────────────┘
│    via TCA9554 I2C    │
│  • CAN (TWAI) receive │
│    GPIO2/3 at 500 kbps│
└────────┬──────────────┘
         │ CAN bus 500 kbps
┌────────┴──────────────────────┐
│  Adafruit Feather M4 CAN      │
│  Express                      │
│  • TPS   A0  (0–5 V divider)  │
│  • Boost A2  (0–10 V divider) │
│  • Range A1  (0–5 V divider)  │
│  Publishes CAN ID 0x100 @ 50 Hz│
└───────────────────────────────┘
```

### Waveshare Digital Input Mapping

| Board label | DI channel | GPIO | Signal |
|---|---|---|---|
| DI1 | CH1 | GPIO4 | RPM pulse input (reserved — not a DI) |
| DI2 | CH2 | GPIO5 | Lockup solenoid indicator |
| DI3 | CH3 | GPIO6 | Overdrive indicator |
| DI4 | CH4 | GPIO7 | Left turn signal |
| DI5 | CH5 | GPIO8 | Right turn signal |
| DI6 | CH6 | GPIO9 | Spare |
| DI7 | CH7 | GPIO10 | Spare |
| DI8 | CH8 | GPIO11 | Ignition hot |

Relay outputs DO1–DO8 are controlled via TCA9554PWR I2C expander (address 0x20, SDA=GPIO42, SCL=GPIO41).

---

## Repository Layout

```
Chummins-Dash-Cluster/
├── main.py                         # Application entry point
├── splash.py                       # Boot splash helper
├── splash.qml
├── hardware.ini                    # Serial port / baud configuration
├── requirements.txt                # Python dependencies
├── start-dashboard.sh              # Production launch script (EGLFS)
├── qtquickcontrols2.conf
├── Chummins_Dash.qmlproject        # Qt Design Studio project
│
├── .vscode/
│   ├── c_cpp_properties.json       # IntelliSense config for ESP32 firmware
│   └── settings.json
│
├── backend/
│   ├── dash_backend.py             # QObject exposing all state to QML
│   ├── persistent_store.py         # JSON persistence (brightness, etc.)
│   ├── inputs/
│   │   ├── esp32_serial.py         # Reads Waveshare frames; sends relay 
│
├── Chummins_DashContent/           # QML UI screens and components
│   ├── App.qml                     # Root navigation / page switcher
│   ├── Screen01.ui.qml             # Main gauge cluster
│   ├── RelayControlPage.qml        # Relay toggle grid (DO1–DO8)
│   ├── InfoPage.qml                # Odometer / trip / service intervals
│   ├── BackupCameraPage.qml
│   ├── FrontCameraPage.qml
│   ├── Constants.ui.qml
│   ├── DriveState.ui.qml
│   ├── EngineSensors.ui.qml
│   ├── LeftTurnIndicator.ui.qml
│   ├── RightTurnIndicator.ui.qml
│   ├── LockupStatus.ui.qml
│   ├── OverdriveStatus.ui.qml
│   ├── RangeIndicator.ui.qml
│   ├── Speedometer.ui.qml
│   ├── Tachometer.ui.qml
│   ├── fonts/
│   └── images/                     # SVG/PNG assets (gauges, logos, splash)
│
├── firmware/
│   ├── waveshare/                  # Waveshare ESP32-S3-POE-ETH-8DI-8DO
│   │   ├── platformio.ini
│   │   ├── src/
│   │   │   ├── config.h            # Pin assignments, baud rates, channel mapping
│   │   │   ├── main.cpp
│   │   │   ├── comms/
│   │   │   │   ├── can_receiver.cpp/h      # TWAI — decodes CAN 0x100 from Feather ADC
│   │   │   │   ├── command_handler.cpp/h   # Pi → ESP32 relay commands (JSON)
│   │   │   │   └── serial_protocol.cpp/h   # ESP32 → Pi JSON frame publisher
│   │   │   ├── io/
│   │   │   │   └── digital_io.cpp/h        # DI reads (WS_DIN), DO writes (TCA9554)
│   │   │   └── sensors/
│   │   │       ├── rpm.cpp/h               # Interrupt-based RPM counter
│   │   │       └── analog_sensors.cpp/h
│   │   └── lib/WS_Board/           # Waveshare board library (DI/DO/TCA9554/I2C)
│   │       ├── I2C_Driver.cpp/h
│   │       ├── WS_DIN.cpp/h
│   │       ├── WS_Dout.cpp/h
│   │       ├── WS_GPIO.cpp/h
│   │       ├── WS_Struct.h
│   │       └── WS_TCA9554PWR.cpp/h
│   │
│   ├── feather_gps/                # Adafruit Feather M4 + GPS FeatherWing
│   │   ├── platformio.ini
│   │   └── src/
│   │       ├── config.h            # GPS baud, FRAM address map, publish interval
│   │       ├── main.cpp
│   │       ├── comms/
│   │       │   ├── command_handler.cpp/h   # Pi → Feather reset commands (JSON)
│   │       │   └── serial_protocol.cpp/h   # Feather → Pi JSON frame publisher
│   │       └── storage/
│   │           └── fram_store.cpp/h        # FRAM read/write for odometer persistence
│   │
│   └── feather_adc/                # Adafruit Feather M4 CAN Express
│       ├── platformio.ini
│       └── src/
│           ├── config.h            # ADC pins, divider ratios, CAN baud/ID
│           └── main.cpp            # Reads ADCs, packs fixed-point CAN frame
│
├── data/
│   └── vehicle_data.json           # Static vehicle reference data
│
└── qml_imports/                    # Runtime Qt Quick Studio QML components
```

---

## Serial Wire Formats

### Waveshare → Pi (20 Hz, `firmware/waveshare`)

```json
{"rpm":1250.0,"tps":35.2,"boost":8.1,"lockup":false,"od":true,
 "blink_l":false,"blink_r":false,"ign":true,"gear":-1,"range":"2hi"}
```

### Feather GPS → Pi (10 Hz, `firmware/feather_gps`)

```json
{"speed":55.3,"odo":124567.8,"trip":42.1,
 "eng_oil":3200.5,"trans":8100.0,"diff":8100.0,"coolant":8100.0}
```

### Pi → Waveshare (on demand)

```json
{"cmd":"relay","i":0,"v":true}
```
`i` is 0-indexed (0–7), mapping to relay DO1–DO8.

### Pi → Feather GPS (on demand)

```json
{"cmd":"reset","counter":"trip"}
```
Valid counters: `trip`, `eng_oil`, `trans`, `diff`, `coolant`. (`odo` is intentionally rejected by firmware.)

---

## Firmware

Each firmware project is a PlatformIO project. Flash with:

```bash
cd firmware/waveshare   # or feather_gps / feather_adc
pio run --target upload
```

Pin assignments and tuneable constants are in each project's `src/config.h`.

### Key config values

| Project | File | Notable settings |
|---|---|---|
| `waveshare` | `src/config.h` | `RPM_PULSES_PER_REV`, DI channel mapping, CAN ID |
| `feather_gps` | `src/config.h` | `GPS_BAUD_FAST`, FRAM address map, `PUBLISH_INTERVAL_MS` |
| `feather_adc` | `src/config.h` | Voltage divider ratios, range thresholds, `CAN_BAUD_BITS` |

---

## Pi Setup

### 1. Install dependencies

```bash
# Option A — pip (x86/aarch64 where PySide6 wheels are available)
pip install -r requirements.txt

# Option B — system packages (Raspberry Pi armhf/arm64)
sudo apt install python3-pyside6.qtquick python3-pyside6.qtqml \
                 python3-pyside6.qtwidgets
pip install pyserial
```

### 2. Configure hardware ports

Edit `hardware.ini`:

```ini
[app]
sim = false          # set true to run without any hardware

[waveshare]
port = /dev/ttyACM0
baud = 115200

[feather_gps]
port = /dev/ttyACM1
baud = 115200
```

### 3. Run

```bash
# Development (windowed)
python main.py

# Simulation (no hardware)
python main.py --sim

# Production (fullscreen EGLFS on Raspberry Pi)
./start-dashboard.sh
```

CLI flags override `hardware.ini`:

```
--port PORT       Waveshare serial port
--baud BAUD       Waveshare baud rate
--gps-port PORT   Feather GPS serial port
--gps-baud BAUD   Feather GPS baud rate
--sim             Simulation mode
```

---

## Ignition-Off Auto Shutdown

When the ignition hot signal (DI8) is lost, the dashboard waits 13 minutes then powers off the Pi. The timer cancels immediately if ignition is restored.

This requires a passwordless sudoers entry for `shutdown`. Add it with:

```bash
sudo visudo -f /etc/sudoers.d/chummins-shutdown
```

Add this single line (replace `chummins` with your Pi username):

```
chummins ALL=(ALL) NOPASSWD: /sbin/shutdown
```

Verify it works without a password prompt:

```bash
sudo -n shutdown --help
```

---

## Drive State Logic

The backend classifies engine state every frame using RPM, TPS, boost, lockup, and overdrive signals. States (highest priority first):

| State | Meaning |
|---|---|
| `redline` | RPM at governor — ease off |
| `overboost` | Boost above safe threshold |
| `lugging` | Low RPM under load (severe stress) |
| `power` | Healthy power band with boost building |
| `normal` | Efficient cruise |

Thresholds are tuned for a 1991.5 12-valve P7100 pump. Adjust in `backend/logic/drive_state.py`.

---

## Development Notes

- **Simulation mode** (`--sim` or `hardware.ini [app] sim = true`) runs without any serial hardware using `backend/inputs/sim_reader.py`.
- **IntelliSense** for the ESP32 firmware is configured in `.vscode/c_cpp_properties.json` pointing to `firmware/waveshare/.pio/build/.../compile_commands.json`. Run `pio run --target compiledb` inside the firmware folder to regenerate after library changes.
- The Waveshare library (`firmware/waveshare/lib/WS_Board/`) is sourced from the [Waveshare demo package](https://files.waveshare.com/wiki/ESP32-S3-POE-ETH-8DI-8DO/ESP32-S3-POE-ETH-8DI-8DO-Demo.zip) with one patch: `ledcAttach` → `ledcSetup`+`ledcAttachPin` for Arduino-ESP32 2.x compatibility.
