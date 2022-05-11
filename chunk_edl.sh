# /bin/bash
# read in a huge edl and create playlist files
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
    	echo "Provide file 1"
	exit
else
    if [[ ! -f $1 ]]; then
	    echo "$1 does not exist"
	    exit
    fi
    FILE1="$1"
    FILE1_COUNT=$(wc -l < "$FILE1")
fi

if [[ "$2" = "" ]]; then
    NO_OF_RECORDS=10
else
    NO_OF_RECORDS=$2
fi

if [[ "$3" = "" ]]; then
    NO_OF_PLAYLISTS=10
else
    NO_OF_PLAYLISTS=$3
fi

for ((i=1;i < $NO_OF_PLAYLISTS; i++))
do
    echo "# mpv EDL v0" > $WSCR/chunk_$i.edl
    shuf -n $NO_OF_RECORDS "$FILE1" >> $WSCR/chunk_$i.edl
    echo $(wslpath -m $WSCR/chunk_$i.edl) >> $TMPFILE1

done

cat $TMPFILE1 > $WSCR/chunks.m3u

cat "$WSCR/chunks.m3u"
echo "$WSCR/chunks.m3u"


