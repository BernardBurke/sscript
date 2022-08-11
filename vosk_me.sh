#!/bin/bash
# use vosk-transcribe to make subtitles for a single file
source $SRC/common_inc.sh

if [[ ! -f "$1" ]]; then
    echo "Please provice an media file that exists"
    exit 1
fi

INPUT_DIR=basename

if [[ "$2" = "" ]]; then
        OUTPUT_DIR=$(dirname "$1")
else
    if [[ -d $2 ]]; then
        OUTPUT_DIR=$2
    else
        echo "$2 is not a valid directory "
        exit 1
    fi
fi

FILE_EXTENSION="${1##*.}"
echo $FILE_EXTENSION

# needs a case statement (mp4 m4a mp3 mkv)
SRT_FILENAME=$OUTPUT_DIR/$(basename "$1" $FILE_EXTENSION)srt

echo $SRT_FILENAME

if [[ "$3" = "" ]]; then
        if [[ -f $SRT_FILENAME ]]; then
            echo "$SRT_FILENAME exists and parameter 3 is blank - exiting"
            exit 1
        fi
fi



vosk-transcriber -i "$1" \
        -t srt \
        -o "$SRT_FILENAME" \
        --model-name=vosk-model-en-us-0.22 

