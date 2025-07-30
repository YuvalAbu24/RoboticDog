# voice_test.py
import speech_recognition as sr

def test_microphone():
    recognizer = sr.Recognizer()
    mic_index =2 

    # Use the default system microphone
    with sr.Microphone(device_index=mic_index) as source:
        print(" Say something...")
        recognizer.adjust_for_ambient_noise(source)  # Auto-calibration
        try:
            audio = recognizer.listen(source, timeout=5)
            print(" Recognizing...")

            # Use Google Web Speech API (requires internet)
            command = recognizer.recognize_google(audio, language='he-IL')
            print(" I said:", command)

        except sr.WaitTimeoutError:
            print("Timeout: no speech detected.")
        except sr.UnknownValueError:
            print("Could not understand audio.")
        except sr.RequestError as e:
            print("Could not request results:", e)

if __name__ == "__main__":
    test_microphone()
