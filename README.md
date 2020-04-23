# tesstrain-guj
Tesseract 5 finetuning for Gujarati

## Making  Synthetic Training Data from Fonts

### Using kraken for quick generation of test data

* txt2png.sh
* png2lsmf.sh
* uses `generate_tif2png_wordstr_box.py`

### Using tesseract and text2image with varying degrees of degradation

* txt2lstmf.sh
* uses `generate_wordstr_box.py`

## Finetune Training

### Plus-Minus training from Gujarati.traineddata

* train.sh (BUILD_TYPE=Plus)

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
