library(arrow)
library(fs)
library(tidyverse)
library(lubridate)
library(janitor)

itn <- read_csv("input/1_itunes.csv",
            col_types = cols(.default = col_character(),
                             Customer_Rating = col_number())) %>%
    janitor::clean_names()

out <- itn %>%
    mutate(year_only = str_detect(released, "^[0-9]{4}$"),
           dt_released = lubridate::dmy(released),
           yy_released = if_else(year_only,
                                 as.numeric(released),
                                 lubridate::year(dt_released))) %>%
    transmute(recordid = subject_id,
              album_name,
              artist_name,
              song_name,
              price = str_replace_all(price, "\\$", "") %>% as.numeric,
              time,
              yy_released,
              mm_released = lubridate::month(dt_released),
              dd_released = lubridate::day(dt_released),
              copyright = copy_right,
              genre)

write_parquet(out, "output/itunes.parquet")

# done.
