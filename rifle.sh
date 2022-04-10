# /bin/bash
# take (initially) 2 input files, read one record at a time from each, make an output containing alternetive records from both
# inspired by Dominique and Uma
source $SRC/common_inc.sh

if [[ "$1" = "" ]]; then
    	echo "Provide file 1"
	exit
else
    if [[ ! -f $1 ]]; then
	    echo "$1 does not exist"
	    exit
    fi
    FILE1="$1"
    FILE1_COUNT=$(wc -l < "$FILE1")
fi

if [[ "$2" = "" ]]; then
        echo "Provide file 2"
        exit
else
    if [[ ! -f $2 ]]; then
            echo "$2 does not exist"
            exit
    fi
    FILE2="$2"
    FILE2_COUNT=$(wc -l < "$FILE2")
fi

if [[ "$3" = "" ]]; then
	echo "setting TAG1 to default"
	TAG1="Rif_$$"
else
	TAG1="$3"
fi


if [[ "$4" = "" ]]; then
        echo "setting TAG1 to default"
        TAG2="def"
else
        TAG2="$4"
fi

echo $TAG1
echo $TAG2

OUT_FILENAME="$TAG1-$TAG2-$$.edl"


echo $OUT_FILENAME

read -p "tags"

CORRECT_ORDER="$(( FILE2_COUNT > FILE1_COUNT ))"


DOUBLE_FILE2_COUNT="$(( FILE2_COUNT * 2 ))"

if (( CORRECT_ORDER )); then
	echo "$FILE2 has $FILE2_COUNT records and $FILE1 has $FILE1_COUNT records"
	echo "Please provide more records in Parameter 1"
	exit
fi



while read -r f1line
do 
    echo $f1line >> $TMPFILE1
    shuf -n 1 "$FILE2" >> $TMPFILE1
done < "$FILE1"


cat $TMPFILE1

read -p "That was tmpfile1"

echo "# mpv EDL v0" > $TMPFILE2

#cat "$TMPFILE1" | grep -v "#" |  sort -Ru | shuf -n $DOUBLE_FILE2_COUNT >> $TMPFILE2

cat $TMPFILE1 >> $TMPFILE2

cat $TMPFILE2

read -p "Press return to write"

if ( $ONWSL ) ; then 
	cat $TMPFILE2 > $RIFW/$OUT_FILENAME
else
	cat $TMPFILE2 > $RIFU/$OUT_FILENAME
fi


