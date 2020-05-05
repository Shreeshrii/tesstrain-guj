#!/bin/bash
# nohup bash  train.sh > train.log & 
export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
GTDIR=gt
MODEL=guj
STARTMODEL=Gujarati
BUILDTYPE=Minus

mkdir -p data
cp ~/tessdata_best/script/Gujarati.traineddata data/$STARTMODEL.traineddata 
cp ~/langdata_lstm/Gujarati.unicharset  data/Gujarati.unicharset
cp ~/langdata_lstm/Latin.unicharset  data/Latin.unicharset
cp ~/langdata_lstm/Inherited.unicharset  data/Inherited.unicharset
cp ~/langdata_lstm/radical-stroke.txt data/radical-stroke.txt 

mkdir -p   data/$STARTMODEL
combine_tessdata -u data/$STARTMODEL.traineddata  data/$STARTMODEL/$STARTMODEL.

cd $SCRIPTPATH
rm -rf data/$MODEL
mkdir -p data/$MODEL
cp langdata/guj.punc data/$MODEL/$MODEL.punc
cp langdata/guj.numbers data/$MODEL/$MODEL.numbers
cp langdata/guj.wordlist data/$MODEL/$MODEL.wordlist

for f in $GTDIR/*/*.lstmf; do ls -1 "${f}"; done  > /tmp/$MODEL-all-lstmf
python shuffle.py < /tmp/$MODEL-all-lstmf > $SCRIPTPATH/data/$MODEL/all-lstmf
for f in $GTDIR/*/*.gt.txt; do cat "${f}"; echo; done  > /tmp/$MODEL-all-gt
python shuffle.py < /tmp/$MODEL-all-gt > $SCRIPTPATH/data/$MODEL/all-gt

cd  $SCRIPTPATH/data/$MODEL
Version_Str="$MODEL:shreeshrii`date +%Y%m%d`:from:"
sed -e "s/^/$Version_Str/" $SCRIPTPATH/data/$STARTMODEL/$STARTMODEL.version > $MODEL.version

cd ../..

make  lists MODEL_NAME=$MODEL RATIO_TRAIN=0.90

nohup make  training  \
MODEL_NAME=$MODEL  \
LANG_TYPE=Indic \
BUILD_TYPE=$BUILDTYPE  \
TESSDATA=data \
GROUND_TRUTH_DIR=$SCRIPTPATH/gt \
START_MODEL=$STARTMODEL \
LAYER_NET_SPEC="[Lfx 128 O1c1]" \
LAYER_APPEND_INDEX=5 \
RATIO_TRAIN=0.90 \
DEBUG_INTERVAL=-1 \
EPOCHS=10 > train-$MODEL-$BUILDTYPE.log & 