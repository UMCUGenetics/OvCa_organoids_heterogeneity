#! /bin/sh

#For each somatic VCF get only SNVs with High or Moderate effect based on SnpEff

for F in /hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/somatic_snv/*somatic_post_processed.vcf
do
        SAMPLE=`echo $F | rev | cut -f1 -d'/' | rev | cut -f1,2 -d'_'`
        grep '^#' $F | grep -v "PON" > ${SAMPLE}.geneList.SNVs.vcf
        touch ${SAMPLE}.geneList.copynumber.txt
    
        for G in `cat genelist.txt`
        do
            grep "|$G|" $F | grep -E "\|HIGH\||\|MODERATE\|" >> ${SAMPLE}.geneList.SNVs.vcf
            awk -v G=$G '$4 == G' /hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/cnv/gene/${SAMPLE}.*.gene.cnv | cut -f4,5 >> ${SAMPLE}.geneList.copynumber.txt
        done
done


for F in *.geneList.SNVs.vcf; 
do
    python create_gene_table.py --snv -f $F >> table_snv.tsv
    python create_gene_table.py --cnv -f${F/.SNVs.vcf/.copynumber.txt} >> table_cnv.tsv
done
