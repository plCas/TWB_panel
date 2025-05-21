#!/bin/bash
DIR=/../by_sample/vcfs/sv

OUT=/../by_sample/vcfs/sv
mkdir -p $OUT

VCFs=$(ls -v $DIR |grep '.vcf.gz$')
INVCFs=""
for f in ${VCFs[*]};do INVCFs="$INVCFs $DIR/$f"; done

TMP_DIR=$OUT/chr${CHR}_tmp

bcftools concat --threads 2 $INVCFs \
  | bcftools sort --temp-dir $TMP_DIR -Oz -o $OUT/all_sv.tmp.vcf.gz
rm -rf $TMP_DIR

bcftools +fill-tags $OUT/all_sv.tmp.vcf.gz -- -t AN,AC,AF \
        | bcftools view -Oz -o $OUT/all_sv.vcf.gz

bcftools index --threads 2 -t $OUT/all_sv.vcf.gz
bcftools stats --threads 2 $OUT/all_sv.vcf.gz > $OUT/all_sv.vcf.stats

rm $OUT/all_sv.tmp.vcf.gz
