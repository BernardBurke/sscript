#!/bin/bash
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
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
    OUTPUT_DIR=$SCRATCHDIR
    
fi

OUTPUT_FILE="$OUTPUT_DIR/one_of_each.edl"

OUTPUT_FILE1="$OUTPUT_DIR/one_of_each_1.edl"
OUTPUT_FILE2="$OUTPUT_DIR/one_of_each_2.edl"
OUTPUT_FILE3="$OUTPUT_DIR/one_of_each_3.edl"

echo "Input $INPUT_DIR output $OUTPUT_FILE"



if [[ "$2" = "" ]]; then
    GET_ME=1
else
    GET_ME=$2
fi



if [ ! -d "$INPUT_DIR" ]; then
    echo "$INPUT_DIR does not exist"
    exit
fi    

cp -v $OUTPUT_FILE $OUTPUT_DIR/one_of_each_$$.edl

echo "# mpv EDL v0" > $OUTPUT_FILE

echo "# mpv EDL v0" > $OUTPUT_FILE1
echo "# mpv EDL v0" > $OUTPUT_FILE2
echo "# mpv EDL v0" > $OUTPUT_FILE3


for file in $INPUT_DIR/*.edl; do

    shuf -n $GET_ME  "$file" | grep -v "#"  >> $TMPFILE2

done

NO_OF_RECORDS=$(cat $TMPFILE2 | wc -l )

echo "There were $NO_OF_RECORDS in the $OUTPUT_FILE"

#THIRDS=$(( $NO_OF_RECORDS / 3 ))
# the files are getting too big to play - I'm gonna divide by 20
THIRDS=$(( $NO_OF_RECORDS / 20 ))

echo "Split files are $THIRDS long"


shuf $TMPFILE2 >> $OUTPUT_FILE

cat $OUTPUT_FILE

echo $OUTPUT_FILE

shuf -n $THIRDS $TMPFILE2 >> $OUTPUT_FILE1
shuf -n $THIRDS $TMPFILE2 >> $OUTPUT_FILE2
shuf -n $THIRDS $TMPFILE2 >> $OUTPUT_FILE3

echo "$THIRDS length written for 3 output files"
