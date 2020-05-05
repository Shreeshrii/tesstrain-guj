#!/bin/sh
# bash eval.sh Gujarati_fast
# bash eval.sh gujMinus_fast
 
bash maketessdata.sh
SCRIPTPATH=`pwd`
LISTEVAL=guj
for OLDMODEL in $1  ; do
     nohup time -p bash  oldmodeleval.sh $OLDMODEL $LISTEVAL > reports/$LISTEVAL-eval-$OLDMODEL.txt & 
done
