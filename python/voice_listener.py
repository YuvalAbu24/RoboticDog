# voice_listener.py

import pyaudio
from vosk import Model, KaldiRecognizer
import json
from threading import Thread, Lock

# === Configuration ===
MODEL_PATH = "home/user_admin/roboticDog/RoboticDog-main/python/models/vosk-model-small-en-us-0.15"
SAMPLE_RATE = 48000
DEVICE_INDEX = 2  # Update with your mic device index
KEYWORDS = {"sit", "stand", "walk", "stop", "lie down", "turn around", "full gait"}

# === State ===
_last_command = None
_lock = Lock()

def get_last_command():
    global _last_command
    with _lock:
        cmd = _last_command
        _last_command = None  # Reset after reading
    return cmd

def _listener_loop():
    global _last_command

    model = Model(MODEL_PATH)
    recognizer = KaldiRecognizer(model, SAMPLE_RATE, json.dumps(list(KEYWORDS)))
    recognizer.SetWords(False)

    p = pyaudio.PyAudio()
    stream = p.open(format=pyaudio.paInt16,
                    channels=1,
                    rate=SAMPLE_RATE,
                    input=True,
                    input_device_index=DEVICE_INDEX,
                    frames_per_buffer=8192)
    stream.start_stream()

    print(" Voice listener started...")

    while True:
        data = stream.read(4096, exception_on_overflow=False)
        if recognizer.AcceptWaveform(data):
            result = json.loads(recognizer.Result())
            text = result.get("text", "").lower().strip()

            if text:
                print(f" Recognized: {text}")
                if text in KEYWORDS:
                    with _lock:
                        _last_command = text
                else:
                    print(f" Not in keyword list: '{text}'")
        else:
            # Optionally process partial result
            pass

def start_voice_listener():
    thread = Thread(target=_listener_loop, daemon=True)
    thread.start()
