library(arrow)
library(tidyverse)
library(stringdist)

mz <- read_parquet("../import/output/music.parquet")

calc_secs <- function(time_segments) {
    if (length(time_segments) > 3) return(NA_real_)
    segs <- as.numeric(time_segments)
    if (length(time_segments) == 1) return(segs)
    if (length(time_segments) == 2) return(60*segs[1] + segs[2])
    360*segs[1] + 60*segs[2] + segs[3]
}

time2secs <- function(timestring) {
    map_dbl(str_split(timestring, fixed(":")), calc_secs)
}

cleanstring <- function(string) {
    cln <- str_to_lower(string) %>%
        str_replace_all("[^a-z0-9 ]", " ") %>%
        str_squish
    if_else(cln == "", NA_character_, cln)
}

padnum <- function(num) str_pad(num, width=2, side = "left", pad = "0")
sortgenre <- function(g) str_split(g, ",") %>%
    map(str_squish) %>%
    map(unique) %>%
    map(sort)

out <- mz %>%
    mutate(genres  = sortgenre(genre),
           glen    = map_int(genres, length),
           genre_1 = map_chr(genres, 1),
           genre_n = map2_chr(genres, glen, `[`),
           across(c(album_name, artist_name, song_name,
                    genre, genre_1, genre_n),
                  cleanstring)) %>%
    transmute(
        recordid,
        album_name_first_5 = str_sub(album_name, 1, 5),
        artist_name_sx = phonetic(artist_name, method = "soundex"),
        song_name_first_5 = str_sub(song_name, 1, 5),
        genre_1, genre_n,
        time_secs = time2secs(time),
        time_secs_round10 = round(time_secs/10, digits=0) * 10,
        time_secs_round100 = round(time_secs/100, digits=0) * 100,
        released_yrmo = str_c(padnum(yy_released), padnum(mm_released))
    )

write_parquet(out, "output/blockfeats.parquet")

# done.
