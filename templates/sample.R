# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     FL
# Maintainers: FL
# Copyright:   YYYY, HRDAG, GPL v2 or later
# =========================================
# Project-Name/parent-task/core-task/src/script.R

# ---- dependencies {{{
library(pacman)
pacman::p_load(argparse, assertr, logger, tidyverse)
#}}}

# ---- main {{{
# setup logging
logname <- "output/core-task.log"
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
#}}}

# done.
