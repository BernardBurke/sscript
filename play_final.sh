#!/bin/bash
# play the final $2 seconds of a file
source $SRC/common_inc.sh

if [[ ! -f "$1" ]]; then
    echo "Please provice an M3U file that exists"
    exit 1
fi

if [[ "$2" = "" ]]; then
        SLICE=60
else
        SLICE=$2
fi

if [[ "$3" = "" ]]; then
        TRAIL=5
else
        TRAIL=$3
fi

j=0
k=0



sed -i 's/\r$//' "$1" # get rid of those pesky carriage returns

while IFS= read -r fname; do
    #nixname=$(wslpath -u "$fname" | tr -d '\r' )
    nixname=$(wslpath -u "$fname")
    #echo $nixname
    j=0
    leng=$(ffprobe -v quiet  -of csv=p=0 -show_entries format=duration "$nixname")
#    echo $leng
    length=${leng%.*}
    if [[ ! -z "$length" ]]; then
        #echo "$fname $length"
        start=$((length-SLICE))
        segment=$((SLICE-TRAIL))
        echo "$fname,$start,$segment" >> $TMPFILE2
    fi

done < "$1"

OUTPUT_FILE=$WSCR/final_$SLICE_$$.edl

echo "# mpv EDL v0" > $OUTPUT_FILE
cat $TMPFILE2 | shuf -n 300 >> $OUTPUT_FILE
echo $OUTPUT_FILE
