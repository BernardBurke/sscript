#!/bin/bash
# a more serious version of this converter - written initially to check a windows edl
source $SRC/common_inc.sh

find $EDLSRC -iname "*.edl" | grep -v unix | shuf -n 50  > $TMPFILE1
#find $GRLSRC -iname "*.mp4" -o -iname "*.jpg" | grep -v unix  | shuf -n 100  >> $TMPFILE1
find $GRLSRC -iname "*.mp4" -o -iname "*.mkv" | grep -v unix  | shuf -n 100  >> $TMPFILE1

cat $TMPFILE1 | sort -Ru > $TMPFILE3


IFS=$(echo -en "\n\b")

while IFS= read -r f
do
	echo $(wslpath -w "$f") >> $TMPFILE2
done < "$TMPFILE3"

# cmd.exe /c mpv  --no-config --script="c:\users\ben\mpv-ditch-or-bitch.lua" --fullscreen --playlist=$(wslpath -w $TMPFILE2)
#cmd.exe /c mpv  --playlist=$(wslpath -w $TMPFILE2)
echo "mpv --playlist=$(wslpath -w $TMPFILE2)"

