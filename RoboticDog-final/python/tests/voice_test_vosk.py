import pyaudio
from vosk import Model, KaldiRecognizer
import json

model = Model("/home/user_admin/roboticDog/RoboticDog-main/python/models/vosk-model-small-en-us-0.15")
COMMANDS=["sit","lie down", "stand", "walk", "turn around", "stop", "full gait"]
recognizer = KaldiRecognizer(model, 48000,json.dumps(COMMANDS))  # <- sample rate

p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16,
                channels=1,               # force mono
                rate=48000,               # required sample rate
                input=True,
                input_device_index=1,     # or whichever index is your USB mic
                frames_per_buffer=8192)
stream.start_stream()

print(" Speak an English command...")

while True:
    data = stream.read(4096, exception_on_overflow=False)
    if recognizer.AcceptWaveform(data):
        result = json.loads(recognizer.Result())
        command = result.get("text", "").lower()

        if command:
            print("You said:", command)

            # === Command matching ===
            if "sit" in command:
                print(" Command recognized: SIT")
            elif "stand" in command:
                print(" Command recognized: STAND")
            elif "walk" in command:
                print(" Command recognized: WALK")
            elif "turn" in command and "around" in command:
                print(" Command recognized: TURN AROUND")
            elif "stop" in command:
                print(" Command recognized: STOP")
            elif "lie" in command and "down" in command:
                print(" Command recognized: LIE DOWN")
            elif "full" in command and "gait" in command:
                print(" Command recognized: FULL GAIT")
            else:
                print(" Unknown command:", command)
