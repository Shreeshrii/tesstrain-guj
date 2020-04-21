#!/bin/bash
# nohup bash  png2lstmf.sh > png2lstmf.log & 
# psm 13 for single line images
export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
MODEL=parth
FONTS=guj.all
GTDIR=gt
fontlist=langdata/$FONTS.fontslist.txt
while IFS= read -r fontname
     do
        prefix=$GTDIR/*${fontname// /_}
        echo ${prefix}
        my_files=$(ls $prefix/*.png)
        for my_file in ${my_files}; do
            echo  "${my_file}"
            python3 $SCRIPTPATH/generate_wordstr_box.py -t "${my_file%.*}".gt.txt  -i  "${my_file}" > "${my_file%.*}".box
            OMP_THREAD_LIMIT=1  tesseract "${my_file}" "${my_file%.*}" --psm 13 --dpi 300  lstm.train    1>/dev/null 2>&1
        done
        cp "${my_file%.*}".png $SCRIPTPATH/test/guj-${fontname// /_}.png
        cp "${my_file%.*}".gt.txt $SCRIPTPATH/test/guj-${fontname// /_}.gt.txt
        echo "Done with ${fontname// /_}"
     done < "$fontlist"
echo "All Done"
