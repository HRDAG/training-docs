library(arrow)
library(furrr)
library(tidyverse)
library(logger)
library(yaml)

mz <- read_parquet("../blocking-features/output/blockfeats.parquet")
rules <- read_yaml("hand/rules.yaml")

log_appender(appender_file("output/pair-generation.log"))

topairs <- function(recordids) {
    expand_grid(recordid1 = recordids,
                recordid2 = recordids) %>%
        filter(recordid1 < recordid2)
}

generate_pairs <- function(rules, data) {
     groups <- data %>%
         filter(if_all(all_of(rules), ~!is.na(.))) %>%
         group_by(across(all_of(rules))) %>%
         group_split %>% keep(~nrow(.) > 1)
     out <- map(groups, pluck, "recordid") %>%
         future_map_dfr(topairs)
    log_info("{str_c(rules, collapse = ',')}: {nrow(out)}")
    return(out)
}

plan(multisession)
pairs <- map_dfr(rules, generate_pairs, data = mz) %>% distinct
plan(sequential)

write_parquet(pairs, "output/candidate-pairs.parquet")
