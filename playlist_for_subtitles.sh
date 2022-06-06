# /bin/bash
# read in a huge edl and create playlist files
source $SRC/common_inc.sh

UNIQUE=$(rand)


if [[ "$1" = "" ]]; then
        echo "Provide directory in P1"
        exit
else
    if [[ ! -d $1 ]]; then
            echo "directory $1 does not exist"
            exit
    fi
    DIR="$1"
fi

OUTPUT_FILE="$HANDWIN/subtitles-$(basename $1).m3u"
OUTPUT_CMD="$HANDWIN/subtitles-$(basename $1).cmd"

touch $OUTPUT_FILE

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# get the vtt equivalents
for f in $DIR/*.vtt; 
        do
	        this_file=$(basename  "$f" ".vtt")
                this_file="$DIR/$this_file.mp4"
                echo $(wslpath -w $this_file) >> $OUTPUT_FILE
done

        cat "$OUTPUT_FILE"
        echo "wrote $OUTPUT_FILE"
        echo "start /min plylist 10 1 %HANDWIN%\subtitles-pure.m3u" > $OUTPUT_CMD
        echo "start /min plylist 10 2 %HANDWIN%\subtitles-pure.m3u" >> $OUTPUT_CMD
        echo "start /min plylist 10 0 %HANDWIN%\subtitles-pure.m3u" >> $OUTPUT_CMD
        echo "and $OUTPUT_CMD"

