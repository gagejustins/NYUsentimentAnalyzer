library(httr)
library(jsonlite)
library(tidyr)
library(dplyr)

consumer_key <- "cE-4re1IM_lI_UuFyDqPAw"
consumer_secret <- "q9UqjSfGvjQzQmJSwkv14md1HJ0"
token <- "jasfSDI7hc1985La5Xz8sf10IXqcoBuk"
token_secret <- "qxXYYrsHJm0OSEc2XZUQw22jn50"

myapp = oauth_app("YELP", key = consumer_key, secret = consumer_secret)
sig = sign_oauth1.0(myapp, token = token, token_secret = token_secret)

getReviewStats <- function() {
  
  nyu <- GET("https://api.yelp.com/v2/business/new-york-university-new-york-18", sig)
  columbia <- GET("https://api.yelp.com/v2/business/columbia-university-new-york-43", sig)
  
  nyu.content <- httr::content(nyu, type="text", encoding="UTF8")
  columbia.content <- httr::content(columbia, type="text", encoding="UTF8")
  
  nyu.json <- fromJSON(nyu.content)
  columbia.json <- fromJSON(columbia.content)
  
  nyu.df <- data.frame(value = unlist(nyu.json))
  nyu.df$field <- rownames(nyu.df)
  nyu.df <- spread(nyu.df, field, value)
  #Remove extra column so we can bind these rows
  nyu.df$location.cross_streets <- NULL
  
  columbia.df <- data.frame(value = unlist(columbia.json))
  columbia.df$field <- rownames(columbia.df)
  columbia.df <- spread(columbia.df, field, value)
  
  comparison.df <- rbind(nyu.df, columbia.df)
  
  rating <- comparison.df$rating
  review.count <- comparison.df$review_count
  
  plot_df <- data.frame(school = c("nyu","columbia"), rating = rating, count = review.count)
  
  rating.df <- select(plot_df, school, rating)
  count.df <- select(plot_df, school, count)
  
  return(list(rating.df, count.df))
}





























