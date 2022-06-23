library(arrow)
library(digest) # calculate hashes to create identifiers
library(tidyverse)
library(tidygraph)

recs <- read_parquet("../import/output/music.parquet")
labs <- read_parquet("../classify/output/match-predictions.parquet")


threshold <- .5

edges <- labs %>%
    filter(matchscore >= threshold) %>%
    transmute(from = recordid1, to = recordid2, matchscore)

graph <- tbl_graph(
    nodes = recs %>% select(recordid),
    edges = edges,
    directed = FALSE,
    node_key = "recordid")

connected_components <- graph %>%
    activate("nodes") %>%
    mutate(component  = group_components(type = "weak"),
           degree     = centrality_degree()) %>%
    as_tibble("nodes")

make_id <- function(recordids) digest(sort(unique(recordids)), algo = "sha1")

# now generate unique identifiers for the merged records:
out <- connected_components %>%
    group_by(component) %>%
    mutate(entity_id = make_id(recordid),
           entity_nrecs = n_distinct(recordid)) %>%
    ungroup

stopifnot(setequal(out$recordid, recs$recordid))
stopifnot(nrow(out) == length(unique(out$recordid)))

write_parquet(out, "output/entity-ids.parquet")

# done.
