library(arrow)
library(tidyverse)

fname <- "../compare/output/pair-classifier-features.parquet"
feats <- read_parquet(fname)

predictions <- feats %>%
    mutate(matchscore = case_when(
        yrmo & album_name > .9 & song_name > .9 & artist_name > .9 ~ 1,
        album_name >= 1 & song_name >= 1 & artist_name >= 1 ~ 1,
        yrmo &
            genre_overlap > 2  &
            artist_name > .5 &
            album_name > .5 &
            song_name > .5 ~ 1,
        genre_overlap > 2 & song_name > .9 & artist_name > .7 ~ 1,
        yrmo & album_name > .8 & song_name > .8 ~ 1,
        TRUE ~ 0)) %>%
    select(recordid1, recordid2, matchscore)

write_parquet(predictions, "output/match-predictions.parquet")

# done.
