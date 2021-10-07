#!/bin/bash
# So many cases call for
# Totally random videos; Time range videos (mosly new) and partial file names, 
# I thought it was time for the ultimate batch playlist prepartion tool
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

USAGE_MSG="-d SEARCH_DIR -s SEARCH_TERMS -o OUTPUT_FILE -n NameMask -c SHUFFLE_N -l LOOP_COUNT"
#INDEX_OUTPUT=0
#DEFAULT_OUTPUT_NAME="$(basename $0)_$INDEX_OUTPUT_$$.edl"
SEARCH_PATH="$GRLSRC"
LOOP_COUNT=1
RANDOM_COUNT=20
OUTPUT_DIR="$BATCHSRC"
FILE_NAME=editbatch
OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"
MODIFY_TIME=-7 # default to a week

while getopts "d:g:r:o:n:l:m:" opt; do
        case $opt in
                g )     echo "Search terms $OPTARG"
                        SEARCH_TERMS="$OPTARG"
                        ;;
                d )     echo "Search dir  $OPTARG"
                        SEARCH_DIR="$OPTARG"
                        if [ ! -d "$SEARCH_DIR" ]; then
                            echo "$OPTARG is not a directory"
                            exit 1
                        fi
                        ;;
                o )     if [ "$OPTARG" != "" ]; then
                                OUTPUT_DIR="$OPTARG"
                                if [ ! -d "$OUTPUT_DIR" ]; then
                                    echo "$OUTPUT_DIR does not exist"
                                    exit 1
                                fi    
                        fi
                        echo "Output file  $OUTPUT_DIR"
                        ;;
                l )     LOOP_COUNT=$OPTARG
                        echo "$LOOP_COUNT loops will execute" 
                        ;;
                r )     RANDOM_COUNT=$OPTARG
                        echo "shuffle will produce $RANDOM_COUNT records"
                        ;;
                n )     FILE_NAME=$OPTARG
                        echo "Writing to $FILE_NAME $LOOP_COUNT.edl in $OUTPUT_DIR"
                        OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"
                        echo "Stub $OUTPUT_STUB"
                        ;;
                m )     MODIFY_TIME=$OPTARG
                        echo "Modify time is $MODIFY_TIME"
                        ;;
                * )     echo "Param probs"
                        exit 1
        esac
done

# make the grep file if required.
echo "Search Path is $SEARCH_PATH "
echo "MODIFY_TIME is $MODIFY_TIME"




if [[ $SEARCH_TERMS != "" ]]; then
    echo "SEARCH_TERMS = $SEARCH_TERMS"
    for i in ${SEARCH_TERMS//,/ }
        do 
        # echo "splitting terms $i"
        echo "$i" >> $TMPGREP1
        echo "Search Terms are listed as "
        cat $TMPGREP1
    done

    for k in $(<$TMPGREP1)
        do
            #echo "executine  find  $SEARCH_DIR -iname '*$k*' -mtime $MODIFY_TIME "
            find  "$SEARCH_DIR" -iname "*$k*" -mtime $MODIFY_TIME  >> $TMPFILE2
            #cat $TMPGREP2
    done
else
    echo "No search terms"
    find $SEARCH_DIR   -mtime $MODIFY_TIME  >> "$TMPFILE2"
fi
  
#cat $TMPGREP2


echo "Sorting and making unique "
cat  $TMPFILE2 | sort -Ru  > $TMPFILE3

if $ONWSL
    then echo "Converting to WSL Windows paths"
    OLDIFS=$IFS
    while IFS=, read -r element ; do
        wslpath -m "$element" >> $TMPFILE1
    done < "$TMPFILE3"
fi

#read -p "Press return"

for ((j=1;j<=$LOOP_COUNT;j++))
        do 
                OUTPUT_FILE="$OUTPUT_STUB$j.m3u"
                if [ -f $OUTPUT_FILE ]; then
                        echo "Preserving $OUTPUT_FILE "
                        OUTPUT_PRES="$OUTPUT_STUB$j_$$.m3u"
                        cp -v "$OUTPUT_FILE" "$OUTPUT_PRES"
                fi
                echo "Writing $OUTPUT_FILE"
                shuf  -n $RANDOM_COUNT $TMPFILE1 >> $OUTPUT_FILE
done

exit 0