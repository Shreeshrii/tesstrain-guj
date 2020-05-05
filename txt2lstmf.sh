#!/bin/bash
# SINGLE line images using text2image - split training text 
# nohup bash txt2lstmf.sh gujnew > txt2lstmf-gujnew.log &
lang=$1
unicodefontdir=/home/ubuntu/.fonts
mkdir -p gt ~/tmp
traininginput=langdata/$lang.training_text
fontlist=langdata/guj.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
numlines=1
numfiles=$(( perfontcount / numlines))
# files created by script during processing
trainingtext=/tmp/$lang-train.txt
fonttext=/tmp/$lang-file-train.txt
linetext=/tmp/$lang-line-train.txt
shuf  ${traininginput} > ${trainingtext} 
 
 while IFS= read -r fontname
     do
        prefix=gt/$lang-"${fontname// /_}"
        rm -rf ${prefix}
        mkdir  ${prefix} 
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
        for cnt in $(seq 1 $numfiles) ; do
            head -$numlines ${fonttext} > ${linetext}
             sed -i  "1,$numlines  d"  ${fonttext}
             last=${cnt: -1}
             case "$last" in
                  1)    let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=false  --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  2)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=150  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  3)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=400  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp --degrade_image=true  --distort_image     --invert=false    --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  4)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=400  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp  --degrade_image=true  --distort_image     --invert=false    --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  5)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  6)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=200  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true    --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  7)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=250  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true  --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  8)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=250  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp    --degrade_image=true    --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  9)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --distort_image     --invert=false  --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  0)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words  --ptsize=12  --resolution=300  --xsize=2600  --ysize=350  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text=$linetext  --outputbase=$prefix/${fontname// /_}.$cnt.exp$exp  --degrade_image=true   --distort_image     --invert=false    --fontconfig_tmpdir=/home/ubuntu/tmp
                       ;;
                  *) echo "Signal number $last is not processed"
                     ;;
             esac
             # generate ground truth from text2image generated box files - takes care of unrendered words
             python3 generate_gt_from_box.py -b $prefix/${fontname// /_}.$cnt.exp$exp.box -t $prefix/${fontname// /_}.$cnt.exp$exp.gt.txt 
             mv $prefix/${fontname// /_}.$cnt.exp$exp.box $prefix/${fontname// /_}.$cnt.exp$exp.text2image.box
             # generate wordstrbox files using trimmed images and ground truth files
             python3 generate_tif2png_wordstr_box.py -i $prefix/${fontname// /_}.$cnt.exp$exp.tif -t $prefix/${fontname// /_}.$cnt.exp$exp.gt.txt > $prefix/${fontname// /_}.$cnt.exp$exp.box
             rm $prefix/${fontname// /_}.$cnt.exp$exp.tif
             # generate lstmf files for single line images - use --psm 13
             OMP_THREAD_LIMIT=1 tesseract $prefix/${fontname// /_}.$cnt.exp$exp.png $prefix/${fontname// /_}.$cnt.exp$exp  --psm 13 --dpi 300 lstm.train
         done
        echo "Done with ${fontname// /_}"
     done < "$fontlist"
echo "All lstmf files Done"

bash delbadbox.sh
bash delbadfiles.sh
bash delzerosize.sh
bash delzerosizefiles.sh
echo "Move gterror lstmf files Done"