#! /bin/python

from __future__ import division
import glob
import re



files = glob.glob("*.filtered.rescued.vcf")
for f in files:
    outfilename=f.replace("vcf", "table.csv")
    with open(f, 'r') as infile, open(outfilename, 'w') as outfile:
        samples = []
        counter = 1
        for line in infile:
            line = line.rstrip().split('\t')
            if line[0] == "#CHROM":
                for i in line[9:]:
                    samples.append(i)
                outfile.write("id,%s\n" % (",".join(samples)))
                continue
            elif line[0].startswith('#'):
                continue
            both = line[9:]
            afs = []
            for i in both:
                gt = i.split(':')[0]
                if gt != '0/1' and gt != '1/1':
                    af = 0
                else:
                    try:
                        alt = i.split(':')[1].split(',')[1]
                        dp = i.split(':')[2]                        
                        af = float(alt)/float(dp)
                    except:
                        af = 0
                    if af != 0:
                        af = 1
                afs.append(str(af))
            outfile.write("%i,%s\n" % (counter, ','.join(afs)))
            counter +=1
                
                
