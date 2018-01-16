library(markdown)
library(shinythemes)
library(DT)

shinyUI(
  navbarPage(theme = shinytheme("cerulean"),"Social Listening - NYC Colleges",
             
             tabPanel("Overview",
                      
                       fluidRow(
                         column(12,
                                tags$h2(
                                  "Ever wondered what the best college in New York is?"
                                ),
                                br(),
                                tags$h4(
                                  "NYU and Columbia have been competing for centuries for the title of the New York King - but now, with social networks, we can see what people are saying about them. In real time." 
                                ),
                                br(),
                                tags$p(
                                  "This application uses Yelp and Twitter to compare NYU and Columbia across dimensions like reviews, commonly used words, and sentiment."
                                ),
                                tags$p(
                                  "For the Twitter tab, the back end will search for a given number of recent tweets and show you commonly used words, and overall sentiment. Information was retrieved using the Yelp API, the rvest package, and the twitteR package. Sentiment was analyzed using the trained model from the syuzhet package."
                                )     
                         )
                       )),
                        
             
             navbarMenu("Yelp",
                        
                        # Number 1 - review statistics
                        tabPanel("Review Statistics",
                                 titlePanel("Yelp Review Statistics"),
                                 sidebarLayout(
                                   # Sidebar with a slider and selection inputs
                                   sidebarPanel(
                                     actionButton("update.review.stats", "Update")
                                   ),
                                   
                                   mainPanel(
                                     fluidRow(
                                       column(6, tags$h4("Average Stars")), column(6,tags$h4("Review Count"))
                                     ),
                                     fluidRow(
                                       column(6, plotOutput("review.stats1")), column(6,plotOutput("review.stats2"))
                                     )
                                   )
                        )),
                        
                        # Number 2 - review words
                        tabPanel("Review Words",
                                 titlePanel("Yelp Review Words"),
                                 sidebarLayout(
                                   # Sidebar with a slider and selection inputs
                                   sidebarPanel(
                                     actionButton("update.review.words", "Update"),
                                     hr(),
                                     sliderInput("review.words.pages",
                                                 "Number of Pages",
                                                 min = 0,  max = 4, value = 1)
                                   ),
                                   
                                   mainPanel(
                                     fluidRow(
                                       column(6, tags$h4("NYU")), column(6,tags$h4("Columbia"))
                                     ),
                                     fluidRow(
                                       column(6, plotOutput("review.words1")), column(6,plotOutput("review.words2"))
                                     )
                                   )
                                 )),
                        
                        # Number 3 - review sentiment
                        tabPanel("Review Sentiment",
                                 titlePanel("Yelp Review Sentiment"),
                                 sidebarLayout(
                                   # Sidebar with a slider and selection inputs
                                   sidebarPanel(
                                     actionButton("update.review.sentiment", "Update"),
                                     hr(),
                                     sliderInput("review.sentiment.pages",
                                                 "Number of Pages",
                                                 min = 0,  max = 4, value = 1)
                                   ),
                                   
                                   mainPanel(
                                     fluidRow(
                                       column(6, tags$h4("Total Yelp Sentiment Values"))
                                     ),
                                     plotOutput("review.sentiment")
                                   )
                                 ))
                        ),
                        
              navbarMenu("Twitter",
                           
                         # Number 1 - twitter wordclouds
                         tabPanel("Twitter Words",
                                  titlePanel("Top Twitter Words"),
                                  
                                  sidebarLayout(
                                    # Sidebar with a slider and selection inputs
                                    sidebarPanel(
                                      actionButton("update.twitter.words", "Change"),
                                      hr(),
                                      sliderInput("max.twitter.words",
                                                  "Number of Tweets",
                                                  min = 0,  max = 500, value = 50)
                                    ),
                                    
                                    mainPanel(
                                      fluidRow(
                                        column(6, tags$h4("NYU")), column(6,tags$h4("Columbia"))
                                      ),
                                      fluidRow(
                                        splitLayout(cellWidths = c("50%", "50%"), plotOutput("twitter.wordcloud.nyu"), plotOutput("twitter.wordcloud.columbia"))
                                      )
                                    )
                                  )),
                         
                         #Number 2 - twitter users
                         tabPanel("Active Tweeters",
                                  titlePanel("Most Active Users Tweeting"),
                                  
                                  sidebarLayout(
                                    # Sidebar with a slider and selection inputs
                                    sidebarPanel(
                                      actionButton("update.twitter.users", "Change"),
                                      hr(),
                                      sliderInput("max.twitter.users",
                                                  "Number of Tweets",
                                                  min = 0,  max = 500, value = 50)
                                    ),
                                    
                                    mainPanel(
                                      fluidRow(
                                        column(6, tags$h4("NYU")), column(6,tags$h4("Columbia"))
                                      ),
                                      fluidRow(
                                        column(6, DT::dataTableOutput("users.nyu")), column(6,DT::dataTableOutput("users.columbia"))
                                      )
                                    )
                                  )),
                         
                         #Number 3 - twitter sentiment
                         tabPanel("Twitter Sentiment",
                                  titlePanel("Twitter Sentiments"),
                                  
                                  sidebarLayout(
                                    # Sidebar with a slider and selection inputs
                                    sidebarPanel(
                                      actionButton("update.twitter.sentiment", "Change"),
                                      hr(),
                                      sliderInput("max.twitter.sentiment",
                                                  "Number of Tweets",
                                                  min = 0,  max = 500, value = 50)
                                    ),
                                    
                                    mainPanel(
                                      fluidRow(
                                        column(6, tags$h4("Total Twitter Sentiment Values"))
                                      ),
                                      plotOutput("twitter.sentiment")
                                    )
                                  ))
                           
                         
                        )
             )
)
  