#!/bin/bash
# get me a random playlst
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
        SHUFFCOUNT=100
else
        SHUFFCOUNT=$1
fi

find $GRLSRC -iname "*.mp4" -o -iname "*.mkv" | grep -v unix  | shuf -n $SHUFFCOUNT  > $TMPFILE1

cat $TMPFILE1 | sort -Ru > $TMPFILE3


IFS=$(echo -en "\n\b")

while IFS= read -r f
do
	echo $(wslpath -w "$f") >> $TMPFILE2
done < "$TMPFILE3"

$SRC/m3u2chopped.sh "$TMPFILE2"
