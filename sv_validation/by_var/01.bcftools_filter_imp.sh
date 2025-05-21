#!/bin/bash
# filter imputed SVs

VCF=/../all_sv.addsvtype.vcf.gz
OUT=/../by_var/vcfs
mkdir -p $OUT

bcftools view -i " AC >0 " $VCF -Oz -o $OUT/all_sv.addsvtype.ac.vcf.gz
bcftools index -t $OUT/all_sv.addsvtype.ac.vcf.gz
bcftools stats $OUT/all_sv.addsvtype.ac.vcf.gz > $OUT/all_sv.addsvtype.ac.vcf.stats