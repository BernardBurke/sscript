# loop through the pure grls and create a list of files that are not in pure_size
# may update for paramaterised directories some day
TMPFILE=$(mktemp)
while IFS= read -r -d '' file; do
  	#echo "Checking ---> $file"
	
	if  ! grep  -q "$file" /mnt/d/edl/pure_sizes ; then

		echo "$file" >> $TMPFILE
	fi

done < <(find /mnt/d/grls/pure -type f -mtime -$1 -print0)
#echo "These files will get measured" 
#cat $TMPFILE
./get_length_of_a_file_contents $TMPFILE
