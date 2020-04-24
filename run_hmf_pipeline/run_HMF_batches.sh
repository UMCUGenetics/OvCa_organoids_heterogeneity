#! /bin/bash
#USING GUIX HMF PIPELINE https://github.com/UMCUGenetics/guix-additions/blob/master/umcu/packages/hmf.scm
guixr load-profile ~/jvalleinclan/bin/hmf-pipeline
pipeline.pl settings.config

