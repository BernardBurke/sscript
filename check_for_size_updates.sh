# loop through the $GRLS/$2 directory and create a list of files that are not in $2_sizes
# $1 is the age in days to check for
# may update for paramaterised directories some day
TMPFILE=$(mktemp)
while IFS= read -r -d '' file; do
  	#echo "Checking ---> $file"
	
	if  ! grep  -q "$file" /mnt/d/edl/pure_sizes ; then

		echo "$file" >> $TMPFILE
	fi

done < <(find /mnt/d/grls/$2 -type f -mtime -$1 -print0)
#echo "These files will get measured" 
cat $TMPFILE
#./get_length_of_a_file_contents $TMPFILE
