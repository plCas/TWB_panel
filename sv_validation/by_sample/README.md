# Concordance Rate per Sample

1. Generate SV list and extract SVs from imputation. [00.1.get_var_id_snv_sv.sh](00.1.get_var_id_snv_sv.sh), [00.2.generate_sv_list.R](00.2.generate_sv_list.R) and [00.3.bcftools_filter_sv.sh](00.3.bcftools_filter_sv.sh)

2. Merge all chromosomes together and label SV types. [01.bcftools_concat_sv.sh](01.bcftools_concat_sv.sh) and [02.add_svtype.py](02.add_svtype.py)

3. Generate a BED file per sample for WGS and imputation.  [03.make_WGS_SV_bed.sh](03.make_WGS_SV_bed.sh) and [03.make_sample_bed_imp.sh](03.make_sample_bed_imp.sh)

4. Compare genotypes. [04.compare_gt.sh](04.compare_gt.sh)

5. Summarise results. [05.summarise_res.R](05.summarise_res.R)
