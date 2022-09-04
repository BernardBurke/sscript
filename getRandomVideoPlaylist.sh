source $SRC/common_inc.sh
find /mnt/v -iname '*.mp4' -o -iname '*.avi' -o -iname '*.mkv'  | shuf -n 10 > $TMPFILE1
find /mnt/s -iname '*.mp4' -o -iname '*.avi' -o -iname '*.mkv'  | shuf -n 10 >> $TMPFILE1

while read -r line; do
    wslpath -w "$line" >> $WINMOVIE/CompletelyRandom_$$.m3u
done < $TMPFILE1
$SRC/m3u2chopped.sh $WINMOVIE/CompletelyRandom_$$.m3u 90 