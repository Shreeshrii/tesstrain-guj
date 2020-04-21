#!/bin/bash
# SINGLE line images using kraken
# conda activate kraken
# nohup bash txt2png.sh   > txt2png.log & 
MODEL=guj
GTDIR=gt
unicodefontdir=/home/ubuntu/.fonts
traininginput=langdata/$MODEL.training_text
fontlist=langdata/guj.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
trainingtext=/tmp/$MODEL-train.txt
fonttext=/tmp/$MODEL-kraken-train
shuf  ${traininginput}  > ${trainingtext} 
mkdir -p $GTDIR
 while IFS= read -r fontname
     do
        echo "$fontname"
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
#        split -n l/2  -d ${fonttext} ${fonttext}
        ketos linegen  -u NFC  --disable-degradation -f "${fontname}" -o $GTDIR/kraken00-"${fontname// /_}" ${fonttext}
#        ketos linegen  -u NFC  -f "${fontname}" -o $GTDIR/kraken01-"${fontname// /_}" ${fonttext}01
    done < "$fontlist"
