#!/bin/bash
#TMPFILE1=$(mktemp)
#TMPFILE2=$(mktemp)
#TMPFILE3=$(mktemp)
#TMPGREP1=$(mktemp)

if  ( command -v wslpath &> /dev/null ) ; then
        #echo "Running on WSL"
        ONWSL=true
        TAGDIR=$TAGWIN
        HANDDIR=$HANDWIN
else
        echo "wsl not available "
        ONWSL=false
        HANDDIR=$HANDUNI
        TAGDIR=$TAGUNI

fi

for f in $TAGDIR/*.m3u; do
    echo $f 
    this_file="$f"
    this_file=$(basename -- "$this_file")
    this_file="${this_file%.*}"
    echo $this_file

     if [ -d "$TAGDIR/$this_file" ]; then

            while IFS=. read -r lion ; do
                lion=$(wslpath -u "$lion")
                lion=$(basename -- "$lion")
                lion="${lion%.*}"
                echo $lion
                touch "$TAGDIR/$this_file/$lion"
                echo "created $TAGDIR/$this_file/$lion"
            done < "$f"
            echo "Moving $f contents to $TAGDIR/$this_file"

            # cat "$f" > "$TAGDIR/$this_file/$this_file"
    else

        echo "$TAGDIR/$this_file  does not exist"
        exit 1
    fi
done