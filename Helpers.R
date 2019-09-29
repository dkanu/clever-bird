############################
## Helpers.R
############################
#' Modify Generic CSS to Target Specific TweetDeck Column
#'
#' @param css string; specifying json file containing generic twitter css
#' @param column integer; tweetdeck column to be scraped
#'
#' @return list; strings with column specific css selectors
#' @export
#'
#' @examples
TweetDeckColumnSelector <- function(css, column){
  td_column <- toString(column)
  
  date.selector <- sprintf(css$tweetdeck$date.selector, column)
  link.selector <- sprintf(css$tweetdeck$link.selector, column)
  
  author.selector <- sprintf(css$tweetdeck$author.selector, column)
  replies.selector <- sprintf(css$tweetdeck$replies.selector, column)
  retweets.selector <- sprintf(css$tweetdeck$retweets.selector, column)
  favorites.selector <- sprintf(css$tweetdeck$favorites.selector, column)
  
  out <- list(column, 
              date.selector, 
              link.selector, 
              author.selector, 
              replies.selector, 
              retweets.selector,
              favorites.selector
  )
  
  names(out) <- c('column',
                  'date.selector',
                  'link.selector',
                  'author.selector',
                  'replies.selector',
                  'retweets.selector',
                  'favorites.selector'
  )
  
  return(out)
}

#' Scrape TweetDeck HTML File
#'
#' @param x string; specifying tweetdeck html file - recomend storing file locally
#' @param fmt_css list; containing strings of column specific css
#'
#' @return dataframe; date, tweet, author, replies, retweets, favorites
#' @export
#'
#' @examples
TweetDeckScrape <- function(x, fmt_css){
  date <- x %>% html_nodes(fmt_css$date.selector) %>% html_text
  tweet <- x %>% html_nodes(fmt_css$link.selector) %>% html_attr('href')
  author <- x %>% html_nodes(fmt_css$author.selector) %>% html_text
  replies <- x %>% html_nodes(fmt_css$replies.selector) %>% html_text
  replies <- as.numeric(replies)
  replies[is.na(replies)] <- 0
  retweets <- x %>% html_nodes(fmt_css$retweets.selector) %>% html_text
  retweets <- as.numeric(retweets)
  retweets[is.na(retweets)] <- 0
  favorites <- x %>% html_nodes(fmt_css$favorites.selector) %>% html_text
  favorites <- as.numeric(favorites)
  favorites[is.na(favorites)] <- 0
  
  out <- as.data.frame(
    cbind(date,
          tweet,
          author,
          replies,
          retweets,
          favorites
    )
  )
  
  colnames(out) <- c('date',
                     'tweet',
                     'author',
                     'replies',
                     'retweets',
                     'favorites')
  return(out)
}

#Define a String for css selector that points to Twitter usernames of members on Twitter List
#' Scrape Twitter Analytics HTML File
#'
#' @param x string; specifying twitter analytics html file - recomend storing file locally
#' @param css string; specifying json file containing generic twitter css
#'
#' @return dataframe; url, impressions, engagements, engagement_rate
#' @export
#'
#' @examples
TwitterAnalyticsScrape <- function(x, css){
  urls <- x %>% html_nodes(css$twitter.analytics$url.selector) %>%html_attr('href')
  impressions <- x %>% html_nodes(css$twitter.analytics$imp.selector) %>%html_text %>% gsub(",","",.)
  impressions <- as.numeric(impressions)
  engagements <- x %>% html_nodes(css$twitter.analytics$eng.selector) %>%html_text %>% gsub(",","",.)
  engagements <- engagements[c(TRUE, FALSE)]
  engagements <- as.numeric(engagements)
  
  engagment_rate <- engagements/impressions
  
  out <- data.frame(
    cbind(urls,
          impressions, 
          engagements, 
          engagment_rate
    )
  )
  
  colnames(out) <- c('url',
                     'impressions',
                     'engagements',
                     'engagement_rate')
  return(out)
}
