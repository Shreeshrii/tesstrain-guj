#!/bin/bash
export PYTHONIOENCODING=utf8
ulimit -s 65536  
SCRIPTPATH=`pwd`
LISTEVAL=rtltest/list.eval
for MODEL in  Arabic rtltest ckbnew ckbminus  ; do
        cd $SCRIPTPATH/data
        TRAINEDDATAFILES=$(ls ./$MODEL.traineddata)
		rm -rf /tmp/data/$MODEL-ground-truth
        mkdir  /tmp/data/$MODEL-ground-truth
        for TRAINEDDATA in $TRAINEDDATAFILES  ; do
        		TRAINEDDATAFILE="$(basename -- $TRAINEDDATA)"
				rm ./ALL-$TRAINEDDATAFILE*.txt
        		while IFS= read -r my_file
        		do
                    echo -e "\n ***** " $my_file  ${my_file%.*} "LANG" $TRAINEDDATAFILE   "****"
                    OMP_THREAD_LIMIT=1 time -p tesseract ../${my_file%.*}.png  "/tmp/${my_file%.*}.$TRAINEDDATAFILE" --oem 1 --psm 13 -l ${TRAINEDDATAFILE%.*}  --tessdata-dir ./ --dpi 300 -c preserve_interword_spaces=1 -c page_separator=''
                    # accuracy ../${my_file%.*}.gt.txt  "/tmp/${my_file%.*}.$TRAINEDDATAFILE".txt  > "/tmp/${my_file%.*}.$TRAINEDDATAFILE"-accuracy.txt
                    cat "/tmp/${my_file%.*}.$TRAINEDDATAFILE".txt >> ./ALL-$TRAINEDDATAFILE.txt
                    cat  ../${my_file%.*}.gt.txt  newline.txt >> ./ALL-$TRAINEDDATAFILE-gt.txt
            done  < "$LISTEVAL"
        accuracy ./ALL-$TRAINEDDATAFILE-gt.txt ./ALL-$TRAINEDDATAFILE.txt  > ./report-accuracy-$TRAINEDDATAFILE-list.eval.txt
        wordacc ./ALL-$TRAINEDDATAFILE-gt.txt ./ALL-$TRAINEDDATAFILE.txt  > ./report-wordacc-$TRAINEDDATAFILE-list.eval.txt
        java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt ./ALL-$TRAINEDDATAFILE-gt.txt   -ocr ./ALL-$TRAINEDDATAFILE.txt  -e UTF-8   -o  ./report-ocreval-$TRAINEDDATAFILE-list.eval.html    1>/dev/null 2>&1
        done
echo "DONE"
done
cd ..
