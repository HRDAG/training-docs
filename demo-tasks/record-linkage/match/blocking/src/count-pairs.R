library(arrow)
library(tidyverse)
library(yaml)
library(furrr)

mz <- read_parquet("../blocking-features/output/blockfeats.parquet")
all_rules <- read_yaml("hand/rules.yaml")

count_pairs <- function(rules, data) {
     smry <- data %>%
         filter(if_all(all_of(rules), ~!is.na(.))) %>%
         count(across(all_of(rules)))
     ns <- smry$n
     sum(ns * (ns - 1) / 2)
}

plan(multicore)
rule_pair_counts <- future_map_dbl(all_rules, count_pairs, data = mz)
plan(sequential)
out <- c(rule_pair_counts, "total" = sum(rule_pair_counts)) %>%
    as.list

write_yaml(out, "output/expected-pair-counts.yaml", )
