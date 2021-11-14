#!/bin/bash
TMPFILE1=$(mktemp)
#TMPFILE2=$(mktemp)
#TMPFILE3=$(mktemp)
#TMPGREP1=$(mktemp)

if  ( command -v wslpath &> /dev/null ) ; then
        #echo "Running on WSL"
        ONWSL=true
        TAGDIR=$TAGWIN
        HANDDIR=$HANDWIN
        KEYDIR=$KEYCUTWIN
else
        echo "wsl not available "
        ONWSL=false
        HANDDIR=$HANDUNI
        TAGDIR=$TAGUNI
        KEYDIR=$KEYCUTUNI

fi

for f in $KEYDIR/*.edl; do
    #echo $f 
    this_file="$f"
    this_file=$(basename -- "$this_file")
    this_file="${this_file%.*}"
    #echo "-------------> $this_file"
    status="$(find $TAGDIR -name "$this_file")"
    #echo "status $status"
    if [ -f "$status" ]; then
        echo "$f is already tagged"
    else
        if $ONWSL 
            then
            wpath=$(wslpath -w "$f")
            #echo "mpv --volume=10 \"$wpath\"" 
            echo "mpv --volume=10 \"$wpath\"" --screen=0 >> "$TMPFILE1"
            echo "dir d:\edlv2\metadata\tags\windows\*.m3u" >> "$TMPFILE1"
            echo "set /p tagthis=What TAG for \"$wpath\" ?" >> "$TMPFILE1"
            echo "echo \"$wpath\" >> d:\edlv2\metadata\tags\windows\%tagthis%.m3u" >> "$TMPFILE1"
            echo "set /p argggg=Press Return for next :" >> "$TMPFILE1"
        fi 
    fi 
done

cat $TMPFILE1 > "$BATCHSRC/tagging.cmd"