# Imputation Accuracy Calculation

1. [01.bcftools_filter_r2.sh](01.bcftools_filter_r2.sh)Filter R2, since TOPMed imputation filter R2 > 0.1 in the 96 validation dataset. <br>

2. [02.aggRsqure.sh](02.aggRsqure.sh) : Calculate aggregated R2 for each MAF bin. (used bins are in [bin_used.txt](bin_used.txt)) <br>

3. Can plot results by [03.plot_res.py](03.plot_res.py) <br>
