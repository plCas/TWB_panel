#!/bin/bash

WGS=($(sed '1d' /data6/SV_validate/WGS_n100/array_data/WGS_array_ID.txt | awk '{print $1}'))
ARRAY=($(sed '1d' /data6/SV_validate/WGS_n100/array_data/WGS_array_ID.txt | awk '{print $2}'))

NUM=${#WGS[@]}

OUT=/../by_sample/bed_files/wgs
mkdir -p $OUT

for ((i = 0; i < $NUM; i++));do
        VCF_WGS=/data6/SV_validate/WGS_n100/SV/vcf/${WGS[$i]}.oqfe.sv.vcf.gz
        echo $VCF_WGS

        bcftools query -e "SVTYPE == 'BND'" -f "%CHROM\t%POS\t%END\t%SVTYPE[\t%GT]" $VCF_WGS > $OUT/${ARRAY[$i]}_${ARRAY[$i]}.bed
done
