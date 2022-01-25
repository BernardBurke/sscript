# /bin/bash
OUTFILE=$EDLWINSCRATCH/shuffle_$$.edl
find $KEYCUTWIN -type f -iname '*.edl'| sort -Ru | shuf -n 9 | while read file; do
	cat "$file" >> $OUTFILE
    # Something involving $file, or you can leave
    # off the while to just get the filenames
done
$SRC/shake_an_edl.sh $OUTFILE
