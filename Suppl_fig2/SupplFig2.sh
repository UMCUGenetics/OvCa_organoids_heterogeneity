#! /bin/sh

###1. COMBINE TUMOR AND ORGANOID SAMPLE
SRC=/hpc/cog_bioinf/cuppen/project_data/Jose_ovarian/heterogeneity/somatic_snv
GATK=/gnu/store/gixvx35bphaar1mi58p8nky48hz2hvnq-gatk-3.8.1-aa8764d6c/share/java/gatk/GenomeAnalysisTK.jar
JAVA=/gnu/store/1hykmyl04mhvrwd5qrz88ymamj7nhc1p-icedtea-3.7.0/bin/java
REF=/hpc/cog_bioinf/GENOMES/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta

SAMPLE=HGS-1
S1=${SAMPLE}_tumor
S2=${SAMPLE}_organoid
VCF1=${SRC}/${S1}_somatic_post_processed.vcf
VCF2=${SRC}/${S2}_somatic_post_processed.vcf
echo "$JAVA -Xmx16G -jar $GATK -T CombineVariants -R $REF --variant $VCF1 --variant $VCF2 -o ${S1}_${S2}.somatic.merged.vcf" | \
    qsub -cwd -N ${S1}_${S2} -l h_vmem=22G -l h_rt=3:0:0

    
###2. USE ONLY PASS CALLS
VCF=${S1}_${S2}.somatic.merged.vcf
grep ^# $VCF > ${VCF/.vcf/.filtered.vcf}
grep -v ^# $VCF | awk '$7 == "PASS"' >> ${VCF/.vcf/.filtered.vcf}


###3. CHECK IN BAM FILE IF VARIANT PRESENT
BAMDIR=$DIRECTORY_WITH_BAMFILES
VCF=${S1}_${S2}.somatic.merged.filtered.vcf
S1=`grep "^#C" $VCF | cut -f10`
S2=`grep "^#C" $VCF | cut -f11`
B1=${BAMDIR}/${S1}.bam
B2=${BAMDIR}/${S2}.bam
python patient_variants_withrescue.py -f $VCF -b $B1 $B2 > ${VCF/.vcf/.rescued.vcf}


###4. Convert VCFs to tables
python convert_vcfs_2_tables.py


###5. plot
Rscript plot_shared.R

