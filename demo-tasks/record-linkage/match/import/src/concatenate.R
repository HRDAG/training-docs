library(arrow)
library(tidyverse)
library(tools)

fname <- function(x) file_path_sans_ext(basename(x))

time2seconds <- function(string) {
    ms <- str_split(string, fixed(":"))
}

files <- c("../../individual/amazon/output/amz.parquet",
           "../../individual/itunes/output/itunes.parquet") %>%
    set_names(fname)

music <- map_dfr(files, read_parquet, .id = "source") %>%
    select(recordid, source, everything())

write_parquet(music, "output/music.parquet")

# done.
