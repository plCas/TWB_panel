#!/bin/bash

CHR=$1

VCF=/../ligated/chr$CHR.phased.bcf
OUT=/../var_ids/snv_sv

mkdir -p $OUT

bcftools query -f '%CHROM:%POS:%REF:%ALT' $VCF > $OUT/chr$CHR.var_id.txt