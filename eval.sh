#!/bin/sh
SCRIPTPATH=`pwd`
EVALMODEL=guj
for OLDMODEL in Gujarati gujPlus  ; do
     nohup time -p bash  oldmodeleval.sh ${OLDMODEL} $EVALMODEL > reports/$EVALMODEL-eval-${OLDMODEL}.txt & 
done
