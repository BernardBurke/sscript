#!/bin/bash
# The old format of handmade tried to apply tags to a set of EDLs
# The Keycut setup seem sto be way better. While I come up with a better tagging system, 
# It seems sensible to reprocess all the handmade EDL files to keycut versions
# Looking at the existing stufd in handwind - it's clearly grouped that way (when sorted)
#
TMPFILE1=$(mktemp) # for find results
TMPFILE2=$(mktemp)
TMPFILE3=$(mktemp)
TMPBASENAME=$(mktemp)
TMPCOMMENT=$(mktemp)

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

USAGE_MSG="-d SEARCH_DIR -s SEARCH_TERMS -o OUTPUT_FILE -n NameMask -c SHUFFLE_N -l LOOP_COUNT"
SEARCH_DIR="$HANDDIR"
LOOP_COUNT=1
RANDOM_COUNT=20
OUTPUT_DIR="$SCRATCHDIR"
FILE_NAME=hand2key
OUTPUT_STUB="$OUTPUT_DIR/$FILE_NAME"
echo "Output stub $OUTPUT_STUB"


while getopts "d:g:r:o:n:l:m:" opt; do
        case $opt in
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
                * )     echo "Param probs"
                        exit 1
        esac
done


isHashComment() {
    
    firstChar=${1:0:1}

    if [[ $firstChar == "#" ]]; then
        return 0
    else
        return 1
    fi 
}




echo "Collecting records from $SEARCH_DIR"

cat $HANDWIN/*.edl | sort -u >> $TMPFILE1

#cat $TMPFILE1

echo "Checking commas in each record"

if $ONWSL
    then echo "Converting to WSL Windows paths"
    OLDIFS=$IFS
    while IFS=, read -r fname start length ; do
        if isHashComment "$fname"; then
            echo "$fname, $start, $length" >> $TMPCOMMENT
        else 
            echo  "$fname" >> $TMPFILE2
        fi
    done < "$TMPFILE1"
fi

IFS=$OLDIFS

echo "reducting to unique names"

cat $TMPFILE2 | sort -u > $TMPFILE3

# this is a bit of a pain. But, the source EDLs with have windows Paths and I want to do -f


while IFS=, read -r bname start length ; do
    # echo "bname $bname"
    wname=$(wslpath  "$bname")
    if [ -f "$wname" ]; then
        fname="$(basename "$wname")"
        BARE_FILENAME="${fname%.*}"
        EDL_FILENAME="$OUTPUT_DIR/$BARE_FILENAME.edl"
        echo "will search $SEARCH_DIR/*.edl for $BARE_FILENAME and output to $EDL_FILENAME"
        echo "# mpv EDL v0" > "$EDL_FILENAME"
        echo "## tags:two,parakeets,lunch,sundown" >> "$EDL_FILENAME"
        grep -h "$BARE_FILENAME" $SEARCH_DIR/*.edl | sort -u >> "$EDL_FILENAME"
    fi
done < $TMPFILE3

exit 0


IFS=$OLDIFS

exit 0