# re shuffle and existing edl and replace it
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)

if [[ ! -f $1 ]]; then
    echo "$1 does not exist"
    exit
fi

if [[ $SHAKE_DEFAULT == "" ]]; then
	SHAKE_DEFAULT=400
fi

cp -v "$1" /tmp

echo "# mpv EDL v0" > $TMPFILE1

cat "$1" | grep -v "#" |  sort -Ru | shuf -n $SHAKE_DEFAULT >> $TMPFILE1

cat "$TMPFILE1"

cp -v "$TMPFILE1" $1
