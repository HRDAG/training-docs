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

# ---- support methods {{{
get_args <- function() {
    parser <- ArgumentParser()
    parser$add_argument("--input")
    parser$add_argument("--output")
    args <- parser$parse_args()
    args
}

set_log <- function(logname) {
    log_appender(appender_tee(logname))
}

initial_asserts <- function(data) {
    data %>%
        verify(nrow(.) > 100)
}
# }}}

# ---- main {{{
logname <- "output/core-task.log"
set_log(logname)

# arg handling
args <- get_args() 
input <- args$input
output <- args$output

# read data, initial verification
log_info("Loading data", logger="")
dat <- read.ext(input)
initial_asserts(dat)

# save data
write.parquet(dat, output)

log_info("done", logger="")
#}}}

# done.
