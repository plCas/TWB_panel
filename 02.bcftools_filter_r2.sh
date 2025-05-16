#!/bin/bash
# Since the TOPMed imputed results were filtered using an imputation quality threshold of > 0.1, we applied the same threshold (> 0.1) to the TWB panel imputed results.

CHR=$1

VCF=/../array_n96_imputed/chr$CHR.dose.vcf.gz
OUT=/../array_n96_imputed/chr$CHR.dose.r2.vcf.gz

#bcftools index -t $VCF
bcftools view -i 'R2 > 0.1' $VCF -Oz -o $OUT
bcftools index -t $OUT
bcftools stats $OUT > ${OUT%%.gz}.stats