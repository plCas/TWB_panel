#!/bin/bash

CHR=$1
VCF=/../chr$CHR.dose.vcf.gz
OUT=/../
mkdir -p $OUT

ID=/../SV_list/chr${CHR}_SV_list.txt

bcftools view --threads 2 --include ID==@$ID $VCF -Oz -o $OUT/chr$CHR.vcf.gz
bcftools index -t $OUT/chr$CHR.vcf.gz
bcftools stats $OUT/chr$CHR.vcf.gz > $OUT/chr$CHR.vcf.stats