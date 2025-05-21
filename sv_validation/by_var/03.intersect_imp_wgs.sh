#!/bin/bash
# intersect SVs between imputation and WGS for each sample


OUT=/../by_var/bed_files/wgs
mkdir -p $OUT

# Intersect the BED file stratefied by SV types.
function intersect_bedfiles(){
    local svtype="$1"
    local imp_all_bed=$2
    local wgs_all_bed=$3

    if [[ "$svtype" == "INS" ]]; then
        # INS region +- 500bp tolerance for mapping $2=$2-500;$3=$3+500
	    # After mapping make the position back $2=$2+500;$3=$3-500
        bedtools intersect \
            -a <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$6}' $imp_all_bed \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -b <(awk '{$2=$2-500;$3=$3+500; print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                    | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                    | awk '{if($6 < 10000000){print $0}}' \
                    | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa -wb \
            | awk '{
                    $10 = gensub("/", "|", "g", $10);  # Replace "/" with "|" in column 10
                    key = $1"\t"$2"\t"$3"\t"$4;               # Create a key based on columns 1–4
                    if (!seen[key]) {                         # Initialize array for new key
                        rows[key] = $0;
                        seen[key] = ($5 == $10);
                    } else if ($5 == $10 && !seen[key]) {     # If $5 == $10, overwrite with the matching row
                        rows[key] = $0;
                        seen[key] = 1;
                    }
                }
                END {
                    for (key in rows) {                       # Output all stored rows
                        print rows[key];
                    }
                }' \
            | awk '{$2=$2+500;$3=$3-500; print $1"\t"$2"\t"$3"\t"$4"\t"$10}' | sort |uniq
    else
        bedtools intersect \
            -a <(awk -v svtype=$svtype '{if($4 == svtype){print $1"\t"$2"\t"$3"\t"$4"\t"$6}}' $imp_all_bed )  \
            -b <(awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$3-$2}' $wgs_all_bed \
                        | awk '{if(!($1 == "chrX" || $1 == "chrY" || $1 == "chrM")){print $0}}' \
                        | awk '{if($6 < 10000000){print $0}}' \
                        | awk -v svtype=$svtype '{if($4 == svtype){print $0}}' )  \
            -f 0.5 -r -wa -wb \
            | awk '{
                    $10 = gensub("/", "|", "g", $10);  # Replace "/" with "|" in column 10
                    key = $1"\t"$2"\t"$3"\t"$4;               # Create a key based on columns 1–4
                    if (!seen[key]) {                         # Initialize array for new key
                        rows[key] = $0;
                        seen[key] = ($5 == $10);
                    } else if ($5 == $10 && !seen[key]) {     # If $5 == $10, overwrite with the matching row
                        rows[key] = $0;
                        seen[key] = 1;
                    }
                }
                END {
                    for (key in rows) {                       # Output all stored rows
                        print rows[key];
                    }
                }' \
            |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$10}' | sort |uniq 
        fi
}

ARRAY=($(sed '1d' /data6/SV_validate/WGS_n100/array_data/WGS_array_ID.txt | awk '{print $2}'))

NUM=${#ARRAY[@]}

mask="282PM18493375C04_08R_282PM18493375C04_08R 164PMfd18485985E04_TCVG_0005_164PMfd18485985E04_TCVG_0005 399PMfd20274696E05_09Y_399PMfd20274696E05_09Y 518PMfs11563238F05_TCVG_0209_518PMfs11563238F05_TCVG_0209"

for ((i = 0; i < $NUM; i++));do
    output_sample_name=${ARRAY[$i]}_${ARRAY[$i]}
    if [[ " $mask " =~ " $output_sample_name " ]];then
        echo "$i $output_sample_name masked"
    else
        echo "$i $output_sample_name"
	imp_all_bed=/../by_sample/bed_files/imp/R2_0/$output_sample_name.bed
        wgs_all_bed=/../by_sample/bed_files/wgs/$output_sample_name.bed
        intersect_bedfiles "INS" "$imp_all_bed" "$wgs_all_bed" >  $OUT/$output_sample_name.bed
        intersect_bedfiles "DEL" "$imp_all_bed" "$wgs_all_bed" >> $OUT/$output_sample_name.bed
    fi
done
