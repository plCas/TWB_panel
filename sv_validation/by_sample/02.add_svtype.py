from cyvcf2 import VCF, Writer
import re
import pandas as pd
import numpy as np
# import argparse
# parser = argparse.ArgumentParser()
# parser.add_argument("input")
# parser.add_argument("output")
# args = parser.parse_args()

def get_sv_info(ref, alt):
    vartype, svsize = "", 0

    if alt[0] != "<":
        if len(ref) > len(alt):
            vartype, svsize= "INS", len(ref)
        elif len(ref) < len(alt):
            vartype, svsize= "DEL", len(alt)
    elif alt[0] == "<":
        match = re.match("<([A-Z]+):SVSIZE=([0-9]+)>", alt)
        vartype = str(match.group(1))
        svsize = int(match.group(2))

    return(vartype, svsize)


def main(input_vcf, output_vcf):
    vcf = VCF(input_vcf)  # Load VCF file

    # Add new INFO fields to header
    vcf.add_info_to_header({'ID': 'SVTYPE', 'Description': 'Inferred structural variant type', 'Type': 'String', 'Number': '1'})
    vcf.add_info_to_header({'ID': 'SVSIZE', 'Description': 'Inferred structural variant size', 'Type': 'Integer', 'Number': '1'}) 
    # Output VCF writer
    writer = Writer(output_vcf, vcf)
    
    for variant in vcf:
        vartype, svsize = get_sv_info(variant.REF, variant.ALT[0])
        if vartype:
            variant.INFO['SVTYPE'] = vartype
        if svsize:
            variant.INFO['SVSIZE'] = svsize
        writer.write_record(variant)

    writer.close()
    vcf.close()

if __name__ == "__main__":

    input_vcf  = "/../by_sample/vcfs/sv/all_sv.vcf.gz"
    output_vcf = "/../by_sample/vcfs/sv/all_sv.addsvtype.vcf.gz"

    main(input_vcf, output_vcf)
