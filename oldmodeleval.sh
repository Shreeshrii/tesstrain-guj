#!/bin/sh

SCRIPTPATH=`pwd`
LISTEVALMODEL=$2
OLDMODEL=$1
FONTLIST=$SCRIPTPATH/langdata/$LISTEVALMODEL.fontslist.txt
IMGEXT=png

mkdir -p $SCRIPTPATH/reports
for PREFIX in $LISTEVALMODEL  ; do
    LISTEVAL=$SCRIPTPATH/data/$PREFIX/list.eval
    REPORTSPATH=$SCRIPTPATH/reports/$PREFIX-eval-${OLDMODEL}
    rm -rf $REPORTSPATH
    mkdir $REPORTSPATH
    echo -e  "-----------------------------------------------------------------------------"  $PREFIX 
    while IFS= read -r FONTNAME
    do
        echo "$SCRIPTPATH" > $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
		echo -e " ********************Gujarati ***** $PREFIX ***** ${FONTNAME// /_} ********************"
        while IFS= read -r LSTMFNAME
        do
            if [[ $LSTMFNAME == *${FONTNAME// /_}* ]]; then
                  echo "${LSTMFNAME%.*}.$IMGEXT" >> $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
                  OMP_THREAD_LIMIT=1 tesseract "${LSTMFNAME%.*}.$IMGEXT"  "${LSTMFNAME%.*}-"${OLDMODEL} --psm 7 --oem 1  -l ${OLDMODEL} --tessdata-dir $SCRIPTPATH/data  -c page_separator=''   1>/dev/null 2>&1
                  #### cat "${LSTMFNAME%.*}".gt.txt   >>  "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"
				  for f in ${LSTMFNAME%.*}.gt.txt; do cat "${f}"; echo; done >>  $REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt
                  cat "${LSTMFNAME%.*}"-${OLDMODEL}.txt   >>  "$REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"
            fi
        done < "$LISTEVAL"
         accuracy "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  "$REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"  > "$REPORTSPATH/report_${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"
        ## java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  -ocr "$REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"   -e UTF-8   -o "$REPORTSPATH/report_${OLDMODEL}-$PREFIX-${FONTNAME// /_}.html"  1>/dev/null 2>&1
        head -26 "$REPORTSPATH/report_${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"
        cat "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  >> $REPORTSPATH/gt-$PREFIX-ALL.txt 
        cat "$REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-${FONTNAME// /_}.txt"  >> $REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-ALL.txt 
        echo -e  "-----------------------------------------------------------------------------"  
        echo "Finished $FONTNAME"
        done < "$FONTLIST"
        accuracy  $REPORTSPATH/gt-$PREFIX-ALL.txt   $REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-ALL.txt  > "$REPORTSPATH/report-accuracy-${OLDMODEL}-$PREFIX-ALL.txt"
        wordacc  $REPORTSPATH/gt-$PREFIX-ALL.txt   $REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-ALL.txt  > "$REPORTSPATH/report-wordacc-${OLDMODEL}-$PREFIX-ALL.txt"
        java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt $REPORTSPATH/gt-$PREFIX-ALL.txt  -ocr $REPORTSPATH/ocr-${OLDMODEL}-$PREFIX-ALL.txt  -e UTF-8   -o "$REPORTSPATH/report-accuracy-${OLDMODEL}-$PREFIX-ALL.html"      1>/dev/null 2>&1
        echo -e  "-----------------------------------------------------------------------------" 
echo "Finished $PREFIX"
done 

egrep 'Gujarati|Accuracy$|Digits|Punctuation|Letters|Devanagari' reports/$LISTEVALMODEL-eval-${OLDMODEL}.txt > reports/$LISTEVALMODEL-eval-${OLDMODEL}-summary.txt
