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


CORRECT_ORDER="$(( FILE2_COUNT > FILE1_COUNT ))"


if (( CORRECT_ORDER )); then
	echo "$FILE2 has $FILE2_COUNT records and $FILE1 has $FILE1_COUNT records"
	echo "Please provide more records in Parameter 1"
	exit
fi


while read -r f1line
do 
    echo $f1line
    shuf -n 1 "$FILE2"
done < "$FILE1"