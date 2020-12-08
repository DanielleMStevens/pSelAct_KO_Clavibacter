
#######
# Purpose: Visualize fastANI core-genome comparison
# Usage: Rscript <this_script>  <query sequence in fasta format> <subject sequence> <fastANI visualization output>
# Output: <fastANI visualization output filename>.pdf
# Uses genoPlotR package: http://genoplotr.r-forge.r-project.org

# make sure to set path to the same place where the figure 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))



#Parse command line arguments
query_fasta=commandArgs(TRUE)[1]
subject_fasta=commandArgs(TRUE)[2]
fastANI_visual_file=commandArgs(TRUE)[3]

install.packages('genoPlotR', dependencies = T)
#library(devtools)
#install_github("sdray/ade4")

library(genoPlotR)
#library(ade4)

#Read fastANI output
comparison_analyse <- genoPlotR::read_comparison_from_blast(file = "./ANI_comparison.out.visual")

#Read sequences into genoPlotR objects
Query <- try(genoPlotR::read_dna_seg_from_file(file = "./De_novo_DMS092/scaffolds.fasta"))
Ref <- try(genoPlotR::read_dna_seg_from_file(file = "/media/coaker_lab/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta"))

plotTitle = paste("DMS092", "CASJ002", sep=" v/s ")

pdf(paste("DMS092_vs_CASJ002",".pdf",sep=""))

genoPlotR::plot_gene_map(dna_segs=list(Query, Ref), 
                         comparisons=list(comparison), main=plotTitle, scale=FALSE, scale_cex=1, n_scale_ticks=4)

dev.off()
