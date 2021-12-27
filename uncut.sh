#!/bin/bash
# search for uncut videos based on a directory spec
# Also provide a count
# eg: ./uncut -d $GRLSRC/pure -c 20
# find 20 videos in pure that don't have a record in KEYCUTWIN/UNI
source $SRC/common_inc.sh


echo $KEYDIR $TMPFILE1



USAGE_MSG="-d SEARCH_DIR  -c COUNT  -m MODIFY_TIME"
SEARCH_PATH="$GRLSRC"
SEARCH_DIR="$SEARCH_PATH/pure" # a default
COUNT=1
COUNT=20
OUTPUT_DIR="$NEWDIR"
FILE_NAME=CUTbatch
OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"
echo "Output Stub $OUTPUT_STUB"


MODIFY_TIME=-7 # default to a week
COUNT=10

echo $USAGE_MSG

while getopts "d:c:m:" opt; do
        case $opt in
                d )     echo "Search dir  $OPTARG"
                        SEARCH_DIR="$OPTARG"
                        if [ ! -d "$SEARCH_DIR" ]; then
                            echo "$OPTARG is not a directory"
                            exit 1
                        fi
                        ;;
                c )     if [ "$OPTARG" != "" ]; then
                            COUNT="$OPTARG"
                            echo "Count is $COUNT"
                        fi
                        ;;
                m )     MODIFY_TIME=$OPTARG
                        echo "Modify time is $MODIFY_TIME"
                        ;;
                * )     echo "Param probs"
			echo "$USAGE_MSG"
                        exit 1
        esac
done

# make the grep file if required.
echo "Search Path is $SEARCH_PATH "
echo "MODIFY_TIME is $MODIFY_TIME"


for f in $SEARCH_DIR/*.m??; do
    echo $f 
    this_file="$f"
    this_file=$(basename -- "$this_file")
    this_file="${this_file%.*}"
    this_file="$this_file.edl"
    #echo "-------------> $this_file"
    status="$(find $KEYDIR -name "$this_file")"
    #echo "status $status"
    if [ -f "$status" ]; then
        echo "$f is already CUT"
    else
        if $ONWSL 
            then
            wpath=$(wslpath -w "$f")
            #echo "mpv --volume=10 \"$wpath\"" 
            echo "mpv --volume=50 --fullscreen --fs-screen=0 \"$wpath\"" --screen=0 >> "$TMPFILE1"

            echo "pause" >> "$TMPFILE1"


        fi 
    
        ((COUNTER++))

        if [ "$COUNTER" -gt "$COUNT" ]; then
            break
        fi

    fi 
done

echo "Found $COUNTER Cuttable files"

cat $TMPFILE1 | sort -Ru > "$BATCHSRC/CUTTING.cmd"

echo "pause" >> "$BATCHSRC/CUTTING.cmd"
