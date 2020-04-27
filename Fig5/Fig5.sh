#! /bin/sh

####################################SNV#######################################

###1. MERGE ORG LOCATIONS
#Example merge command
/gnu/store/1hykmyl04mhvrwd5qrz88ymamj7nhc1p-icedtea-3.7.0/bin/java -Xmx16G -jar /gnu/store/gixvx35bphaar1mi58p8nky48hz2hvnq-gatk-3.8.1-aa8764d6c/share/java/gatk/GenomeAnalysisTK.jar -T CombineVariants -R /hpc/cog_bioinf/GENOMES/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta -o LGS-3_allorganoids_somatic_merged.vcf --variant /hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/somatic_snv/LGS-3.1_organoid_somatic_post_processed.vcf --variant /hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/somatic_snv/LGS-3.2_organoid_somatic_post_processed.vcf

###2. FILTER
#Only PASS calls
for VCF in *_merged.vcf
#for VCF in {MC-H.1.3",HGS-22",HGS-23}*.merged.vcf
do
        grep ^# $VCF > ${VCF/.vcf/.filtered.vcf}
        grep -v ^# $VCF | awk '$7 == "PASS"' >> ${VCF/.vcf/.filtered.vcf}
done



###3. RESCUE VARIANTS IN BAM FILE

BAMDIR=/hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/bams/bams_all

for VCF in *_merged.filtered.vcf
do
        SLIST=`grep "^#C" $VCF | cut -f10-`
        blocks=()
        for S in $SLIST
        do
        B=${BAMDIR}/${S}.bam
        blocks+=("$B")
        done
        /hpc/local/CentOS7/common/lang/python/2.7.10/bin/python patient_variants_withrescue.py -f $VCF -b ${blocks[@]} > ${VCF/.vcf/.rescued.vcf}
done


###4. CONVERT TO TABLES
python convert_to_table.py

###5. PLOT
for F in *.rescued.table.csv
do
        Rscript venn_from_matrix_SNV.R $F
done


########AMP AND DEL###########

####CSV FILES FROM copyNumber gene cnv files.
#0 = no cnv
#1 = deletion
#2 = amplification
#Using Priestley et al. criteria
###One example given
#I did not do the calculation, can't access it

for F in *.csv
do
        Rscript venn_from_matrix_AMP.R $F
        Rscript venn_from_matrix_DEL.R $F
done
