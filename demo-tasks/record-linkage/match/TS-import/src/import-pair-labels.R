library(tidyverse)
library(logger)
library(arrow)

read_training <- function(filename) {
    df <- read_csv(filename, col_types = 'ccl')
    log_info("file {basename(filename)} has {nrow(df)} rows")
    out <- df %>%
        transmute(recordid1 = pmin(source_id, target_id),
                  recordid2 = pmax(source_id, target_id),
                  matching) %>%
        distinct
    log_info("file {basename(filename)} processed, {nrow(out)} distinct pairs")
    return(out)
}

fnames <- c("gs_train", "gs_val", "gs_test")
paths <- file.path("../../setup/output/downloaded", str_c(fnames, ".csv"))

labs <- map_dfr(paths, read_training)
pospairs <- filter(labs, matching) %>% distinct(recordid1, recordid2)

write_parquet(labs, "output/labeled-pairs.parquet")
write_parquet(pospairs, "output/positive-pairs.parquet")

# done.
