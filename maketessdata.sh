#!/bin/bash
MODEL=guj
BUILDTYPE=Layer
lstmtraining \
 	--stop_training \
 	--continue_from data/${MODEL}/checkpoints/${MODEL}${BUILDTYPE}_checkpoint \
    --traineddata data/${MODEL}/${MODEL}.traineddata \
 	--model_output data/${MODEL}${BUILDTYPE}.traineddata
	
make  traineddata  MODEL_NAME=$MODEL  

