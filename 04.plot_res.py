import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib.patches as patches
import seaborn as sns

OUTFILE=f'/../aggRSqaure/aggRSqaure_TWB_TOPMed.png'

# Load data from a CSV file
ADSP_PATH=f"/../aggRSqaure/TWB_snv.merged"
data1 = pd.read_table(ADSP_PATH,sep = "\t")
TOPMed_PATH=f"/../aggRSqaure/TOPMed.merged"
data2 = pd.read_table(TOPMed_PATH,sep = "\t")

cmap = ["#2E75B6", "#C00000"]
print("generating plot")
fig, ax = plt.subplots(1, 1, figsize=(12, 10))

# Extract columns of interest
x1  = ["(0.000000,0.010000]", "(0.010000,0.050000]", "(0.050000,0.500000]"] 
x = data1.index # label position
x = []
for i,theBin in enumerate(x1):
    if theBin in data1['#Bin.Aggregated.by.MAF'].to_list():
        x.append(i+1)
x = np.array(x)
y11 = data1['R2']
y12 = data1["#Variants"]
y21 = data2['R2']
y22 = data2["#Variants"]

ax2 = ax.twinx()
# Create a line plot in the first subplot
ax.plot(x, y11, color=cmap[0], label = "TWB_SNV_SV")
ax2.bar(x, y12, width = 0.8/3, color=cmap[0], label = "TWB_SNV_SV", edgecolor='black', alpha = 0.3)
ax.plot(x, y21, color=cmap[1], label = "TOPMed")
ax2.bar(x + 0.8/3, y22, width = 0.8/3, color=cmap[1], label = "TOPMed", edgecolor='black', alpha = 0.3)


ax.set_xlabel('MAF', fontsize = 24)
ax.set_ylabel('aggregated r2', fontsize = 24)
ax2.set_ylabel('No. Variants ($10^6$)', fontsize = 24)
my_xtick_labels = [f"({round(float(s.split(',')[0].strip('()[]')), 6)}, {round(float(s.split(',')[1].strip('()[]')), 6)}]" for s in x1 ]

ax.set_xticks([1,2,3])
ax.set_xticklabels(my_xtick_labels, rotation = 45, ha = "right", fontsize = 18)
ax.set_yticks([i/10 for i in range(0, 11, 2)])
ax.set_yticklabels([i/10 for i in range(0, 11, 2)], fontsize = 18)

ax.set_xlim(0,4)
ax.set_ylim(0,1)

ax2ticks = [i/10*1e6 for i in range(0, 10, 2)]
ax2.set_yticks(ax2ticks)
ax2.set_yticklabels([i/1e6 for i in ax2ticks], fontsize = 18)

ax.legend(fontsize=14, bbox_to_anchor = (1.3,1))

dpi = 300
fig.savefig(OUTFILE, bbox_inches = 'tight', dpi = dpi)

print(f"file save at : {OUTFILE}")

