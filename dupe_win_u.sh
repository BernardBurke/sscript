if [ -z $1 ] || [ -z $2 ]
    then
        echo "Useage is $(basename $0) source_dir dest_dir [overwrite y/n default N]"
        exit 1
fi

if [ -d "$1" ]
	then
		SOURCE_DIR=$1
	else
		echo "$1 does not exist"
        exit 1
fi

if [ -d "$2" ]
	then
		DEST_DIR=$2
	else
		echo "$2 does not exist"
        exit 1
fi

if [ ! -z $3 ]
    then
    shopt -s nocasematch
    if [[ $3 == "y" ]]
        then
            OVERWRITE=1
            echo "Overwrite"
        else
            OVERWRITE=0
            echo "No Overwrites!!"
    fi
fi

for f in $SOURCE_DIR/*.edl;  
do 
    DEST_FILE=$DEST_DIR/$(basename "$f")
    if [ -f "$DEST_FILE" ] 
        then 
            if [[ "$OVERWRITE" == 1 ]]
                then 
                    echo ">>>>> Overwritting as OVERWRITE set $OVERWRITE"
                    echo "----------Overwrite of $DEST_FILE"
                    echo "$SRC/cnvwinu $f > $DEST_FILE"
                    $SRC/cnvwinu "$f" > "$DEST_FILE"
                else
                    echo "Skipping due to OVERWRITE clear and target exists $DEST_FILE"
            fi
        else
            echo "New file"
            echo "$SRC/cnvwinu $f > $DEST_FILE"
            $SRC/cnvwinu "$f" > "$DEST_FILE"

    fi

# read -p "Press return"

done

