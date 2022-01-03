#!/bin/bash
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
TMPFILE3=$(mktemp)
TMPGREP1=$(mktemp)

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
    INPUT_FILE=$HANDDIR/MASTER.m3u
    OUTPUT_FILE=$HANDDIR/MASTER.edl
    SAVE_SPEC=MASTER_$$.edl
else
    INPUT_FILE=$HANDDIR/$1.m3u
    OUTPUT_FILE=$HANDDIR/$1.edl
    LINUX_OUTPUT_FILE=$HANDUNI/$1.edl
    SAVE_SPEC=$1_$$.edl
fi


if [ ! -f $INPUT_FILE ]; then
    echo "input file p1 $INPUT_FILE does not exist"
    exit
fi

echo "Processing $INPUT_FILE"

OLDIFS=$IFS

dos2unix -n $INPUT_FILE $TMPFILE2

while IFS= read -r line;
    do
        if  $ONWSL 
            then 
            LINUX_PATH=$(wslpath -u "$line")
            cat "$LINUX_PATH" >> $TMPFILE3
        else
            echo "Converting $line"
        fi
done< $TMPFILE2




while IFS=, read -r lion start length;
    do
        if $ONWSL
            then
            echo "$lion,$start,$length" >> $TMPFILE1
        fi
done< $TMPFILE3

echo "Outputing to $OUTPUT_FILE"

cp -v $OUTPUT_FILE "$SCRATCHDIR/$SAVE_SPEC"

echo "# mpv EDL v0" > $OUTPUT_FILE

if $ONWSL
    then

        echo "Shuffling to $OUTPUT_FILE"

        shuf -n 1000 $TMPFILE1  | grep -v '#' | sort -Ru >> $OUTPUT_FILE

        echo "Making linux version in  $LINUX_OUTPUT_FILE"

        $SRC/cnvwinu "$OUTPUT_FILE" > "$LINUX_OUTPUT_FILE"
fi


#create the parallel Linux format files

#| grep -v "#" >> $HANDDIR/MASTER.edl

