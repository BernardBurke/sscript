#!/bin/bash
TMPFILE1=$(mktemp)
#TMPFILE2=$(mktemp)
#TMPFILE3=$(mktemp)
#TMPGREP1=$(mktemp)

if  ( command -v wslpath &> /dev/null ) ; then
        #echo "Running on WSL"
        ONWSL=true
        KEYDIR="$KEYCUTWIN"
        SCRATCHDIR="$EDLWINSCRATCH"
	    HANDDIR="$HANDWIN"
            NEWDIR="$KEYCUTWIN/new"
else
        echo "wsl not available "
        ONWSL=false
        KEYDIR="$KEYCUTUNI"
        SCRATCHDIR="$EDLUNISCRATCH"
	    HANDDIR="$HANDUNI"
            NEWDIR="$KEYCUTWIN/new"

fi

if [[ "$1" = "" ]]; then
    INPUT_DIR=$KEYDIR
    OUTPUT_DIR=$SCRATCHDIR
else
    INPUT_DIR=$1
    
fi

OUTPUT_FILE="$OUTPUT_DIR/one_of_each.edl"

if [[ "$2" = "" ]]; then
    GET_ME=1
else
    GET_ME=$1
fi



if [ ! -d "$INPUT_DIR" ]; then
    echo "$INPUT_DIR does not exist"
    exit
fi    

echo "# mpv EDL v0" > $OUTPUT_FILE

for file in $INPUT_DIR/*.edl; do

    shuf -n $GET_ME  "$file" | grep -v "#" >> $OUTPUT_FILE

done

cat $OUTPUT_FILE

echo $OUTPUT_FILE