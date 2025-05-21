from cyvcf2 import VCF
import re
import pandas as pd
import numpy as np
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("input")
parser.add_argument("output")
args = parser.parse_args()

def get_sv_info(ref, alt):
    vartype, svsize = "", 0

    if alt[0] != "<":
        if len(ref) > len(alt):
            vartype, svsize= "INS", 0 # len(ref)
        elif len(ref) < len(alt):
            vartype, svsize= "DEL", len(alt)
    elif alt[0] == "<":
        match = re.match("<([A-Z]+):SVSIZE=([0-9]+)>", alt)
        vartype = str(match.group(1))
        svsize = int(match.group(2))

    return(vartype, svsize)    

def main(input_vcf, output_vcf):
    vcf = VCF(input_vcf)  # Load VCF file
    with open(output_vcf, 'w') as out:
        # Write header
        header = ['chromosome', 'rs_id', 'R2', 'start', 'end', 'vartype']
        #header.extend(['sample' + str(i+1) for i in range(len(vcf.samples))])
        header.extend(vcf.samples)
        out.write('\t'.join(header) + '\n')

        for variant in vcf:
            chrom = variant.CHROM
            rs_id = variant.ID if variant.ID and variant.ID != '.' else '.'
            R2  = variant.INFO["R2"]
            pos = variant.POS
            ref = variant.REF
            alt = ','.join(variant.ALT)
            vartype, svsize = get_sv_info(ref, alt)
            end = pos + svsize
            #print(rs_id) 
            #print(vartype)
            genotypes = []
            for gt in variant.genotypes:
                g0 = gt[0] if gt[0] >= 0 else '.'
                g1 = gt[1] if gt[1] >= 0 else '.'
                phased = gt[2]  # 1 if phased, 0 if unphased

                sep = '|' if phased else '/'
                genotypes.append(f"{g0}{sep}{g1}")

            row = [chrom, rs_id, str(R2), str(pos), str(end), vartype] + genotypes
            out.write('\t'.join(row) + '\n')


if __name__ == "__main__":

    input_vcf  = args.input # /../by_var/vcfs/all_sv.addsvtype.ac.vcf.gz
    output_vcf = args.output # /../by_var/bed_files/all_sv_imp.bed

    main(input_vcf, output_vcf)
