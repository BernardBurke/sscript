#/bin/bash
# return the records in $1 only with records that have $2 commas
# Written to work around filenames containing commas
if [ !-f "$1"]
    then
        echo "$1 does not exist"
        exit 1
fi

# default of 2 commas
if [ -z $2 ]
    then 
        COUNT_COMMAS=2
    else
        COUNT_COMMAS=$2
fi

while IFS=, read -r one two three four
    do 
        if [ !-z "$four" ]
            then
                echo "### too many commas $one $two $three $four"
        else
            echo "$one,$two,$three"
        fi
done < $1