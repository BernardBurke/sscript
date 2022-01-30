# /bin/bash
# take (initially) 2 input files, read one record at a time from each, make an output containing alternetive records from both
# inspired by Natasha Kinski and Zoe Bloom
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
    OUTPUT_FILE="$SCRATCHDIR\rifle_$$.edl
else
    OUTPUT_FILE="$1"
fi

echo "${@: $#-1}"

exit


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

if ( $ONWSL ) then
       cmd.exe /c  mpv  --volume=10 --screen=0 --fs-screen=0 --fullscreen $(wslpath -w $OUTFILE) 
else
        mpv --volume=10  --screen=0 --fs-screen=0 --fullscreen  $OUTFILE
fi
