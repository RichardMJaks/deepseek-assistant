import json, time, re, os
import speech_recognition as sr
import pyttsx3
from ollama import chat


def getPrompt(r, src):
    r.adjust_for_ambient_noise(src, duration=0.2)
    audio = r.listen(src)
    to_text = r.recognize_vosk(audio)
    txt = json.loads(to_text)['text']
    return txt.lower().strip()


def getAnswer(prompt):
    answer = chat(
            model='ds_assistant',
            messages=[{
                'role': 'user',
                'content': prompt
            }]
    )

    msg = answer['message']['content']
    msg_no_thoughts = re.sub(r"<think>.*?</think>", "", msg, flags=re.DOTALL).strip()

    return msg_no_thoughts

def speakAnswer(engine, answer):
    engine.say(answer)
    engine.runAndWait()


def main():
    tts_engine = pyttsx3.init()
    tts_engine.setProperty('rate', 120)
    r = sr.Recognizer()
    
    with sr.Microphone() as mic:
        try:
            while True:
                print("Waiting for prompt...")
                prompt = getPrompt(r, mic)
                if prompt == "":
                    continue

                print("Got prompt:", prompt)
                answer = getAnswer(prompt)

                print("Uttering answer:", answer)
                speakAnswer(tts_engine, answer)
        except sr.RequestError as e:
            print("Could not request results; {0}".format(e))
        except sr.UnknownValueError:
            print("Unknown error occured")
        except KeyboardInterrupt:
            print("Bye!")

if __name__ == "__main__":
    main()


