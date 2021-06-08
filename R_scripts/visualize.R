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
library(ggplot2)
library(genoPlotR)



######################################################################
# import files to plot
######################################################################


whole_genome_alignment <- pafr::read_paf(file_name = file.choose()) # choose align_contigs_to_reference.paf

#

######################################################################
# import files to plot
######################################################################



pdf(file = "Whole_genome_dot_plot.pdf", width = 2, height = 2)

pafr::dotplot(whole_genome_alignment, order_by = "qstart",
                    alignment_colour="blue", line_size = 0.5, dashes = F,
                    ylab = "CASJ002", xlab = paste0("CASJ002", "\u0394", "chpE-ppaC", sep = "")) +
  theme_classic() + 
  theme(axis.text.x = element_text(size = 10, color = "black", family = "Arial"), 
        axis.text.y = element_text(size = 10, color = "black", family = "Arial"),
        axis.title.x = element_text(size = 12, color = "black", family = "Arial", vjust = -1),
        axis.title.y = element_text(size = 12, color = "black", family = "Arial", vjust = 1),
        panel.border = element_rect(colour = "black", fill = NA, size=  0.5),
        plot.margin = unit(c(0.2,0,0.4,0),"cm"))



dev.off()



######################################################
# Purpose: Visualize fastANI core-genome comparison
# Usage: Rscript <this_script>  <query sequence in fasta format> <subject sequence> <fastANI visualization output>
# Output: <fastANI visualization output filename>.pdf
# Uses genoPlotR package: http://genoplotr.r-forge.r-project.org
######################################################

#on the terminal
#  fastANI -q ./NODE_34_length_22973_cov_31.027577.fasta -r 5Flank_thorough_3Flank_DMS092.fasta --visualize -o ANI_comp.out --fragLen 1000


######################################################################
# import files to plot
######################################################################

#Parse command line arguments
query_fasta <- file.choose()     # ./7_compare_contigs_to_region/5Flank_thorough_3Flank_DMS092.fasta

subject_fasta <- file.choose()    # ./DMS092_contigs.fast

fastANI_visual_file <- file.choose() #output from fastANI -> compare_contigs_to_region.out.visual

######################################################################
# read files 
######################################################################

#Read fastANI output
comparison <- try(genoPlotR::read_comparison_from_blast(fastANI_visual_file))

#Read sequences into genoPlotR objects
Query <- try(genoPlotR::read_dna_seg_from_file(query_fasta))
Ref <- try(genoPlotR::read_dna_seg_from_file(subject_fasta))

#plotTitle = paste(query_fasta, subject_fasta, sep=" v/s ")

#pdf( paste(fastANI_visual_file,".pdf",sep="") )

genoPlotR::plot_gene_map(dna_segs = list(Ref, Query), 
              comparisons = list(comparison), 
              main = "", scale = FALSE, 
              dna_seg_label_col="black",
              scale_cex = 1, n_scale_ticks = 4)

dev.off()
