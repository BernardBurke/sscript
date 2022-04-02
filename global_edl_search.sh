#!/bin/bash
# a start at common includes
# 
TMPFILE1=$(mktemp) # for find results
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
	echo "defaulting"
       	SEARCH_TERM=daughter
else
	SEARCH_TERM=$1
fi

OUTPUT_FILE="globeld-$SEARCH_TERM"
OUTPUT_FILE="$WSCR/$OUTPUT_FILE"
OUTPUT_FILE="$OUTPUT_FILE-$$.edl"


grep -irh $SEARCH_TERM $KEYCUTWIN/*.edl > $TMPFILE1
grep -irh $SEARCH_TERM $HANDWIN/*.edl >> $TMPFILE1
grep -irh $SEARCH_TERM $WSCR/*.edl >> $TMPFILE1
grep -iv audio  $TMPFILE1 > $TMPFILE2
grep -iv globeld  $TMPFILE2 > $TMPFILE3



#cat $TMPFILE1 | sort -Ru | shuf -n 200 > $OUTPUT_FILE
cat $TMPFILE3 | sort -Ru | shuf -n 200 > "$OUTPUT_FILE"

$SRC/shake_an_edl.sh $OUTPUT_FILE

#cat $OUTPUT_FILE

cmd.exe /c  mpv  --volume=10 --screen=0 --fs-screen=0 --fullscreen $(wslpath -w $OUTPUT_FILE)



