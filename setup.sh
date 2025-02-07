#!/bin/bash

set -e

BASEDIR=$PWD
VERBOSE=false

log () {
    if [ "$VERBOSE" = false ]; then
	"$@" > /dev/null
    else
	"$@"
    fi
}


# Get options
echo "\nGetting options"
OPTS=$(getopt -o "d:v" --long "dir:,verbose" -n "setup.sh" -- "$@")
eval set -- "$OPTS"
while true; do
    case "$1" in
	-d|--dir) BASEDIR="$2"; shift 2;;
	-v|--verbose) VERBOSE=true; shift;;
	--) shift; break;;
	*) echo "Internal error!"; exit 1;;
    esac
done


echo "\nChecking for presence of required commands..."
for cmd in unzip wget python3 ls ollama; do
    if ! command -v $cmd 2>&1 >/dev/null; then
	echo "$cmd is not installed, aborting..."
	exit 1
    fi
done



echo "\nAssuming python3 venv module is installed"
echo "Creating python virtual environment"
python3 -m venv $BASEDIR/venv

echo "\nEntering virtual environment"
source $BASEDIR/venv/bin/activate
if ! command -v pip3 2>&1 >/dev/null; then
    echo "pip3 is not installed, aborting..."
    deactivate
    exit 1
fi

echo "Setting virtual environment variables"
export OLLAMA_MODELS="$VIRTUAL_ENV/../ollama/models"

# Install deepseek-r1:1.5b and create a new model based on provided modelfile
echo "\nStarting Ollama server"
ollama serve &
until curl localhost:11434; do
    sleep 1
done

echo "\nCreating ollama model"
ollama pull deepseek-r1:1.5b
ollama create ds_assistant --file $BASEDIR/resources/ds_assistant.modelfile

echo "\nInstalling python3 modules"
pip3 install pyttsx3 speechrecognition vosk ollama pyaudio

echo "\nInstalling speech recognition model for vosk"
wget -c https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip -O $BASEDIR/vosk-model.zip
unzip $BASEDIR/vosk-model.zip -d $BASEDIR/vosk
VOSK_MODEL_DIR=$(ls $BASEDIR/vosk)
mkdir $BASEDIR/model
mv $BASEDIR/vosk/$VOSK_MODEL_DIR/* $BASEDIR/model/

# Exit venv
deactivate

echo "\nCleaning up"
rm -r $BASEDIR/vosk
rm -r $BASEDIR/vosk-model.zip
