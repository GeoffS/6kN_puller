#!/usr/bin/env python3
"""
Realtime serial plotter with optional console-only mode.

If PyQt5/pyqtgraph are installed the script will open a GUI. If those
packages are missing you can run with `--nogui` to print parsed points
to the console for verification, or the script will fall back to
console mode automatically.

Usage:
  python serial_plot.py --port COM3
  python serial_plot.py --port COM3 --nogui

"""
import sys
import argparse
import time
from collections import deque
import serial


def parse_args(argv):
    p = argparse.ArgumentParser(description="Serial 2D plotter (X,Y pairs)")
    p.add_argument("--port", required=True, help="Serial port, e.g. COM3 or /dev/ttyUSB0")
    p.add_argument("--baud", type=int, default=115200, help="Baud rate (default: 115200)")
    p.add_argument("--xmin", type=float, default=0.0, help="Initial X min")
    p.add_argument("--xmax", type=float, default=100.0, help="Initial X max")
    p.add_argument("--ymin", type=float, default=0.0, help="Initial Y min")
    p.add_argument("--ymax", type=float, default=100.0, help="Initial Y max")
    p.add_argument("--nogui", action="store_true", help="Run in console mode without GUI")
    return p.parse_args(argv)


def console_mode(port, baud):
    """Simple blocking reader that prints parsed X,Y pairs to stdout."""
    try:
        ser = serial.Serial(port, baud, timeout=1)
    except Exception as e:
        print(f"ERROR: could not open serial port {port}: {e}")
        return

    print(f"Console mode: reading from {port} at {baud} baud. Ctrl-C to stop.")
    try:
        while True:
            try:
                raw = ser.readline().decode("utf-8", errors="ignore").strip()
                if not raw:
                    continue
                parts = raw.replace(",", " ").split()
                if len(parts) < 2:
                    continue
                x = float(parts[0])
                y = float(parts[1])
                ts = time.time()
                print(f"{ts:.3f}\t{x}\t{y}")
            except ValueError:
                # ignore non-numeric lines
                continue
            except Exception as e:
                print(f"Read error: {e}")
                time.sleep(0.05)
    except KeyboardInterrupt:
        print("Stopping console mode.")
    finally:
        try:
            ser.close()
        except Exception:
            pass


def main(argv):
    args = parse_args(argv)

    if args.nogui:
        console_mode(args.port, args.baud)
        return

    # Try to import GUI libs lazily. If they are missing fall back to console.
    try:
        from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QLabel
        from PyQt5.QtCore import QObject, pyqtSignal, QThread, Qt
        import pyqtgraph as pg
    except Exception as e:
        print("PyQt5/pyqtgraph not available:", e)
        print("Falling back to console mode. To use the GUI install dependencies: python -m pip install -r requirements.txt")
        console_mode(args.port, args.baud)
        return

    # Define GUI worker and window classes now that Qt is available
    class SerialWorker(QObject):
        new_point = pyqtSignal(float, float)
        error = pyqtSignal(str)
        finished = pyqtSignal()

        def __init__(self, port, baud):
            super().__init__()
            self.port = port
            self.baud = baud
            self._running = True
            self.ser = None

        def stop(self):
            self._running = False
            try:
                if self.ser and self.ser.is_open:
                    self.ser.close()
            except Exception:
                pass

        def run(self):
            try:
                self.ser = serial.Serial(self.port, self.baud, timeout=1)
            except Exception as e:
                self.error.emit(f"Serial open error: {e}")
                return

            while self._running:
                try:
                    raw = self.ser.readline().decode("utf-8", errors="ignore").strip()
                    if not raw:
                        continue
                    parts = raw.replace(',', ' ').split()
                    if len(parts) < 2:
                        continue
                    x = float(parts[0])
                    y = float(parts[1])
                    self.new_point.emit(x, y)
                except Exception as e:
                    self.error.emit(f"Parse/read error: {e} (line: {raw!r})")
                    time.sleep(0.05)

            self.finished.emit()


    class PlotWindow(QMainWindow):
        def __init__(self, port, baud, xmin, xmax, ymin, ymax, max_points=10000):
            super().__init__()
            self.setWindowTitle("Serial Realtime Plot")
            self.resize(900, 600)

            self.central = QWidget()
            self.setCentralWidget(self.central)
            layout = QVBoxLayout()
            self.central.setLayout(layout)

            self.status = QLabel("")
            layout.addWidget(self.status)

            self.plot = pg.PlotWidget()
            self.plot.showGrid(x=True, y=True, alpha=0.3)
            layout.addWidget(self.plot)

            self.scatter = pg.ScatterPlotItem(size=6, brush=pg.mkBrush(255, 0, 0, 200))
            self.plot.addItem(self.scatter)

            self.data_x = deque(maxlen=max_points)
            self.data_y = deque(maxlen=max_points)

            self.view_xmin = xmin
            self.view_xmax = xmax
            self.view_ymin = ymin
            self.view_ymax = ymax

            self.plot.setXRange(self.view_xmin, self.view_xmax)
            self.plot.setYRange(self.view_ymin, self.view_ymax)

            # Threaded serial reader
            self.thread = QThread()
            self.worker = SerialWorker(port, baud)
            self.worker.moveToThread(self.thread)
            self.thread.started.connect(self.worker.run)
            self.worker.new_point.connect(self.on_new_point)
            self.worker.error.connect(self.on_error)
            self.worker.finished.connect(self.thread.quit)
            self.thread.start()

        def on_error(self, msg: str):
            self.status.setText(msg)

        def on_new_point(self, x: float, y: float):
            self.data_x.append(x)
            self.data_y.append(y)
            try:
                self.scatter.setData(list(self.data_x), list(self.data_y))
            except Exception:
                pass

            changed = False
            if x < self.view_xmin:
                self.view_xmin = x
                changed = True
            if x > self.view_xmax:
                self.view_xmax = x
                changed = True
            if y < self.view_ymin:
                self.view_ymin = y
                changed = True
            if y > self.view_ymax:
                self.view_ymax = y
                changed = True

            if changed:
                xrange = self.view_xmax - self.view_xmin
                yrange = self.view_ymax - self.view_ymin
                if xrange == 0:
                    xrange = abs(self.view_xmax) if self.view_xmax != 0 else 1.0
                if yrange == 0:
                    yrange = abs(self.view_ymax) if self.view_ymax != 0 else 1.0
                pad_x = 0.05 * xrange
                pad_y = 0.05 * yrange
                self.plot.setXRange(self.view_xmin - pad_x, self.view_xmax + pad_x)
                self.plot.setYRange(self.view_ymin - pad_y, self.view_ymax + pad_y)

        def closeEvent(self, event):
            try:
                self.worker.stop()
            except Exception:
                pass
            self.thread.quit()
            self.thread.wait(2000)
            event.accept()


    app = QApplication([])
    win = PlotWindow(args.port, args.baud, args.xmin, args.xmax, args.ymin, args.ymax)
    win.show()
    sys.exit(app.exec_())


if __name__ == "__main__":
    main(sys.argv[1:])
