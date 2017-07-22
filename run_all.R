## Run all

# Housekeeping
rm(list = ls())

# Load libraries
library(knitr)
library(rmarkdown)

# Generate files
render("rmds/Manuscript.Rmd", output_file = "Manuscript.pdf", output_dir = "reports", envir = new.env())
render("rmds/Figures.Rmd", output_file = "Figures.pdf", output_dir = "reports", envir = new.env())
render("rmds/Tables.Rmd", output_file = "Tables.pdf", output_dir = "reports", envir = new.env())
render("rmds/Supplementary material.Rmd", output_file = "Supplementary material.pdf", output_dir = "reports")
render("rmds/Supplementary material 2.Rmd", output_file = "Supplementary material 2.pdf", output_dir = "reports", envir = new.env())

