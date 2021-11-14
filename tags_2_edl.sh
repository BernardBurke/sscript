#!/bin/bash
# take up to 8 tag names that correspond to directories under $TAGDIR
# Look the file name up in 
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
TMPFILE3=$(mktemp)
#TMPGREP1=$(mktemp)

if  ( command -v wslpath &> /dev/null ) ; then
        #echo "Running on WSL"
        ONWSL=true
        TAGDIR=$TAGWIN
        HANDDIR=$HANDWIN
        KEYDIR=$KEYCUTWIN
else
        echo "wsl not available "
        ONWSL=false
        HANDDIR=$HANDUNI
        KEYDIR=$KEYCUTUNI
        TAGDIR=$TAGUNI

fi

#echo "$# $@"

for var in "$@"
do 
    #echo "$TAGDIR/$var"
    thing="$TAGDIR/$var/*"
    #ls $thing
    for labl in $thing; do
        #echo "$labl"
        thong=$(basename -- "$labl")
        #echo "$thong"
        shuf -n 10 "$KEYDIR/$thong.edl" >> $TMPFILE1
    done
done 

shuf -n 200 $TMPFILE1 | grep -v "#" > "$TMPFILE2"

echo "# mpv EDL v0" > "$TMPFILE3"
cat $TMPFILE2 >> "$TMPFILE3"
cat $TMPFILE3
