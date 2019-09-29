##############################
## Tweetdeck - Main.R
##############################
##############################
## Imports
##############################
imports <- c('rvest','xml2','jsonlite','stringr','data.table','rio')
invisible(lapply(imports, require, character.only = TRUE))
source("Helpers.R", chdir = TRUE)
##############################
## Arg Parser
##############################
args <- commandArgs(trailingOnly = TRUE)
column <- as.integer(args[1])
args_list <- as.list(args[-1])
##############################
## Tweetdeck Scrape
##############################
##############################
## Read in stored HTML Files
## Read in CSS JSON
###############################
twitter_local <- lapply(args_list, read_html)
css <- read_json('twitter_scraping_css.json')
###############################
## Export
###############################
date_time <- toString(format(Sys.time(), "%Y-%m-%d %H-%M-%S"))
date_time <- toString(sprintf('%s - tweetdeck-out.csv',
                              date_time))
css_specific <- TweetDeckColumnSelector(css, column = column)
scrape <- lapply(twitter_local, TweetDeckScrape, css_specific)
scrape <- rbindlist(scrape)
export(scrape, date_time)
