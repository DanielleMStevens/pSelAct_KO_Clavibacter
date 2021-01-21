#-----------------------------------------------------------------------------------------------
# Coaker Lab - Plant Pathology Department UC Davis
# Author: Danielle M. Stevens
# Last Updated: 01/20/2021
# Script Purpose: Plot Gene Maps of Knockouts in clavibacter
# Inputs: 
# Outputs: 
#-----------------------------------------------------------------------------------------------


######################################################################
# library packages need to load
######################################################################

install.packages('gggenes')
devtools::install_github("wilkox/gggenes")


library(gggenes)
library(digest)
library(grid)
library(ggfittext)
 
######################################################################
# upload file of gene positions
######################################################################

# make sure to set path to the same place where the figure 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


chpE_ppaC_position_file <- read.table(file = "./Gene_plot_data/CM_chpE_ppaC_Gene_list.txt", 
                                      header = T, 
                                      sep = ",",
                                      stringsAsFactors = F)


######################################################################
# upload file of gene positions
######################################################################

## with text
ggplot2::ggplot(chpE_ppaC_position_file, 
               ggplot2::aes(xmin = start, 
                            xmax = end, 
                            y = molecule, 
                            fill = gene, 
                            label = gene,
                            forward = direction)) +
  
  gggenes::geom_gene_arrow(arrowhead_height = grid::unit(6, "mm"), 
                           arrowhead_width = unit(2, "mm"),
                           arrow_body_height = grid::unit(6, "mm")) +
  
  #ggplot2::geom_text(ggplot2::aes(x = end - ((end-start)/2), y = 1.1, label = gene)) +
  #gggenes::geom_gene_label(align = "left", size =12) +
  
  ggfittext::geom_fit_text(min.size = 4, place = "center", vjust = 1)+
  
  ggplot2::facet_wrap(~ molecule, scales = "free", ncol = 1) +
  ggplot2::scale_fill_brewer(palette = "Set3") +
  gggenes::theme_genes() +
  ggplot2::theme(legend.position = "none",
                 axis.text.y.left = ggplot2::element_blank(),
                 axis.line.x = ggplot2::element_line(colour = "black", size = 0.5),
                 panel.grid.major.y = ggplot2::element_line(colour = "black", size = 1), 
                 axis.text.y = ggplot2::element_text(colour = "black"),
                 axis.text.x = ggplot2::element_text(colour = "black", size = 11),
                 text = ggplot2::element_text(colour = "black", size = 11, family = 'Arial')) +
  ggplot2::ylab("") +
  ggplot2::xlab("")
  


## no text
ggplot2::ggplot(chpE_ppaC_position_file, 
                ggplot2::aes(xmin = start, 
                             xmax = end, 
                             y = molecule, 
                             fill = gene, 
                             label = gene,
                             forward = direction)) +
  
  gggenes::geom_gene_arrow(arrowhead_height = grid::unit(6, "mm"), 
                           arrowhead_width = unit(2, "mm"),
                           arrow_body_height = grid::unit(6, "mm")) +
  
  ggplot2::facet_wrap(~ molecule, scales = "free", ncol = 1) +
  ggplot2::scale_fill_brewer(palette = "Set3") +
  gggenes::theme_genes() +
  ggplot2::theme(legend.position = "none",
                 axis.text.y.left = ggplot2::element_blank(),
                 axis.line.x = ggplot2::element_line(colour = "black", size = 0.5),
                 panel.grid.major.y = ggplot2::element_line(colour = "black", size = 1), 
                 axis.text.y = ggplot2::element_text(colour = "black"),
                 axis.text.x = ggplot2::element_text(colour = "black", size = 11),
                 text = ggplot2::element_text(colour = "black", size = 11, family = 'Arial')) +
  ggplot2::ylab("") +
  ggplot2::xlab("")
