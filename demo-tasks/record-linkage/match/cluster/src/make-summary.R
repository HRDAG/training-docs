library(arrow)
library(tidyverse)
library(yaml)

ents <- read_parquet("output/entity-ids.parquet")

degree_distribution <- ents %>%
    distinct(recordid, degree) %>%
    pluck("degree") %>% quantile(c(seq(.5,.9,.1), .95, .99, 1))

recs_per_entity <- ents %>%
    distinct(entity_id, entity_nrecs) %>%
    pluck("entity_nrecs") %>%
    quantile(c(seq(.5, .9, .1), .95, .99, 1))

n_entity <- length(unique(ents$entity_id))

smry <- list(
    degree_distribution = as.list(degree_distribution),
    recs_per_entity = as.list(recs_per_entity),
    n_entity = n_entity,
    n_recs = nrow(ents))

write_yaml(smry, "output/cluster-summary.yaml", )

# done.
