#-----------------------------------------------------------------------------------------------
# Coaker Lab - Plant Pathology Department UC Davis
# Author: Danielle M. Stevens
# Last Updated: 06/08/2021
# Script Purpose: Plot comparisons of genomes between WT and KO
# Inputs: Outputs from items 6 & 7 from methods
# Outputs: Plots for items 6 & 7 from methods
#-----------------------------------------------------------------------------------------------


######################################################################
# library packages need to load
######################################################################

#install.packages(devtools)
#devtools::install_github("dwinter/pafr")
library(pafr, quietly=TRUE)
library(ggplot2)
library(genoPlotR)



######################################################################
# import files to plot
######################################################################


whole_genome_alignment <- pafr::read_paf(file_name = file.choose()) # choose align_contigs_to_reference.paf


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

######################################################################
# import files to plot
######################################################################

#Parse command line arguments
query_fasta <- file.choose()     # ./7_compare_contigs_to_region/5Flank_thorough_3Flank_DMS092.fasta

subject_fasta <- file.choose()    # ./7_compare_contigs_to_region/DMS02_region_of_interest.fasta

fastANI_visual_file <- file.choose() #output from fastANI -> ./7_compare_contigs_to_region/compare_contigs_to_region.out.visual

######################################################################
# read files 
######################################################################


#Read sequences into genoPlotR objects
Query <- try(genoPlotR::read_dna_seg_from_file(query_fasta))
Ref <- try(genoPlotR::read_dna_seg_from_file(subject_fasta))


#Read fastANI output
comparison <- try(genoPlotR::read_comparison_from_blast(fastANI_visual_file))


genoPlotR::plot_gene_map(dna_segs = list(Query, Ref), 
              comparisons = list(comparison), 
              main = "", scale = FALSE, 
              dna_seg_label_col = "black",
              seg_plot_yaxis = 2,
              annotation_cex = 0.5,
              scale_cex = 1.5, n_scale_ticks = 4)
