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
TMPGREP1=$(mktemp)

if  ( command -v wslpath &> /dev/null ) ; then
        #echo "Running on WSL"
        ONWSL=true
        KEYDIR="$KEYCUTWIN"
        SCRATCHDIR="$EDLWINSCRATCH"
	    HANDDIR="$HANDWIN"
else
        echo "wsl not available "
        ONWSL=false
        KEYDIR="$KEYCUTUNI"
        SCRATCHDIR="$EDLUNISCRATCH"
	    HANDDIR="$HANDUNI"

fi

USAGE_MSG="-d SEARCH_DIR -s SEARCH_TERMS -o OUTPUT_FILE -k SEARCH_KEYDIR -s SEARCH_SCRATCH_DIR -h SEARCH_HANDDIR -n NameMask -c SHUFFLE_N -l LOOP_COUNT"
INDEX_OUTPUT=0
DEFAULT_OUTPUT_NAME="$(basename $0)_$INDEX_OUTPUT_$$.edl"
SEARCH_PATH=""

while getopts "d:g:r:o:kshn:" opt; do
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

echo "Search Path is $SEARCH_PATH "

cat $TMPGREP1

grep  -h -f $TMPGREP1  -- $SEARCH_PATH > $TMPFILE1

cat $TMPFILE1

exit 0

cp $KEYDIR/Love1.edl $SCRATCHDIR/Love1_$$.edl -v
cp $KEYDIR/Love2.edl $SCRATCHDIR/Love2_$$.edl -v
cp $KEYDIR/Love2.edl $SCRATCHDIR/Love3_$$.edl -v
cp $KEYDIR/header $KEYDIR/Love1.edl
cp $KEYDIR/header $KEYDIR/Love2.edl
cp $KEYDIR/header $KEYDIR/Love3.edl
cat $HANDDIR/*.edl $KEYDIR/*.edl  $KEYDIR/new/*.edl | sort -Ru | head -n 40 >> $KEYDIR/Love1.edl
cat $HANDDIR/*.edl $KEYDIR/*.edl  $KEYDIR/new/*.edl | sort -Ru | head -n 40 >> $KEYDIR/Love2.edl
cat $HANDDIR/*.edl $KEYDIR/*.edl  $KEYDIR/new/*.edl | sort -Ru | head -n 40 >> $KEYDIR/Love3.edl
