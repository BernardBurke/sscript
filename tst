#!/bin/bash
strt=10
length=25
period=24
while true; do
	#echo "Length $length Start $strt Period $period"
	runtime=$(( $strt + $period ))
	#echo "Runtime $runtime"
	if [ "$length" -lt "$runtime" ]; then
		period=$[ "$period" - "1" ]
	else
		break
	fi
done
$echo "Length $length Start $strt Period $period"

