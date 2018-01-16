library(rvest)
library(tm)

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

#Function to make into a corpus and clean up.

to_corpus <- function(list) {
  
  corp <- VCorpus(VectorSource(list))
  
  corp.clean <- tm_map(corp, removePunctuation)
  corp.clean <- tm_map(corp.clean, content_transformer(tolower))
  corp.clean <- tm_map(corp.clean, removeWords, stopwords("english"))
  corp.clean <- tm_map(corp.clean, removeWords, c("nyu", "columbia","university","college","school"))
  corp.clean <- tm_map(corp.clean, stripWhitespace)
  
  return(corp.clean)
  
}

#Master function to be called in server.R

getNYUYelpWords <- function(pages) {
  
  nyu.links <- get_yelp_links(pages, "https://www.yelp.com/biz/new-york-university-new-york-18?start=")
  nyu.reviews <- scrape_yelp_reviews(nyu.links)
  nyu.corpus <- to_corpus(nyu.reviews)
  
  return(nyu.corpus)
}

getColumbiaYelpWords <- function(pages) {
  
  columbia.links <- get_yelp_links(pages, "https://www.yelp.com/biz/columbia-university-new-york-43?start=")
  columbia.reviews <- scrape_yelp_reviews(columbia.links)
  columbia.corpus <- to_corpus(columbia.reviews)
  
  return(columbia.corpus)
}


















