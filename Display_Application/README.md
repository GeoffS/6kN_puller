# Display and Control Application

## Serial Realtime Plotter

A small GUI that listens on a serial port for `X,Y` pairs and plots them
in real time. Axes start with predefined ranges and will auto-rescale if
incoming data falls outside the current view.

Install dependencies (recommended in a virtualenv):

```pwsh
python -m pip install -r requirements.txt
```

Run the plotter (example):

```pwsh
python serial_plot.py --port COM3 --baud 115200 --xmin 0 --xmax 100 --ymin 0 --ymax 100
```

Serial data format:
- Lines should contain two numeric values, either `X Y` or `X,Y`.
  Example lines sent over serial:
  - `12.3,45.6\n`
  - `13.0 46.1\n`

If you want me to add CSV logging, a UI to change ranges at runtime, or
support for multiple traces, tell me which feature to add next.
# Create and activate a virtual environment (PowerShell):

```pwsh
# create venv
python -m venv .venv

# (only if script execution is restricted) allow the activation for this process
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

# activate the venv
.\.venv\Scripts\Activate.ps1

# install dependencies
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Create and activate a virtual environment (Windows cmd):

```cmd
python -m venv .venv
.\.venv\Scripts\activate.bat
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Create and activate a virtual environment (macOS / Linux):

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Run the plotter (example):

```pwsh
python serial_plot.py --port COM3 --baud 115200 --xmin 0 --xmax 100 --ymin 0 --ymax 100
```

Serial data format:
- Lines should contain two numeric values, either `X Y` or `X,Y`.
  Example lines sent over serial:
  - `12.3,45.6\n`
  - `13.0 46.1\n`

If you want me to add CSV logging, a UI to change ranges at runtime, or
support for multiple traces, tell me which feature to add next.
# Display and Control Application

## Serial Realtime Plotter

A small GUI that listens on a serial port for `X,Y` pairs and plots them
in real time. Axes start with predefined ranges and will auto-rescale if
incoming data falls outside the current view.

Install dependencies (recommended in a virtualenv):

```pwsh
python -m pip install -r requirements.txt
```

Run the plotter (example):

```pwsh
python serial_plot.py --port COM3 --baud 115200 --xmin 0 --xmax 100 --ymin 0 --ymax 100
```

Serial data format:
- Lines should contain two numeric values, either `X Y` or `X,Y`.
  Example lines sent over serial:
  - `12.3,45.6\n`
  - `13.0 46.1\n`

If you want me to add CSV logging, a UI to change ranges at runtime, or
support for multiple traces, tell me which feature to add next.
# Display and Control Application