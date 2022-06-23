library(arrow)
library(tidyverse)

recs <- read_parquet("../import/output/music.parquet")
ents <- read_parquet("../cluster/output/entity-ids.parquet")

pick_value <- function(values) {
    # confusingly, this `mode` is looking for `character` vs. `integer` etc.,
    # NOT the statistical mode. since we use names() to identify the modal
    # value below, we have to convert back to original data
    # type before returning
    original_type <- mode(values)
    if (all(is.na(values))) return(values[1])
    frequencies <- table(values, useNA = "no")
    if (length(frequencies) == 1) {
        res <- names(frequencies)[1]
    } else {
        modal_value <- max(frequencies)
        remaining_candidates <- names(which(frequencies == modal_value))
        res <- sample(remaining_candidates, 1)
    }
    as(res, original_type)
}

pad <- function(num) str_pad(num, width = 2, side = "left", pad = "0")

cols_to_keep <- c("album_name",
                  "song_name",
                  "price",
                  "time",
                  "date_released",
                  "genre")

out <- ents %>%
    inner_join(recs, by = "recordid") %>%
    mutate(across(c(mm_released, dd_released), pad)) %>%
    mutate(date_released = str_c(yy_released, mm_released, dd_released,
                                   sep = "-")) %>%
    group_by(entity_id) %>%
    summarise(in_amz = max(source == "amz"),
              in_itn = max(source == "itunes"),
              across(all_of(cols_to_keep), pick_value),
              recordids = str_c(recordid, collapse=","))

stopifnot(
    setequal(out$entity_id, ents$entity_id),
    nrow(out) == length(unique(out$entity_id))
)

write_parquet(out, "output/music-entities.parquet")
