#! /bin/sh
#Starting from germline calls from HMF pipeline (*.annotated.vcf.gz)

F=${SAMPLE}.annotated.vcf.gz)
gunzip -c $F | grep '^#' > ${F/.vcf.gz/.filtered.vcf}
gunzip -c $F | grep -v '^#' | grep -E "HIGH|MODERATE" | awk '$7 == "PASS"' >> ${F/.vcf.gz/.filtered.vcf}
