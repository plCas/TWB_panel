#!/bin/bash

R2_Threshold=$1 # 0, 0.2, 0.5, 0.8

VCF=/../by_sample/vcfs/sv/all_sv.addsvtype.vcf.gz
OUT=/../by_sample/bed_files/imp/R2_$R2_Threshold
mkdir -p $OUT

ARRAY=($(sed '1d' /data6/SV_validate/WGS_n100/array_data/WGS_array_ID.txt | awk '{print $2}'))
NUM=${#ARRAY[@]}

for ((i = 0; i < $NUM; i++));do
        sample_name_imp=${ARRAY[$i]}_${ARRAY[$i]}
        echo "$i $sample_name_imp"
        bcftools view -i "R2 > $R2_Threshold" -s $sample_name_imp $VCF \
                    | bcftools view -i "AC > 0" \
                    | bcftools query -f "%CHROM\t%POS\t%SVTYPE\t%SVSIZE[\t%GT]\n" \
                    | awk -F'\t' '{
                pos = $2;
                svtype = $3;
                svsize = $4;
                if (svtype == "INS") {
                    end = pos;
                } else {
                    end = pos + svsize;
                }
                print $1 "\t" pos "\t" end "\t" $3 "\t" $4 "\t" $5;
            }'  > $OUT/$sample_name_imp.bed

done
