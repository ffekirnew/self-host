"""Run intel_gpu_top and serve its latest sample as JSON on :8080."""
import json
import os
import subprocess
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

latest = {}


def sample(raw):
    engines = raw.get("engines", {})
    busy = lambda name: round(engines.get(name, {}).get("busy", 0.0), 1)
    return {
        "render": busy("Render/3D"),
        "video": busy("Video"),
        "video_enhance": busy("VideoEnhance"),
        "blitter": busy("Blitter"),
        "frequency_mhz": round(raw.get("frequency", {}).get("actual", 0.0)),
        "rc6": round(raw.get("rc6", {}).get("value", 0.0), 1),
        "power_w": round(raw.get("power", {}).get("GPU", 0.0), 2),
    }


def read_samples():
    global latest
    # -J prints a JSON array of objects, one per period, streamed forever
    proc = subprocess.Popen(["intel_gpu_top", "-J", "-s", "2000"], stdout=subprocess.PIPE, text=True)
    decoder, buf = json.JSONDecoder(), ""
    for line in proc.stdout:
        buf += line
        while True:
            buf = buf.lstrip(" \t\r\n,[")
            try:
                obj, end = decoder.raw_decode(buf)
            except json.JSONDecodeError:
                break
            latest, buf = sample(obj), buf[end:]
    raise SystemExit(f"intel_gpu_top exited with {proc.wait()}")


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps(latest).encode()
        self.send_response(200 if latest else 503)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        pass


def reader():
    try:
        read_samples()
    finally:
        # let the container restart if intel_gpu_top dies
        os._exit(1)


threading.Thread(target=reader, daemon=True).start()
ThreadingHTTPServer(("", 8080), Handler).serve_forever()
