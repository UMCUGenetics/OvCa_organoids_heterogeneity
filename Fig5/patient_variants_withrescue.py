#! /usr/bin/python

from __future__ import division
import vcf
import pysam
import argparse

def arguments():
    '''Parses the arguments from the program invocation'''
    
    #Call the argument parse
    parser = argparse.ArgumentParser() 
    
    #Specify arguments
    #parser.add_argument('--example', nargs='?', const=1, type=int, default=1)

    parser.add_argument('-f', "--readfile", type = str,
                        help="Path to VCF file", required=True)
    parser.add_argument('-b', '--bam', nargs='+',
                        help="Bam files (must be in same order that samples appear in the merged VCF!!)",required=True )

    args = parser.parse_args()       
    return args





def bamCheck(bamfile, chrm, position, allele):
    
    bam = pysam.AlignmentFile(bamfile, 'rb') 
    nucList = []
    
    #Careful with pileup and positions, it follows python conventions. Truncate works to report only the column asked.
    for pileupcol in bam.pileup(str(chrm), int(position)-1, int(position), truncate = True):
        for pileupread in pileupcol.pileups:
            if not pileupread.is_del and not pileupread.is_refskip:
                nucList.append(pileupread.alignment.query_sequence[pileupread.query_position])
    depth = len(nucList)   
    count = nucList.count(allele)
    return count, depth


def vcfReader(vcfFilename, bamList):
    
    with open(vcfFilename, 'r') as vcfFile:
        for line in vcfFile:
            if line.startswith('#'):
                print line.rstrip()
                continue
            line = line.rstrip().split('\t')
            chrom, pos, ident, ref, alt, qual, filt, info, form = line[:9]
            samples = line[9:]
            newsamples = []
            for i, s in enumerate(samples):
                gt = s.split(":")[0]
                if gt == "0/1" or gt == "1/1":
                    newsamples.append(s)
                else:
                    count, depth = bamCheck(bamList[i], chrom, pos, alt)
                    if count == 0:
                        newsamples.append(s)
                    else:
                        news = "0/1:%i,%i:%i" % (depth-count,count,depth)
                        newsamples.append(news)
            print '\t'.join(line[:9]+newsamples)
                    
                
                
        

    return vcfDict




###MAIN BODY###

def main():
    
    args=arguments()
    vcfReader(args.readfile, args.bam)   
    
    
###Execute main body

if __name__ == '__main__': main()
    
    
      
