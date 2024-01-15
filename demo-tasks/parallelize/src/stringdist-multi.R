#!/usr/bin/env python3
# vim: set ts=4 sts=0 sw=4 si fenc=utf-8 et:
# vim: set fdm=marker fmr={{{,}}} fdl=0 foldcolumn=4:
# Authors:     BP
# Maintainers: BP
# Copyright:   2023, HRDAG, GPL v2 or later
# =========================================

# dependencies --- {{{
library(pacman)
pacman::p_load(argparse, arrow, assertr, logger, stringdist, tidyverse)
# }}}

# support methods --- {{{
get_args <- function() {
  parser <- ArgumentParser()
  parser$add_argument("--pairs", default="/Users/home/git/training-docs/demo-tasks/parallelize/output/linepairs.parquet")
  parser$add_argument("--nthreads", default=4)
  parser$add_argument("--output", default="/Users/home/git/training-docs/demo-tasks/parallelize/output/L-R-singl.parquet")
  args <- parser$parse_args()
  args
}

set_log <- function(logname) {
  log_appender(appender_tee(logname))
}
# }}}

# main --- {{{
logname <- "output/L-R-singl.log"
set_log(logname)

# arg handling
args <- get_args() 
pairs <- read_parquet(args$pairs)
OMP_NUM_THREADS <- args$nthreads
pairs$stringdist <- stringdist(pairs$line_a, pairs$line_b, method='lv', nthread=OMP_NUM_THREADS)
write_parquet(pairs, args$output)
# }}}
