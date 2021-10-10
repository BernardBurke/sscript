#!/bin/bash
# get a bunch of randomised records from list of directories
# paramaters for basically all the old BATCH scripts
#
# which libraries do we want to search?
# what are the search term(s)
# how many output files?
# to stop duping results, the output files will be written in SCRATCHDIR
#
TMPFILE1=$(mktemp)
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

USAGE_MSG="-d SEARCH_DIR -s SEARCH_TERMS -o OUTPUT_FILE -k SEARCH_KEYDIR -s SEARCH_SCRATCH_DIR -h SEARCH_HANDDIR -n NameMask -c SHUFFLE_N -l LOOP_COUNT"
INDEX_OUTPUT=0
DEFAULT_OUTPUT_NAME="$(basename $0)_$INDEX_OUTPUT_$$.edl"
SEARCH_PATH=""
LOOP_COUNT=1
RANDOM_COUNT=20
OUTPUT_DIR="$SCRATCHDIR"
FILE_NAME=SearchTerms
OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"

while getopts "d:g:r:o:kshwn:l:" opt; do
        case $opt in
                g )     echo "Search terms $OPTARG"
                        SEARCH_TERMS="$OPTARG"
                        ;;
                d )     echo "Search dir  $OPTARG"
                        SEARCH_DIR="$OPTARG"
                        ;;
                o )     if [ "$OPTARG" != "" ]; then
                                OUTPUT_DIR="$OPTARG"
                                if [ ! -d "$OUTPUT_DIR" ]; then
                                    echo "$OUTPUT_DIR does not exist"
                                    exit 1
                                fi    
                        else
                            $OUTPUT_DIR=$SCRATCHDIR
                        fi
                        echo "Output file  $OUTPUT_DIR"
                        ;;
                k )     echo "will search $KEYDIR"
                            SEARCH_PATH="$SEARCH_PATH $KEYDIR/*.edl "
                        ;;
                s )     echo "will search $SCRATCHDIR"
                            SEARCH_PATH="$SEARCH_PATH $SCRATCHDIR/*.edl "
                        ;;
                h )     echo "will search $HANDDIR"
                            SEARCH_PATH="$SEARCH_PATH $HANDDIR/*.edl "
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
                w)      echo "****will search $NEWDIR ****** New Dir over-rides all other directories"
                                SEARCH_PATH="$NEWDIR/*.edl"
                        ;;
                * )     echo "Param probs"
                        exit 1
        esac
done

# make the grep file

for i in ${SEARCH_TERMS//,/ }
    do 
    # echo "splitting terms $i"
    echo "$i" >> $TMPGREP1
done

echo "Search Path is $SEARCH_PATH search terms are "
cat $TMPGREP1



grep  -h -i -f $TMPGREP1  -- $SEARCH_PATH | sort -Ru > $TMPFILE1

$SRC/two_commas.sh $TMPFILE1 > $TMPFILE3
#cat $TMPFILE2

#read -p "Press return"

for ((j=1;j<=$LOOP_COUNT;j++))
        do 
                OUTPUT_FILE="$OUTPUT_STUB$j.edl"
                if [ -f $OUTPUT_FILE ]; then
                        echo "Preserving $OUTPUT_FILE "
                        OUTPUT_PRES="$OUTPUT_STUB$j_$$.edl"
                        cp -v "$OUTPUT_FILE" "$OUTPUT_PRES"
                fi
                echo "Writing $OUTPUT_FILE"
                echo "# mpv EDL v0" > $OUTPUT_FILE
                shuf  -n $RANDOM_COUNT $TMPFILE1 >> $OUTPUT_FILE
done

exit 0

