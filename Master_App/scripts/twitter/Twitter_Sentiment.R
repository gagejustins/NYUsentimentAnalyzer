library(syuzhet)
library(tm)
library(twitteR)
library(stringr)

getTweetSentiment <- function(max.tweets) {
  
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
  tweets.columbia <- searchTwitter("#columbia OR #Columbia OR columbia OR Columbia", n=max.tweets, lang="en")
  tweets.df.nyu <- twListToDF(tweets.nyu)
  tweets.df.columbia <- twListToDF(tweets.columbia)
  
  nyu.sentiment <- get_nrc_sentiment(iconv(tweets.df.nyu$text, "latin1", "ASCII", sub=""))
  columbia.sentiment <- get_nrc_sentiment(iconv(tweets.df.columbia$text, "latin1", "ASCII", sub=""))
  
  tweets.df.nyu <- cbind(tweets.df.nyu, nyu.sentiment)
  tweets.df.columbia <- cbind(tweets.df.columbia, columbia.sentiment)
  
  nyu.sentiment.sums <- data.frame(sentiment = colnames(nyu.sentiment),freq = colSums(nyu.sentiment))
  columbia.sentiment.sums <- data.frame(sentiment = colnames(columbia.sentiment), freq = colSums(columbia.sentiment))
  
  #Combine them in a dataframe for comparison
  comparison.df <- rbind(nyu.sentiment.sums, columbia.sentiment.sums)
  nyu <- rep("nyu",10)
  columbia <- rep("columbia",10)
  schools <- c(nyu, columbia)
  comparison.df$school <- schools
  
  return(comparison.df)
}






















