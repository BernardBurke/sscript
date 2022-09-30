# re shuffle and existing edl and replace it
# updated to preserve source file as -shake-preserve$$
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
SHAKFILE=$(basename "$1" .edl)-shake-preserve-$$.edl


cp -v "$1" "$WSCR/$SHAKFILE"

if [[ ! -f $1 ]]; then
    echo "$1 does not exist"
    exit
fi

if [[ $SHAKE_DEFAULT == "" ]]; then
	SHAKE_DEFAULT=400
fi

#cp -v "$1" "$SHAKFILE"

echo "# mpv EDL v0" > $TMPFILE1

cat "$1" | grep -v "#" |  sort -Ru | shuf -n $SHAKE_DEFAULT >> $TMPFILE1

cat "$TMPFILE1"

cp -v "$TMPFILE1" $1

echo "Preserved $1 as $WSCR/$SHAKFILE"
