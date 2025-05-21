#!/bin/bash

R2_threshold=$1 # 0, 0.2, 0.5, 0.8


DIR=/../by_sample/bed_files
OUT=/../by_sample/res
mkdir $OUT

# A function to intersect SVs using bedtools
function compare_gt(){
    local svtype="$1"
    local output_sample_name=$2
    local imp_all_bed=$3
    local wgs_all_bed=$4

    if [[ "$svtype" == "INS" ]]; then
        # INS region +- 500bp tolerance for mapping
        TP=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa \
            |sort|uniq |wc -l)
        FP=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
        FN=$(bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                | awk '{if($6 < 10000000){print $0}}' \
                | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
    else
        TP=$(bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa \
            |sort|uniq |wc -l)
        FP=$(bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
        FN=$(bedtools intersect \
            -a <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                | awk '{if($6 < 10000000){print $0}}' \
                | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk -v svtype=$svtype '{if($4 == svtype){print $0}}' $imp_all_bed )  \
            -f 0.5 -r -v \
            |sort|uniq |wc -l)
    fi

    echo -e "$svtype\t$output_sample_name\t$TP\t$FP\t$FN" 
}


ARRAY=($(awk '{print $1}' /data6/poliang/imputation/TWB_panel_SNV_SV_02192025/WGS_validation/prepare_validation_data/vcfs/TOPMed/TOPMed.sample.list))

NUM=${#ARRAY[@]}

echo -e "SVTYPE\tsample_id\tTP\tFP\tFN" > $OUT/R2_${R2_threshold}.txt

for ((i = 0; i < $NUM; i++));do
    	output_sample_name=${ARRAY[$i]}
	echo "$i $output_sample_name"
	    imp_all_bed=/../by_sample/bed_files/imp/R2_$R2_threshold/$output_sample_name.bed
	wgs_all_bed=/../by_sample/bed_files/wgs/$output_sample_name.bed
	compare_gt "INS" $output_sample_name $imp_all_bed $wgs_all_bed >> $OUT/R2_${R2_threshold}.txt
	compare_gt "DEL" $output_sample_name $imp_all_bed $wgs_all_bed >> $OUT/R2_${R2_threshold}.txt
done
