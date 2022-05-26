# /bin/bash
# read in a huge edl and create playlist files
source $SRC/common_inc.sh

UNIQUE=$(rand)

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
    echo "# mpv EDL v0" > "$WSCR/chunk-$UNIQUE-$i.edl"
    shuf -n $NO_OF_RECORDS "$FILE1" | grep -vi 'audio' >> "$WSCR/chunk-$UNIQUE-$i.edl"
    echo $(wslpath -m "$WSCR/chunk-$UNIQUE-$i.edl") >> $TMPFILE1

done

PLAYLIST="$WSCR/chunks_$UNIQUE.m3u"

cat $TMPFILE1 > $PLAYLIST

cat $TMPFILE1 > "$WSCR/chunks.m3u"

cat "$PLAYLIST"
echo "$PLAYLIST"


