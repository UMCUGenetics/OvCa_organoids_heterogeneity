from __future__ import division
from sys import argv

hmf_template = "hmf_genes.txt"
hmf_genes = {}
with open(hmf_template, 'r') as infile:
    for l in infile:
        chrm, start, end, gene = l.rstrip().split('\t')
        hmf_genes[gene] = {'chrm':chrm, 'start':start, 'end':end}


cnvs = {}
with open(argv[1], 'r') as freec:
    for l in freec:
        chrm, start, end , cn = l.rstrip().split('\t')[:4]
        cnvs.setdefault(chrm, []).append({'start':start, 'end':end, 'cn':cn})

header=["Chromosome","Start","End","Gene","CopyNumber"]
with open(argv[2], 'w') as out:
    out.write('\t'.join(header)+'\n')
    for gene, d in hmf_genes.items():
        chrm = d['chrm']
        start=d['start']
        end=d['end']
        cnlist=[]
        try:
            for cnvd in cnvs[chrm]:
                if int(cnvd['end']) <= int(start) or int(cnvd['start']) >= int(end):
                    continue
                else:
                    cnlist.append(int(cnvd['cn']))
            if len(cnlist) == 0:
                cn = '2'
            else:
                cn = str(int(round(sum(cnlist)/len(cnlist))))
        except KeyError:
            cn = '2'
        out.write("%s\t%s\t%s\t%s\t%s\n" % (chrm, start, end, gene, cn))
    
            
                
                
