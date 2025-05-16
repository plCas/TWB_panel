#!/bin/bash

CHR=$1

THREADS=10

PANEL=/../chr$CHR.msav
TEST_VCF=/../array_n96/chr$CHR.phased.vcf.gz
OUT=/../array_n96_imputed

mkdir -p $OUT

# Run imputation
/data6/poliang/tools/Minimac4/build/minimac4 \
  --threads $THREADS \
  --format GT \
  --all-typed-sites \
  --output $OUT/chr$CHR.dose.vcf.gz \
  --empirical-output $OUT/chr$CHR.empiricalDose.vcf.gz \
  --temp-prefix $OUT \
  $PANEL \
  $TEST_VCF

