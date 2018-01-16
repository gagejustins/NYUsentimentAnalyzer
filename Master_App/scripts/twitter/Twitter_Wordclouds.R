library(tm)
library(twitteR)
library(stringr)

getNYUCorpus <- function(max.tweets) {

  ##User: @gage_projects
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
  
  #Remove @users
  nohandles.nyu <- str_replace_all(tweets.df.nyu$text, "@\\w+", "")
  
  #Create and clean corpus
  nyu.wordCorpus <- VCorpus(VectorSource(nohandles.nyu))
  
  nyu.wordCorpus <- tm_map(nyu.wordCorpus, removePunctuation)
  nyu.wordCorpus <- tm_map(nyu.wordCorpus, content_transformer(tolower))
  nyu.wordCorpus <- tm_map(nyu.wordCorpus, removeWords, stopwords("english"))
  nyu.wordCorpus <- tm_map(nyu.wordCorpus, removeWords, c("nyu", "university"))
  nyu.wordCorpus <- tm_map(nyu.wordCorpus, stripWhitespace)
  
  return(nyu.wordCorpus)

}

getColumbiaCorpus <- function(max.tweets) {
  
  #Get tweets
  tweets.columbia <- searchTwitter("#columbiau OR #Columbiau OR columbia university OR Columbia University", n=max.tweets, lang="en")
  tweets.df.columbia <- twListToDF(tweets.columbia)
  
  #Remove @users
  nohandles.columbia <- str_replace_all(tweets.df.columbia$text, "@\\w+", "")
  
  #Create and clean corpus
  columbia.wordCorpus <- VCorpus(VectorSource(nohandles.columbia))
  
  columbia.wordCorpus <- tm_map(columbia.wordCorpus, removePunctuation)
  columbia.wordCorpus <- tm_map(columbia.wordCorpus, content_transformer(tolower))
  columbia.wordCorpus <- tm_map(columbia.wordCorpus, removeWords, stopwords("english"))
  columbia.wordCorpus <- tm_map(columbia.wordCorpus, removeWords, c("columbia", "university"))
  columbia.wordCorpus <- tm_map(columbia.wordCorpus, stripWhitespace)
  
  return(columbia.wordCorpus)
  
}



