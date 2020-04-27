# OvCa_organoids_heterogeneity
Custom code for "Patient-derived ovarian cancer organoids mimic clinical response and exhibit heterogeneous inter- and intrapatient drug responses", De Witte et al . ADD REF! 

### Run HMF pipeline
A GNU packaged version (https://github.com/UMCUGenetics/guix-additions/blob/master/umcu/packages/hmf.scm) of the HMF pipeline (https://github.com/hartwigmedical/pipeline, https://www.nature.com/articles/s41586-019-1689-y), was used for mapping and somatic variant detection. In the directory run_hmf_pipeline/, examples of ini files, config file and command used can be found.

### Samples with no reference
For organoid samples with no matching reference, additional filter steps for SNVs, config file for FREEC are available in directory samples_no_reference.

### Figures and supplementary figures
Additional code for VCF/CNV file parsing and figure generation is available in each directory. For several, I need to be able to go back to work since code is at my work computer, will update asap. 

