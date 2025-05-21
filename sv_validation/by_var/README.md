# Concordance Rate by MAF

1. Generate imputed SVs VCF file (AC > 0). [01.bcftools_filter_imp.sh](01.bcftools_filter_imp.sh)

2. Generate a BED file from the VCF file for all imputed samples. [02.make_imp_SV_bed.py](02.make_imp_SV_bed.py)

3. Generate BED file of WGS (all WGS samples). <br>
  a. Intersect imputation and WGS for each sample. [03.intersect_imp_wgs.sh](03.intersect_imp_wgs.sh) <br>
  b. Merge all samples. [04.make_all_smaple_bed.wgs.R](04.make_all_smaple_bed.wgs.R) <br>

4. Generate BED file including consensus SVs between imputation and WGS. [05.make_consensus_beds.R](05.make_consensus_beds.R)

5. Compare genotypes. [06.Run_compare_gt.sh](06.Run_compare_gt.sh) and [compare_gt.py](compare_gt.py)

6. Visualize results. [07.plot_res.R](07.plot_res.R)
