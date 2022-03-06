#!/bin/bash
# a more serious version of this converter - written initially to check a windows edl
source $SRC/common_inc.sh
# need 5 this time
TMPFILE4=$(mktemp)
TMPFILE5=$(mktemp)

#echo "# mpv EDL v0"


if !($ONWSL); then
        echo "This scrip is meant for WSL"
        exit 0
fi


if [[ ! -f "$1" ]]; then 
        echo "$1 does not exist "
        exit 1 
fi

if [[ $2 == "" ]] ; then
        SIZE_LIMIT=20
else 
        SIZE_LIMIT=$2 
fi

ANY_FNF=false

i=1

echo "# Long duration files" > $TMPFILE2

while IFS=, read -r name start length ; do
        if [[ "$name" == "d"* ]] || [[ "$name" == "D"* ]]; then
                ((i++))
                uname="$(wslpath -a "$name")"
                if [[ ! -f "$uname" ]]; then
                        echo "# $name file not found, record $i" >> $TMPFILE4
                        ANY_FNF=true
                else
                        if [[ "$length" -gt $SIZE_LIMIT ]]; then
                                echo "$uname,$start,$length" >> $TMPFILE2
                        else
                                echo "$uname,$start,$length" >> $TMPFILE1
                        fi 
                fi

        else
                echo "# $name " >> $TMPFILE3
        fi
done < "$1"

echo "# mpv EDL v0" 

cat $TMPFILE1 | sort -Ru >> $TMPFILE5
cat $TMPFILE2 | sort -Ru >> $TMPFILE5
cat $TMPFILE3 | sort -Ru >> $TMPFILE5
cat $TMPFILE4 | sort -Ru >> $TMPFILE5

if ($ANY_FNF) ; then
        exit 1
else 
        exit 0
fi

