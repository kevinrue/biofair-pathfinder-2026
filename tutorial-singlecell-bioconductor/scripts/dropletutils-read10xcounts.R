#!/usr/bin/env Rscript

suppressPackageStartupMessages({
	library(optparse)
	library(DropletUtils)
	library(LoomExperiment)
})

# Note
# '--samples'
# This argument requires a directory in which the triplet of files is stored (matrix.mtx, barcodes.tsv, features.tsv).
# Meanwhile, the Galaxy tool takes the three separate filepaths as input.
# Before calling this script, the tool wrapper should make a copy of the input files in a directory called 'data/'.

option_list <- list(
	make_option(
		c("-s", "--samples"),
		type = "character",
		default = "data/",
		help = "Directory containing the 10x Genomics files [default %default]"
	),
	make_option(
		c("-o", "--output"),
		type = "character",
		default = "outputs/sce.loom",
		help = "Path to the output loom file [default %default]"
	)
)

opt <- parse_args(OptionParser(option_list = option_list))

sce <- DropletUtils::read10xCounts(
	samples = opt$samples,
	row.names = "symbol"
)

output_dir <- dirname(opt$output)
if (!dir.exists(output_dir)) {
	dir.create(output_dir, recursive = TRUE)
}

scle <- as(sce, "SingleCellLoomExperiment")
if (!file.exists(opt$output)) {
	export(object = scle, con = opt$output, format = "loom")
}

rm(list = ls())
