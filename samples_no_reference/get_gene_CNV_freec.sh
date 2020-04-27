#! /bin/sh

##to mimic PURPLE (HMF pipeline) CNV per gene output in the samples with no reference

for F in ../*.freec.cnv
do 
NAME=`echo $F | cut -f2 -d'/'`
python get_gene_from_FREEC.py $F ${NAME/.cnv/.gene.cnv}
done
