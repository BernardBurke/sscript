# /bin/bash
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
    INPUT_DIR=$KEYDIR
    OUTPUT_DIR=$SCRATCHDIR
else
    INPUT_DIR=$1
    OUTPUT_DIR=$SCRATCHDIR

fi


if [[ "$2" = "" ]]; then
   SHUF_COUNT=10 
else
   SHUF_COUNT=10
fi

OUTFILE=$SCRATCHDIR/shuffle_$$.edl

find $KEYCUTWIN -type f -iname '*.edl'| sort -Ru | shuf -n $SHUF_COUNT | while read file; do
	cat "$file" >> $OUTFILE
    # Something involving $file, or you can leave
    # off the while to just get the filenames
done
$SRC/shake_an_edl.sh $OUTFILE
