cat $EDLWINSCRATCH/MASTER*.edl | sort -Ru | shuf -n 200 > $EDLWINSCSRATCH/MyMaster.edl
./shake_an_edl $EDLWINSCSRATCH/MyMaster.edl

