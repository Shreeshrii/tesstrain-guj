#!/bin/sh
SCRIPTPATH=`pwd`
OLDMODELS=$(ls data/gujL*.traineddata)
EVALMODEL=guj
for OLDTRAINEDDATA in $OLDMODELS  ; do
    OLDMODEL="$(basename -- $OLDTRAINEDDATA)"
    nohup time -p bash  oldmodeleval.sh ${OLDMODEL%.*} $EVALMODEL > reports/$EVALMODEL-eval-${OLDMODEL%.*}.txt & 
done
