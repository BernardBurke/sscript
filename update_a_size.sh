# /bin/bash
TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
TMPFILE3=$(mktemp)
IFS=$(echo -en "\n\b")
j=0
./check_for_size_updates.sh 10 $1 > $TMPFILE1
cat $TMPFILE1
while IFS= read -r f
do
        #echo $f
        leng=$(ffprobe -v quiet  -of csv=p=0 -show_entries format=duration $f)
        sex=${leng%.*}
        [[ ! -z "$sex" ]] && echo "$f,$sex" >> $TMPFILE2
        ((j++))
done < "$TMPFILE1"
cat $TMPFILE2
echo "$1_sizes currently has $(wc -l $EDLSRC/$1_sizes) records"
read -p "Press return to append the above to $EDLSRC/$1_sizes and remove dupes"
cat $TMPFILE2 $EDLSRC/$1_sizes | sort -Ru > "$TMPFILE3"
cat $TMPFILE2 >> $EDLSRC/$1_sizes
echo "After the update, $1_sizes currently has $(wc -l $EDLSRC/$1_sizes) records"

