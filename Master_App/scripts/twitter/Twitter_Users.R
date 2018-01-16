library(twitteR)
library(dplyr)

getNYUUsers <- function(max.tweets) {
  
  #User: @gage_projects
  #Load oauth keys
  api_key <- 	"WpL6gZzeTmIZv5j1UpAA8gYQ1"
  api_secret <- "TcVDZ0vnbZcgjolJr9b7niYvU2xUF9pAPwy1Q05Smy1wahtoap"
  token <- "802657325148504068-NXyYe2bkWjJBqjmAjFbTqMNmDxy1UB5"
  token_secret <- "nJ5hYFzFURFGvywG6HjqxuBdjZCacDilv8A5OUKyvea4C"
  
  #Authorize
  setup_twitter_oauth(api_key, api_secret, token, token_secret)
  
  #Get tweets
  tweets.nyu <- searchTwitter("#nyu OR #NYU OR NYU OR nyu", n=max.tweets, lang="en")
  tweets.df.nyu <- twListToDF(tweets.nyu)
  
  nyu.users <- tweets.df.nyu %>% group_by(screenName) %>% summarise(count = n()) %>% arrange(desc(count))
  
  return(nyu.users)

}

getColumbiaUsers <- function(max.tweets) {
  
  #Get tweets
  tweets.columbia <- searchTwitter("#columbiau OR #Columbiau OR columbia university OR Columbia University", n=max.tweets, lang="en")
  tweets.df.columbia <- twListToDF(tweets.columbia)
  
  columbia.users <- tweets.df.columbia %>% group_by(screenName) %>% summarise(count = n()) %>% arrange(desc(count))
  
  return(columbia.users)
  
}
