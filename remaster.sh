# /bin/bash
source $SRC/common_inc.sh

INPUT_NAME="$(basename $1)"
echo $INPUT_NAME1
INPUT_FILE="$1.m3u"
OUTPUT_DIR="$HANDWIN"
OUTPUT_FILE1="$OUTPUT_DIR/${INPUT_NAME}1.m3u"
OUTPUT_FILE2="$OUTPUT_DIR/${INPUT_NAME}2.m3u"
OUTPUT_FILE3="$OUTPUT_DIR/${INPUT_NAME}3.m3u"

echo $INPUT_NAME
echo " outfile 1 is $OUTPUT_FILE1"


if [[ ! -f "$INPUT_FILE" ]]; then
	echo "file not provided or $1 does not exist"
     	exit 0	
fi


if [[ "$2" = "" ]]; then
   SHUF_COUNT=10 
else
   SHUF_COUNT=10
fi


cp -v "$INPUT_FILE" "$OUTPUT_FILE1"
$SRC/blend_m3u.sh "${INPUT_NAME}1"
cp -v "$INPUT_FILE" "$OUTPUT_FILE2"
$SRC/blend_m3u.sh  "${INPUT_NAME}2"
cp -v "$INPUT_FILE" "$OUTPUT_FILE3"
$SRC/blend_m3u.sh "${INPUT_NAME}3"

FIXX=${OUTPUT_DIR}/${INPUT_NAME}1.edl

WINPAT="$(wslpath -w $FIXX)"

echo "mpv  --volume=10 --screen=0 --fs-screen=0 --fullscreen $WINPAT"

exit

if ( $ONWSL ) then
       cmd.exe /c  mpv  --volume=10 --screen=0 --fs-screen=0 --fullscreen $(wslpath -w $OUTFILE) 
else
        mpv --volume=10  --screen=0 --fs-screen=0 --fullscreen  $OUTFILE
fi
