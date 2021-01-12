#-----------------------------------------------------------------------------------------------
# Coaker Lab - Plant Pathology Department UC Davis
# Author: Danielle M. Stevens
# Last Updated: 07/06/2020
# Script Purpose: 
# Inputs: 
# Outputs: 
#-----------------------------------------------------------------------------------------------


######################################################################
# library packages need to load
######################################################################

#install.packages(devtools)
#devtools::install_github("dwinter/pafr")
library(pafr, quietly=TRUE)
library(ggpubr)


######################################################################
# import files to plot
######################################################################


whole_genome_alignment <- pafr::read_paf(file_name = file.choose())


######################################################################
# import files to plot
######################################################################



pdf(file = "Whole_genome_dot_plot.pdf", width = 3, height = 3)

pafr::dotplot(whole_genome_alignment, order_by = 'size', 
                    alignment_colour="blue", line_size = 0.5, dashes = F,
                    ylab = "CASJ002", xlab = paste0("CASJ002", "\u0394", "chpE-ppaC", sep = "")) +
  theme_bw() + 
  theme(axis.text.x = element_text(size = 12, color = "black", family = "Arial"), 
        axis.text.y = element_text(size = 12, color = "black", family = "Arial"),
        axis.title.x = element_text(size = 14, color = "black", family = "Arial", vjust = -1),
        axis.title.y = element_text(size = 14, color = "black", family = "Arial", vjust = 1),
        plot.margin = unit(c(1,1,1,1),"cm"))


dev.off()


pafr::plot_synteny(whole_genome_alignment, q_chrom="DMS092", t_chrom="CASJ002", centre=T)


######################################################################
# import files to plot
######################################################################


#test_alignment2 <- subset(test_alignment, test_alignment$qlen > 1000)
#adjust order before plotting
#ref_order <- list(c("NODE_1_length_3089142_cov_12.251788"), c("MDHC01000001.1"))
#order_by = "provided

p1 <- pafr::dotplot(region_alignment, alignment_colour="blue", order_by = 'qstart',
                    xlab = "5'Flank through 3'Flank of chpE-ppaC", 
                    ylab = "NODE_34_DMS092") +
  theme_bw() + 
  theme(axis.text.x = element_text(size = 12, angle = 90), axis.text.y = element_text(size = 12), 
        plot.margin =  unit(c(0.1, 0.1, 0.1, 0.1), "cm"))




p2 <- plot_coverage(region_alignment, fill = 'qname') + theme_bw() +
  scale_fill_grey(start = 0, end = .9) + ylab("") + 
  theme(legend.position = "none")





#g1 <- ggplotGrob(p1)
#g2 <- ggplotGrob(p2)
#g3 <- ggplotGrob(p3)
#g4 <- ggplotGrob(p4)

#lay = rbind(c(1,1,1,2,2,2),
#            c(1,1,1,2,2,2),
#            c(1,1,1,2,2,2),
#           c(3,3,3,NA,4,NA))

#grid.arrange(g3,g1,g4,g2, layout_matrix = lay)
#ggpubr::ggarrange(p3,p1,p4,p2, nrow = 2, ncol = 2, respect = T)


######################################################
# Purpose: Visualize fastANI core-genome comparison
# Usage: Rscript <this_script>  <query sequence in fasta format> <subject sequence> <fastANI visualization output>
# Output: <fastANI visualization output filename>.pdf
# Uses genoPlotR package: http://genoplotr.r-forge.r-project.org
######################################################


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
