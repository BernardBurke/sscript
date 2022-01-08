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
SEARCH_TERM=""
OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"
DITCHED_FILE="$EDLSRC/ditched.txt"
echo "Output Stub $OUTPUT_STUB"


MODIFY_TIME=-7 # default to a week
COUNT=10

echo $USAGE_MSG

while getopts "d:c:m:s:" opt; do
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
                s )     SEARCH_TERM=$OPTARG
                        echo "Search term is $SEARCH_TERM"
                        ;;

                * )     echo "Param probs"
			echo "$USAGE_MSG"
                        exit 1
        esac
done

# make the grep file if required.
echo "Search Path is $SEARCH_PATH "
echo "Search term is $SEARCH_TERM"
echo "MODIFY_TIME is $MODIFY_TIME"

if [[ "$SEARCH_TERM" == "" ]]; then
    echo "No Search Term"
    find $SEARCH_DIR -type f -mtime $MODIFY_TIME  -iname "*.m??" > $TMPFILE2
else
    echo "Search term is  $SEARCH_TERM---->"
    find $SEARCH_DIR -type f -mtime $MODIFY_TIME -iname "*$SEARCH_TERM*.m??" > $TMPFILE2
fi

cat $TMPFILE2



while IFS= read -r fname; do
    echo $f 
    
    this_file="$fname"
    this_file=$(basename -- "$this_file")
    this_file="${this_file%.*}"
    if grep "$this_file" $DITCHED_FILE; then
        echo "Ditched----> $this_file"
    else
        this_file="$this_file.edl"
        echo "-------------> $this_file"
        status="$(find $KEYDIR -name "$this_file")"
        echo "status $status"
        if [ -f "$status" ]; then
            echo "$fname is already CUT"
        else
            if $ONWSL 
                then
                wpath=$(wslpath -w "$fname")
                #echo "mpv --volume=10 \"$wpath\"" 
                echo "$wpath" >> "$TMPFILE1"

            fi 
        
            ((COUNTER++))

            if [ "$COUNTER" -gt "$COUNT" ]; then
                break
            fi

        fi 
    fi
    
done < $TMPFILE2

echo "Found $COUNTER Cuttable files"

cat $TMPFILE1 | sort -Ru > "$BATCHSRC/CUTTING.m3u"

cat "$BATCHSRC/CUTTING.m3u"