# /bin/bash
# take (initially) 2 input files, read one record at a time from each, make an output containing alternetive records from both
# inspired by Natasha Kinski and Zoe Bloom
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
    OUTPUT_FILE="$SCRATCHDIR/rifle_$$.edl"
else
    OUTPUT_FILE="$1"
fi

echo "${@: $#-1}"

arr=()

for (( i=2; i <= "$#"; i++ )); do 
    echo "File as pos ${i} ..> ${!i}"
    if [ -f "${!i}" ]; then
            echo "${!i} exists"
            j="$(( i - 1 ))"
            arr[$j]=$(wc -l "${!i}")
            echo "Array $j is ${arr[$j]}"
            cat "${!i}" > "$TMPFILE$j"
    else
            echo "${!i} does NOT exist"
            exit 1
    fi
done

TMPFILEN=$(mktemp)

for (( k=2; k <= "$#"; k++ )); do 
    l="$(( k - 1 ))"
    echo "Ell is $l"
    cat "$TMPFILE$l" >> $TMPFILEN
   
done

cat $TMPFILEN > $OUTPUT_FILE

$SRC/shake_an_edl.sh $OUTPUT_FILE

if ( $ONWSL ) then
       cmd.exe /c  mpv  --volume=10 --screen=0 --fs-screen=0 --fullscreen $(wslpath -w $OUTPUT_FILE) 
else
        mpv --volume=10  --screen=0 --fs-screen=0 --fullscreen  $OUTFILE
fi

exit 0

find $KEYCUTWIN -type f -iname '*.edl'| sort -Ru | shuf -n $SHUF_COUNT | while read file; do
	cat "$file" >> $OUTFILE
    # Something involving $file, or you can leave
    # off the while to just get the filenames
done
