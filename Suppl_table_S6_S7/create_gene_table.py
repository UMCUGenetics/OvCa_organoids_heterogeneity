#! /bin/python

###IMPORT###

import argparse
import vcf as pyvcf

###FUNCTIONS###

def arguments():
    '''Parses the arguments from the program invocation'''
    
    #Call the argument parse
    parser = argparse.ArgumentParser() 
    
    #Specify arguments
    #parser.add_argument('--example', nargs='?', const=1, type=int, default=1)
       
    
    parser.add_argument('--snv', help='Runs for SNVs', action = 'store_true')
    parser.add_argument('--cnv', help='Runs for CNVs', action = 'store_true')
    parser.add_argument("-f", "--filename", type = str, required = True)
    args = parser.parse_args()       
    return args




###MAIN BODY###

def main():
    
    args=arguments()
    mutfile = args.filename
    sample = mutfile.split('.geneList')[0]
    location, t = sample.split('_')
    if t != 'organoid':
        quit()
    patient = location.split('.')[0]
    if "HGS-1-R" in patient:
        patient = "HGS-1"
    
    if args.snv:
        with open(mutfile, 'r') as vcf:
            #print '\t'.join(['sample','gene', 'chrom','pos', 'id', 'ref', 'alt', 'type_mut', 'gencode', 'protcode', 'refreads', 'altreads'])
            for line in vcf:
                if line.startswith("#"):
                    continue
                chrom, pos, iden, ref, alt, qual, filt, info, fmt, gt = line.rstrip().split('\t')
                protcode = '.'
                for i in info.split(';'):
                    if  i.split('=')[0] == 'AA':
                        protcode = i.split('=')[1]
                    elif i.split('=')[0] == 'ANN':
                        fulla = i.split('=')[1]
                        for a in fulla.split(','):
                            mut = a.split('|')[1]
                            gene=a.split('|')[3]
                            gencode = a.split('|')[9]
                            if mut != "sequence_feature" and mut != "intron_variant":
                                if protcode == ".":
                                    protcode = a.split('|')[10]
                            break

                if mut == "sequence_feature" or mut == "intron_variant":
                            continue
                
                refreads = gt.split(':')[1].split(',')[0]
                altreads = gt.split(':')[1].split(',')[1]

                print '\t'.join([location, gene, chrom, pos, iden, ref, alt, mut, gencode, protcode, refreads, altreads])
            
            
    
    
    
    elif args.cnv:    
        ploidytable = 'ploidy_table.txt'
        with open(ploidytable, 'r') as ploidies:
            for line in ploidies:
                s, p = line.rstrip().split('\t')
                if s == sample:
                    ploidy = p
                    break
        d = {}
        with open(mutfile, 'r') as cnv: 
            for line in cnv:
                gene, cn = line.rstrip().split('\t')
                d[gene]={'cn':cn}
        for gene, dic in d.items():
            print '\t'.join([location, gene, dic['cn']])
        print '\t'.join([location, "PLOIDY", p])
            
            
        
    
        
   
###Execute main body

if __name__ == '__main__': 
    main()
