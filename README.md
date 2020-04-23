# tesstrain-guj
Tesseract 5 finetuning for Gujarati

## Software Used

* tesseract-ocr
* tesstrain
* [ISRI Analytic Tools for OCR Evaluation with UTF-8 support](https://github.com/eddieantonio/ocreval) 
* [The ocrevalUAtion tool](https://sites.google.com/site/textdigitisation/ocrevaluation)
* [create_dictdata from pytesstrain](https://github.com/wincentbalin/pytesstrain)
* [ketos linegen from kraken](https://github.com/mittagessen/kraken)

## Making  Synthetic Training Data from Fonts

### Using kraken for quick generation of test data

* txt2png.sh
* png2lsmf.sh
* uses `generate_tif2png_wordstr_box.py`

### Using tesseract and text2image with varying degrees of degradation

* txt2lstmf.sh
* uses `generate_gt_from_box.py`
* uses `generate_wordstr_box.py`

## Finetune Training

### Plus-Minus training from Gujarati.traineddata

* train.sh 

```
make  lists MODEL_NAME=guj RATIO_TRAIN=0.80

nohup make  training  \
MODEL_NAME=guj  \
LANG_TYPE=Indic \
BUILD_TYPE=Plus  \
TESSDATA=data \
GROUND_TRUTH_DIR=gt \
START_MODEL=Gujarati \
RATIO_TRAIN=0.80 \
DEBUG_INTERVAL=-1 \
EPOCHS=20 > train-guj-$BUILDTYPE.log & 
```

```
unicharset_extractor --output_unicharset "data/guj/my.unicharset" --norm_mode 2 "data/guj/all-gt"
merge_unicharsets data/Gujarati/Gujarati.lstm-unicharset data/guj/my.unicharset  "data/guj/unicharset"

Loaded unicharset of size 185 from file data/Gujarati/Gujarati.lstm-unicharset
Loaded unicharset of size 197 from file data/guj/my.unicharset
Wrote unicharset file data/guj/unicharset.

combine_lang_model \
  --input_unicharset data/guj/unicharset \
  --script_dir data \
  --numbers data/guj/guj.numbers \
  --puncs data/guj/guj.punc \
  --words data/guj/guj.wordlist \
  --output_dir data \
  --pass_through_recoder \
  --lang guj

lstmtraining \
  --debug_interval -1 \
  --traineddata data/guj/guj.traineddata \
  --old_traineddata data/Gujarati.traineddata \
  --continue_from data/Gujarati/Gujarati.lstm \
  --model_output data/guj/checkpoints/gujPlus \
  --train_listfile data/guj/list.train \
  --eval_listfile data/guj/list.eval \
  --max_iterations 712720
```

### Replace top layer training from Gujarati.traineddata

* train.sh (BUILD_TYPE=Layer)

## Evaluation

### list.eval (single line images)

* oldmodeleval.sh

### test images (multi page tif/ multi line --psm 6 or  singleline --psm 13

* test.sh 
