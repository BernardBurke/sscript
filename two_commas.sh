#/bin/bash
# return the records in $1 only with records that have $2 commas
# Written to work around filenames containing commas
if [[ -f "$1" ]]
    then
        echo "Processing $1"
    else
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

echo "Will target $COUNT_COMMAS "



#read -p "Press return to execute:"

while read -r line
do
    count=${line//[^,]}
    COUNT="${#count}"
    if [[ $COUNT == 2 ]]
        then echo $line
    else
        echo "##WrongComma## $line"
    fi
done < $1

# while IFS=, read -r one two three four
#     do 
#         echo "one $one two $two three $three four $four " [ -z $four ] "<-"
#         if [[ "$four"!="" ]]
#             then
#                 echo "### too many commas $one $two $three $four"
#         else
#             echo "$one,$two,$three"
#         fi
# done < $1