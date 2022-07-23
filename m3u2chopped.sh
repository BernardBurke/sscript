#!/bin/bash
# a more serious version of this converter - written initially to check a windows edl
source $SRC/common_inc.sh

if [[ ! -f "$1" ]]; then
    echo "Please provice an M3U file that exists"
    exit 1
fi

if [[ "$2" = "" ]]; then
        SLICE=10
else
        SLICE=$2
fi

#echo "Slice time is $SLICE"

VARIANCE=5

LOWER=$[SLICE - $VARIANCE]
UPPER=$[SLICE + $VARIANCE]

LOOP_COUNT=10

j=0
k=0

echo "# mpv EDL v0" > $TMPFILE1

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
            for ((j=1;j<=$LOOP_COUNT;j++)); do
                    period=$(shuf -i $LOWER-$UPPER -n 1 )
                    strt=$(rand -M $length -s $period )
                    runtime=$(( $strt + $period ))
                    #echo "Length $length Start $strt Period $period Runtime $runtime fname $fname"
                    #echo "Runtime $runtime"
                    if [ "$length" -gt "$runtime" ]; then
                            #period=$[ "$period" - "1" ]
                            #echo "$fname,$strt,$period" 
                            echo "$fname,$strt,$period" >> $TMPFILE2
                            ((k++))
                    else
                            echo "runtime greater than length"
                            break
                    fi
            done
    fi

done < "$1"

cat $TMPFILE2 | shuf -n $k  >> $TMPFILE1


echo $(wslpath -w "$TMPFILE1")