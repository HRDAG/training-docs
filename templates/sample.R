# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/src/script.R

# dependencies
library(argparse)
library(assertr)
library(logging)

# setup logging
logname <- "output/core-task.log”
basicConfig()
addHandler(writeToFile, logger="company", file=logname)

# arg handling
parser <- ArgumentParser()
parser$add_argument("--input")
parser$add_argument("--output")
args <- parser$parse_args()

input <- args$input
output <- args$output

# read data, initial verification
loginfo("Loading data", logger="")
dat <- read.ext(input)
dat %>%
  verify(nrow(.) > 100) %>%

# save data
write.parquet(dat, output)

loginfo("done", logger="")

# done.
