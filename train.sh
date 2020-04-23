#!/bin/bash
# nohup bash  train.sh > train.log & 
export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
GTDIR=gt
MODEL=guj
STARTMODEL=Gujarati
BUILDTYPE=Plus

mkdir -p data

cp ~/langdata_lstm/Gujarati.unicharset  data/Gujarati.unicharset
cp ~/langdata_lstm/Latin.unicharset  data/Latin.unicharset
cp ~/langdata_lstm/Inherited.unicharset  data/Inherited.unicharset

mkdir -p   data/$STARTMODEL
combine_tessdata -u data/$STARTMODEL.traineddata  data/$STARTMODEL/$STARTMODEL.

cd $SCRIPTPATH
rm -rf data/$MODEL
mkdir -p data/$MODEL
cp ~/langdata_lstm/guj/guj.punc data/$MODEL/$MODEL.punc
cp ~/langdata_lstm/guj/guj.numbers data/$MODEL/$MODEL.numbers

for f in $GTDIR/*/*.lstmf; do ls -1 "${f}"; done  > /tmp/$MODEL-all-lstmf
python shuffle.py < /tmp/$MODEL-all-lstmf > $SCRIPTPATH/data/$MODEL/all-lstmf
for f in $GTDIR/*/*.gt.txt; do cat "${f}"; echo; done  > $SCRIPTPATH/data/$MODEL/all-gt

cd  $SCRIPTPATH/data/$MODEL
Version_Str="$MODEL:shreeshrii`date +%Y%m%d`:from:"
sed -e "s/^/$Version_Str/" $SCRIPTPATH/data/$STARTMODEL/$STARTMODEL.version > $MODEL.version

cd ../..

make  lists MODEL_NAME=$MODEL RATIO_TRAIN=0.80

nohup make  training  \
MODEL_NAME=$MODEL  \
LANG_TYPE=Indic \
BUILD_TYPE=$BUILDTYPE  \
TESSDATA=data \
GROUND_TRUTH_DIR=$SCRIPTPATH/gt \
START_MODEL=$STARTMODEL \
LAYER_NET_SPEC="[Lfx 128 O1c1]" \
LAYER_APPEND_INDEX=5 \
RATIO_TRAIN=0.80 \
DEBUG_INTERVAL=-1 \
EPOCHS=20 > train-$MODEL-$BUILDTYPE.log & 