#!/bin/bash
MODEL=guj
BUILDTYPE=Minus
lstmtraining \
 	--stop_training \
 	--continue_from data/${MODEL}/checkpoints/${MODEL}${BUILDTYPE}_checkpoint \
    --traineddata data/${MODEL}/${MODEL}.traineddata \
 	--model_output data/${MODEL}${BUILDTYPE}.traineddata
	
lstmtraining \
 	--stop_training \
	--convert_to_int \
 	--continue_from data/${MODEL}/checkpoints/${MODEL}${BUILDTYPE}_checkpoint \
    --traineddata data/${MODEL}/${MODEL}.traineddata \
 	--model_output data/${MODEL}${BUILDTYPE}_fast.traineddata

## make  traineddata  MODEL_NAME=$MODEL  

