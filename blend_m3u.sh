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
else
    INPUT_FILE=$HANDDIR/$1.m3u
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

echo "# mpv EDL v0" > $HANDDIR/MASTER.edl


shuf -n 200 $TMPFILE1 | grep -v '#' >> $HANDDIR/MASTER.edl

#| grep -v "#" >> $HANDDIR/MASTER.edl

