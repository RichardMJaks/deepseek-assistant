# Deepseek-R1 Conversational assistant
This script utilizes Deepseek-R1:1.5b model with speech-to-text (vosk) and text-to-speech to create a conversational assistant.

Currently it cannot do anything else but listen and answer. It also has a known bug with cutting the answer short from the end.

## Dependencies
Make sure follownig dependencies are present:
* `unzip`
* `wget`
* `python3`
* `ollama`

## Installation
```
git clone https://github.com/RichardMJaks/deepseek-assistant.git
cd deepseek-assistant
chmod +x setup.sh
./setup.sh
```

## Running the assistant
**DON'T RUN THE PYTHON FILE DIRECTLY, IT WON'T WORK**
Run it instead using `./run`

## Implemented and planned features
[x] Answer using TTS
[x] Listen to question via a microphone
[ ] Use streaming answers instead of waiting until answer is finished
[ ] Run CLI commands using voice (needs `deepseek-coder-v2` model)
[ ] Containerize the project using `docker` 
[ ] Implement choosing different speech recognition models during setup (models available [here](https://alphacephei.com/vosk/models))
[ ] Don't ask for new prompt before Deepseek has finished answering
[ ] Make setting the `-v` option actually work for `setup.sh`
[ ] Make setting the `-d` option not break the whole installation
[ ] Add the ability to kill the program while the AI is speaking
