#######
# Purpose: Visualize fastANI core-genome comparison
# Usage: Rscript <this_script>  <query sequence in fasta format> <subject sequence> <fastANI visualization output>
# Output: <fastANI visualization output filename>.pdf
# Uses genoPlotR package: http://genoplotr.r-forge.r-project.org

#Parse command line arguments
query_fasta=file.choose()
  #c('~/pSelAct_KO_Clavibacter/De_novo_DMS092/contigs.fasta')
subject_fasta=file.choose()
#('/media/danimstevens/Second_storage/Genomes/DNA_contigs/CM_CASJ002.fasta')
fastANI_visual_file=file.choose()

library(genoPlotR)

#Read fastANI output
comparison <- try(genoPlotR::read_comparison_from_blast(fastANI_visual_file))

#Read sequences into genoPlotR objects
Query <- try(genoPlotR::read_dna_seg_from_file(query_fasta))
Ref <- try(genoPlotR::read_dna_seg_from_file(subject_fasta))

plotTitle = paste(query_fasta, subject_fasta, sep=" v/s ")

pdf( paste(fastANI_visual_file,".pdf",sep="") )

plot_gene_map(dna_segs=list(Query, Ref), comparisons=list(comparison), main=plotTitle, scale=FALSE, scale_cex=1, n_scale_ticks=4)

dev.off()

##########
#############
#install.packages(devtools)
devtools::install_github("dwinter/pafr")
library(pafr, quietly=TRUE)

test_alignment <- pafr::read_paf(file_name = file.choose())

test_alignment2 <- subset(test_alignment, test_alignment$qlen > 1000)
#adjust order before plotting
ref_order <- list(c("NODE_1_length_3089142_cov_12.251788"), c("MDHC01000001.1"))
#order_by = "provided

pafr::dotplot(test_alignment, , ordering = ref_order, alignment_colour="blue") + theme_bw()
pafr::plot_synteny(test_alignment, q_chrom="DMS092", t_chrom="CASJ002", centre=T)
plot_coverage(test_alignment, fill = 'qname')
