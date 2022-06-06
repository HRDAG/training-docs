library(arrow)
library(lubridate)
library(tidyverse)
library(fs)
library(janitor)
library(argparse)

# args {{{
parser <- ArgumentParser()
parser$add_argument("--input")
parser$add_argument("--output")
args <- parser$parse_args()
# }}}

amz <- read_csv(args$input,
            col_types = cols(.default = col_character(),
                             Customer_Rating = col_number())) %>%
    janitor::clean_names()

price2num <- function(price) str_replace_all(price, "\\$", "") %>% as.numeric

out <- amz %>%
    mutate(released = lubridate::mdy(released)) %>%
    transmute(recordid = subject_id,
              album_name,
              artist_name,
              song_name,
              price = if_else(price == "FREE", "0", price) %>% price2num,
              time,
              yy_released = lubridate::year(released),
              mm_released = lubridate::month(released),
              dd_released = lubridate::day(released),
              copyright,
              genre)

write_parquet(out, args$output)
