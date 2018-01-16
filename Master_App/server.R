library(ggplot2)
library(wordcloud)

source("scripts/yelp/Yelp_API.R")
source("scripts/yelp/Yelp_Wordclouds.R")
source("scripts/yelp/Yelp_Sentiment.R")
source("scripts/twitter/Twitter_Wordclouds.R")
source("scripts/twitter/Twitter_Sentiment.R")
source("scripts/twitter/Twitter_Users.R")


function(input, output, session) {
  
  ###################################
  #Function to plot review statistics
  retrieve_review_stats <- reactive({
    # Change when the "update" button is pressed...
    input$update.review.stats
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Calling API...")
        review.stats <- getReviewStats()
        return(review.stats)
      })
    })
  })
    
  output$review.stats1 <- renderPlot({
    rating.df <- retrieve_review_stats()[[1]]
    rating.plot <- ggplot(rating.df, aes(x=school, y=rating), fill=school) + geom_bar(stat="identity", fill=c("#4F628E", "#9775AA")) 
    last_plot() + labs(x="School", y="Average Stars")
  })
    
  output$review.stats2 <- renderPlot({
    count.df <- retrieve_review_stats()[[2]]
    count.plot <- ggplot(count.df, aes(x=school, y=count), fill=school) + geom_bar(stat="identity", fill=c("#4F628E", "#9775AA")) 
    last_plot() + labs(x="School", y="Count")
  })
  ###################################
    
  ###################################
  #Function to scrape Yelp reviews for wordclouds
  review_words <- reactive({
    # Change when the "update" button is pressed...
    input$update.review.words
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Scraping Reviews...")
        nyu.reviews <- getNYUYelpWords(input$review.words.pages)
        columbia.reviews <- getColumbiaYelpWords(input$review.words.pages)
        return(list(nyu.reviews, columbia.reviews))
      })
    })
  })
  
  output$review.words1 <- renderPlot({
    nyu.words <- review_words()[[1]]
    wordcloud(nyu.words, scale=c(3.5, .35), max.words=50, random.order = F, colors = brewer.pal(9, "Purples"))
  })
  
  output$review.words2 <- renderPlot({
    columbia.words <- review_words()[[2]]
    wordcloud(columbia.words, scale=c(3.5, .35), max.words=50, random.order = F, colors = brewer.pal(6, "Blues"))
  })
  ####################################
  
  ####################################
  #Function to scrape Yelp reviews for sentiment
  yelp.sentiment <- reactive({
    # Change when the "update" button is pressed...
    input$update.review.sentiment
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Scraping Reviews...")
        df <- getSentiment(input$review.sentiment.pages)
        return(df)
      })
    })
  })
  
  output$review.sentiment <- renderPlot({
    df <- yelp.sentiment()
    ggplot(df, aes(x=sentiment, y=freq, fill=school)) + geom_bar(stat="identity", position=position_dodge()) + scale_fill_manual(values = c("#4F628E", "#9775AA")) + labs(x="Sentiment",y="Count") 
  })
  #####################################
  
  #####################################
  #Function to search tweets and return corpus for wordclouds
  tweet.words <- reactive({
    # Change when the "update" button is pressed...
    input$update.twitter.words
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing tweets...")
        nyu <- getNYUCorpus(input$max.twitter.words)
        columbia <- getColumbiaCorpus(input$max.twitter.words)
        return(list(nyu, columbia))
      })
    })
  })
  
  output$twitter.wordcloud.nyu <- renderPlot({
    nyu <- tweet.words()[[1]]
    wordcloud(nyu, scale=c(3.5, .35), max.words=50, random.order = F, colors = brewer.pal(6, "Purples"))
  })
  
  output$twitter.wordcloud.columbia <- renderPlot({
    columbia <- tweet.words()[[2]]
    wordcloud(columbia, scale=c(3.5, .35), max.words = 50, random.order = F, colors = brewer.pal(6, "Blues"))
  })
  ######################################
  
  ######################################
  #Function to extract Twitter words for sentiment analysis
  twitter.sentiment <- reactive({
    # Change when the "update" button is pressed...
    input$update.twitter.sentiment
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Retrieving Tweets...")
        df <- getTweetSentiment(input$max.twitter.sentiment)
        return(df)
      })
    })
  })
  
  output$twitter.sentiment <- renderPlot({
    df <- twitter.sentiment()
    ggplot(df, aes(x=sentiment, y=freq, fill=school)) + geom_bar(stat="identity", position=position_dodge()) + scale_fill_manual(values = c("#4F628E", "#9775AA")) + labs(x="Sentiment",y="Count") 
  })
  ######################################
  
  ######################################
  #Function to extract most active users tweeting about each school
  twitter.users <- reactive({
    # Change when the "update" button is pressed...
    input$update.twitter.users
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Retrieving Tweets...")
        nyu <- getNYUUsers(input$max.twitter.users)
        columbia <- getColumbiaUsers(input$max.twitter.users)
        return(list(nyu, columbia))
      })
    })
  })
  
  output$users.nyu <- DT::renderDataTable({
    DT::datatable(twitter.users()[[1]])
  })
  
  output$users.columbia <- DT::renderDataTable({
    DT::datatable(twitter.users()[[2]])
  })
  #######################################

}

  
  
  
  
  
  