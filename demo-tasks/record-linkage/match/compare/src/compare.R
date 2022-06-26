library(arrow)
library(tidyverse)
library(stringdist)

cleanstring <- function(string) {
    cln <- str_to_lower(string) %>%
        str_replace_all("[^a-z0-9 ]", " ") %>%
        str_squish
    if_else(cln == "", NA_character_, cln)
}

mz <- read_parquet("../import/output/music.parquet")
pairs <- read_parquet("../blocking/output/candidate-pairs.parquet")

processed <- mz %>%
    mutate(across(c(album_name, artist_name, song_name),
                  cleanstring),
           genre = str_to_lower(genre) %>% str_squish %>% str_split(",")) %>%
    select(recordid,
           album_name, artist_name, song_name,
           yy_released, mm_released, dd_released, genre)

similarity <- function(string1, string2, method = "cosine") {
    1 - stringdist(string1, string2, method = method, nthread = 11)
}

feats <- pairs %>%
    inner_join(processed, by = c("recordid1" = "recordid")) %>%
    inner_join(processed, by = c("recordid2" = "recordid"),
               suffix = c("_1", "_2")) %>%
    mutate(genre_overlap = map2_dbl(genre_1, genre_2, ~length(intersect(.x, .y))),
           yrmo = yy_released_1 == yy_released_2 & mm_released_1 == mm_released_2,
           album_name = similarity(album_name_1, album_name_2),
           song_name = similarity(song_name_1, song_name_2),
           artist_name = similarity(artist_name_1, artist_name_2, method = "jw"),
           genre_overlap) %>%
    select(-ends_with("_1"), -ends_with("_2"))

write_parquet(feats, "output/pair-classifier-features.parquet")

# done.
