#!/bin/bash
bash maketessdata.sh
my_files=$(ls test/scan*{*.jpg,*.tif,*.png,*.gif})
rm test/ALL* test/*Gujarati.txt test/*gujLayer.txt
for lang in Gujarati_fast  gujMinus_fast ; do
    for my_file in ${my_files}; do
            echo -e "\n ***** "  ${my_file%.*} "LANG" $lang   "****"
            OMP_THREAD_LIMIT=1 time -p tesseract $my_file  "${my_file%.*}-$lang" --oem 1 --psm 6 -l "$lang" --tessdata-dir data --dpi 300 -c preserve_interword_spaces=1 -c page_separator='' -c paragraph_text_based=false
            cat "${my_file%.*}-$lang".txt >> test/ALL-$lang.txt
            cat "${my_file%.*}".gt.txt >>  test/ALL-$lang-gt.txt
    done
accuracy  test/ALL-$lang-gt.txt  test/ALL-$lang.txt  >  test/ALL-$lang-accuracy.txt
wordacc  test/ALL-$lang-gt.txt  test/ALL-$lang.txt  >  test/ALL-$lang-wordacc.txt
done
echo "DONE with gt"
