library(syuzhet)

#Define a function to create a list of links for a given url to scrape reviews.

get_yelp_links <- function(max_pages, url) {
  
  links <- c()
  starts <- seq(0, 20*as.numeric(max_pages),20)
  
  for (i in seq(1,length(starts),1)) {
    index <- starts[i]
    full <- paste(url, as.character(index), sep="")
    links[i] <- full
  }
  
  return(links)
  
}

#Define function to scrape reviews.

scrape_yelp_reviews <- function(links_list) {
  
  reviews_list <- c()
  
  for (i in seq(1,length(links_list),1)) {
    
    link <- links_list[i]
    reviews <- read_html(link)
    reviews <- html_nodes(reviews, ".review-content p")
    reviews <- html_text(reviews)
    
    reviews_list <- append(reviews_list, reviews)
    
  }
  
  return(reviews_list)
  
}

#Master function to be called in server.R

getSentiment <- function(pages) {
  
  nyu.links <- get_yelp_links(pages, "https://www.yelp.com/biz/new-york-university-new-york-18?start=")
  nyu.reviews <- scrape_yelp_reviews(nyu.links)
  
  columbia.links <- get_yelp_links(pages, "https://www.yelp.com/biz/columbia-university-new-york-43?start=")
  columbia.reviews <- scrape_yelp_reviews(columbia.links)

  nyu.sentiment <- get_nrc_sentiment(nyu.reviews)
  columbia.sentiment <- get_nrc_sentiment(columbia.reviews)
  
  nyu.review.sentiment.sums <- data.frame(sentiment = colnames(nyu.sentiment), freq = colSums(nyu.sentiment))
  columbia.review.sentiment.sums <- data.frame(sentiment = colnames(columbia.sentiment), freq = colSums(columbia.sentiment))

  #Combine them in a dataframe for comparison
  review.comparison.df <- rbind(nyu.review.sentiment.sums, columbia.review.sentiment.sums)
  nyu <- rep("nyu",10)
  columbia <- rep("columbia",10)
  schools <- c(nyu, columbia)
  review.comparison.df$school <- schools
  
  return(review.comparison.df)
  
}
























