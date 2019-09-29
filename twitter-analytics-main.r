##############################
## Twitter Analytics - Main.R
##############################
##############################
## Imports
##############################
imports <- c('rvest','xml2','jsonlite','stringr','data.table','rio')
invisible(lapply(imports, require, character.only = TRUE))
source("Helpers.R", chdir = TRUE)
##############################
## Command Line Args
##############################
args <- commandArgs(trailingOnly = TRUE)
args_list <- as.list(args)
##############################
## Twitter Analytics Scrape
##############################
##############################
## Read in HTML Files
## Read in CSS JSON
##############################
twitter_local <- lapply(args_list, read_html)
css <- read_json('twitter_scraping_css.json')
##############################
## Export
##############################
date_time <- toString(format(Sys.time(), "%Y-%m-%d %H-%M-%S"))
date_time <- toString(sprintf('%s - twitter-analytics-out.csv',
                              date_time))
scrape <- lapply(twitter_local, TwitterAnalyticsScrape, css)
scrape <- rbindlist(scrape)
export(scrape, date_time)
