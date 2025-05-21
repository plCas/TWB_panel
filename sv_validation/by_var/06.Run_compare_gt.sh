#!/bin/bash

FILE_WGS=/../by_var/bed_files/wgs_all_consensus.bed
FILE_IMP=/../by_var/bed_files/imp_all_consensus.bed

NCORE=10
CHUNK_LENGTH=1000
MODE=1 # 0 : genotype = 0, 1, 2; 1 : genotyp = 0, 1
OUTPREFIX=/../by_var/res/accuracy_mode$MODE.txt

SCRIPT=/../by_var/scripts/compare_gt.py

python3 $SCRIPT $FILE_WGS $FILE_IMP $OUTPREFIX $NCORE $CHUNK_LENGTH $MODE
