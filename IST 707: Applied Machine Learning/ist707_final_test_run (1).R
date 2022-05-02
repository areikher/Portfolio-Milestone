#imports the data into a dataframe
youtube <- read.csv("/Users/alison/Downloads/youtube_dislike_dataset.csv", na.strings = c(""))

#takes the relevant columns
youtube <- youtube[,c(2,4,5,6,7,8,9,10,11,12)]
#summary before data cleaning
summary(youtube)
#removes all the NA values
youtube <- na.omit(youtube) 
#summary of the results after data cleaning
summary(youtube)
#means for the numeric data
mean(youtube$likes)
mean(youtube$dislikes)
mean(youtube$view_count)

install.packages('SentimentAnalysis')
library(SentimentAnalysis)


#function that calculates the mode
calculate_mode <- function(x) {
  uniqx <- unique(na.omit(x))
  uniqx[which.max(tabulate(match(x, uniqx)))]
}
#finds the channel name that appears most frequently
calculate_mode(youtube$channel_title)
#the indexes of the channels with the name 'Sky Sports Football'
indexSky <- which(youtube$channel_title == 'Sky Sports Football')
#sums the number of likes for this channel
skyLikes <- sum(youtube$likes[indexSky])
#sums number of dislikes
skyDislikes <- sum(youtube$dislikes[indexSky])
#sums view cound
skyViews <- sum(youtube$view_count[indexSky])
#adds the likes and dislikes
(skyLikes + skyDislikes)
#view sum
skyViews
#ratio of likes and dislikes to views
(skyLikes + skyDislikes)/skyViews
#ration of likes to likes and dislikes
skyLikes/ (skyLikes + skyDislikes)

#most dislikes video
max(youtube$dislikes)
which(youtube$dislikes == 2397733)
youtube[13533,c(1,2)]

#most commented video
which(youtube$comment_count == 16071029)
youtube[26044,c(1,2)]

#collects the rows in which there are more dislikes than likes and put it into dataframe
moreDis <- which(youtube$dislikes > youtube$likes) 
dislikesDF <- data.frame(youtube[moreDis,])

#names of most disliked channels, Titles, and Comments
moredislikeChannel <- youtube[moreDis, 2]
moredislikeTitle <- youtube[moreDis, 1]
moredislikeComments <- youtube[moreDis, 10]

#sentiment analysis for the video titles
sentimentTitle <- analyzeSentiment(dislikesDF$title)
#convertToBinaryResponse(sentiment)$SentimentQDAP
sentimentTitle$SentimentQDAP
#converts sentiment into positive, negative, or neutral sentiment
sentTitle <- convertToDirection(sentimentTitle$SentimentQDAP)
#creates column wil these values
dislikesDF$TitleSentiment <- sentTitle

#sentiment analysis for comments
sentimentComments <- analyzeSentiment(dislikesDF$comments)
#convertToBinaryResponse(sentiment)$SentimentQDAP
sentimentComments$SentimentQDAP
sentComment <- convertToDirection(sentimentComments$SentimentQDAP)
dislikesDF$CommentSentiment <- sentComment

#sentiment analysis for tags
sentimentTags <- analyzeSentiment(dislikesDF$tags)
#convertToBinaryResponse(sentiment)$SentimentQDAP
sentimentTags$SentimentQDAP
sentTags <- convertToDirection(sentimentTags$SentimentQDAP)
dislikesDF$TagSentiment <- sentTags

#sentiment analysis for descriptions
sentimentDec <- analyzeSentiment(dislikesDF$description)
#convertToBinaryResponse(sentiment)$SentimentQDAP
sentimentDec$SentimentQDAP
sentDec <- convertToDirection(sentimentDec$SentimentQDAP)
dislikesDF$DescriptionSentiment <- sentDec

#most frequent channel in dislikesDF
calculate_mode(dislikesDF$channel_title)


library(tm)
#frequent words in titles
docs1 = Corpus(VectorSource(dislikesDF$title))
dtm1 = TermDocumentMatrix(docs1)
m1 = as.matrix(dtm1)
v1 = sort(rowSums(m1), decreasing = TRUE)
d1 = data.frame(word = names(v1), freq = v1)
head(d1, 10)

#frequent table for words in channel titles
docs2 = Corpus(VectorSource(dislikesDF$channel_title))
dtm2 = TermDocumentMatrix(docs2)
m2 = as.matrix(dtm2)
v2 = sort(rowSums(m2), decreasing = TRUE)
d2 = data.frame(word = names(v2), freq = v2)
head(d2, 10)

#tried removing stop words but the result wasn't that interesting
install.packages('qdap')
library(qdap)
#commentsNoStops <- dislikesDF$comments
#commentsNoStops <- dislikesDF[-c(1),10] 
#commentsNoStops <- stopwords(commentsNoStops)
#docs3 = Corpus(VectorSource(commentsNoStops))
#frequency tables for comments
docs3 = Corpus(VectorSource(dislikesDF$comments))
dtm3 = TermDocumentMatrix(docs3)
m3 = as.matrix(dtm3)
v3 = sort(rowSums(m3), decreasing = TRUE)
d3 = data.frame(word = names(v3), freq = v3)
head(d3, 10)

#frequency tables for tags
docs4 = Corpus(VectorSource(dislikesDF$tags))
dtm4 = TermDocumentMatrix(docs4)
m4 = as.matrix(dtm4)
v4 = sort(rowSums(m4), decreasing = TRUE)
d4 = data.frame(word = names(v4), freq = v4)
head(d4, 10)

#plots
plot(dislikesDF$TitleSentiment)
plot(dislikesDF$CommentSentiment)
plot(dislikesDF$TagSentiment)

#all four sentiments 
tripleNeg <- which(dislikesDF$TitleSentiment == 'negative' & dislikesDF$CommentSentiment == 'negative' & dislikesDF$TagSentiment == 'negative' & dislikesDF$DescriptionSentiment == 'negative')
dislikesDF[tripleNeg,1]

triplePos <- which(dislikesDF$TitleSentiment == 'postive' & dislikesDF$CommentSentiment == 'postive' & dislikesDF$TagSentiment == 'postive')
dislikesDF[triplePos,1]

tripleNeu <- which(dislikesDF$TitleSentiment == 'neutral' & dislikesDF$CommentSentiment == 'neutral' & dislikesDF$TagSentiment == 'neutral' & dislikesDF$DescriptionSentiment == 'neutral')
dislikesDF[tripleNeu,1]

#tables of the sentiment breakdowns
table(dislikesDF$TitleSentiment)
table(dislikesDF$CommentSentiment)
table(dislikesDF$TagSentiment)
table(dislikesDF$DescriptionSentiment)

library(ggplot2)

# create a dataset
variables <- c("Title", "Comment", "Tag","Description" )
sentiment <- c("Positive" , "Neutral" , "Negative")
value <- c(22, 5, 45, 83, 83, 28, 44, 30, 48, 117, 55, 37)
dataStack <- data.frame(variables,sentiment,value)

# Grouped
#plots the sentiment data by stack
ggplot(dataStack, aes(fill=sentiment, y=value, x=variables)) + 
  geom_bar(position="stack", stat="identity")


july2020 = 0
aug2020 = 0
sep2020 = 0
oct2020 = 0
nov2020 = 0
dec2020 = 0
jan2021 = 0
feb2021 = 0
mar2021 = 0
apr2021 = 0
may2021 = 0
jun2021 = 0
july2021 = 0
aug2021 = 0
sep2021 = 0
oct2021 = 0
nov2021 = 0
dec2021 = 0

LENjuly2020 = 0
LENaug2020 = 0
LENsep2020 = 0
LENoct2020 = 0
LENnov2020 = 0
LENdec2020 = 0
LENjan2021 = 0
LENfeb2021 = 0
LENmar2021 = 0
LENapr2021 = 0
LENmay2021 = 0
LENjun2021 = 0
LENjuly2021 = 0
LENaug2021 = 0
LENsep2021 = 0
LENoct2021 = 0
LENnov2021 = 0
LENdec2021 = 0

#counts the number of videos by month via loop
for (i in 1:nrow(youtube)) {
  if (grepl('2020-07',youtube$published_at[i])==TRUE){
    july2020 = july2020 + youtube$view_count[i]
    LENjuly2020 = LENjuly2020 + 1
  } else if(grepl('2020-08',youtube$published_at[i])==TRUE){
    aug2020 = aug2020 + youtube$view_count[i]
    LENaug2020 = LENaug2020 + 1
  } else if(grepl('2020-09',youtube$published_at[i])==TRUE){
    sep2020 = sep2020 + youtube$view_count[i]
    LENsep2020 = LENsep2020 + 1
  } else if(grepl('2020-10',youtube$published_at[i])==TRUE){
    oct2020 = oct2020 + youtube$view_count[i]
    LENoct2020 = LENoct2020 + 1
  } else if(grepl('2020-11',youtube$published_at[i])==TRUE){
    nov2020 = nov2020 + youtube$view_count[i]
    LENnov2020 = LENnov2020 + 1
  } else if(grepl('2020-12',youtube$published_at[i])==TRUE){
    dec2020 = dec2020 + youtube$view_count[i]
    LENdec2020 = LENdec2020 + 1
  } else if(grepl('2021-01',youtube$published_at[i])==TRUE){
    jan2021 = jan2021 + youtube$view_count[i]
    LENjan2021 = LENjan2021 + 1
  } else if(grepl('2021-02',youtube$published_at[i])==TRUE){
    feb2021 = feb2021 + youtube$view_count[i]
    LENfeb2021 = LENfeb2021 + 1
  } else if(grepl('2021-03',youtube$published_at[i])==TRUE){
    mar2021 = mar2021 + youtube$view_count[i]
    LENmar2021 = LENmar2021 + 1
  } else if(grepl('2021-04',youtube$published_at[i])==TRUE){
    apr2021 = apr2021 + youtube$view_count[i]
    LENapr2021 = LENapr2021 + 1
  } else if(grepl('2021-05',youtube$published_at[i])==TRUE){
    may2021 = may2021 + youtube$view_count[i]
    LENmay2021 = LENmay2021 + 1
  } else if(grepl('2021-06',youtube$published_at[i])==TRUE){
    jun2021 = jun2021 + youtube$view_count[i]
    LENjun2021 = LENjun2021 + 1
  } else if(grepl('2021-07',youtube$published_at[i])==TRUE){
    july2021 = july2021 + youtube$view_count[i]
    LENjuly2021 = LENjuly2021 + 1
  } else if(grepl('2021-08',youtube$published_at[i])==TRUE){
    aug2021 = aug2021 + youtube$view_count[i]
    LENaug2021 = LENaug2021 + 1
  } else if(grepl('2021-09',youtube$published_at[i])==TRUE){
    sep2021 = sep2021 + youtube$view_count[i]
    LENsep2021 = LENsep2021 + 1
  } else if(grepl('2021-10',youtube$published_at[i])==TRUE){
    oct2021 = oct2021 + youtube$view_count[i]
    LENoct2021 = LENoct2021 + 1
  } else if(grepl('2021-11',youtube$published_at[i])==TRUE){
    nov2021 = nov2021 + youtube$view_count[i]
    LENnov2021 = LENnov2021 + 1
  } else if(grepl('2021-12',youtube$published_at[i])==TRUE){
    dec2021 = dec2021 + youtube$view_count[i]
    LENdec2021 = LENdec2021 + 1
  }
}

july2020 <- sum(july2020)
aug2020 <- sum(aug2020)
sep2020 <- sum(sep2020)
oct2020 <- sum(oct2020)
nov2020 <- sum(nov2020)
dec2020 <- sum(dec2020)
jan2021 <- sum(jan2021)
feb2021 <- sum(feb2021)
mar2021 <- sum(mar2021)
apr2021 <- sum(apr2021)
may2021 <- sum(may2021)
jun2021 <- sum(jun2021)
july2021 <- sum(july2021)
aug2021 <- sum(aug2021)
sep2021 <- sum(sep2021)
oct2021 <- sum(oct2021)
nov2021 <- sum(nov2021)
dec2021 <- sum(dec2021)

months <- c(july2020, aug2020, sep2020, oct2020, nov2020, dec2020, jan2021, feb2021, 
            mar2021, apr2021, may2021, jun2021, july2021, aug2021, sep2021, oct2021,
            nov2021, dec2021)
#graphs the views per month
barplot(months, main = 'Views per month', names.arg=c("July 2020", "Aug 2020", "Sep 2020", 
                                                      'oct2020', 'nov2020', 'dec2020', 'jan2021', 'feb2021', 
                                                      'mar2021', 'apr2021', 'may2021', 'jun2021', 'july2021', 
                                                      'aug2021', 'sep2021', 'oct2021',
                                                      'nov2021', 'dec2021'), col = c('red','orange','yellow','green', 'blue', 'purple'))

#averages
july2020Ave <- july2020/LENjuly2020
aug2020Ave <- aug2020/LENaug2020
sep2020Ave <- sep2020/LENsep2020
oct2020Ave <- oct2020/LENoct2020
nov2020Ave <- nov2020/LENnov2020
dec2020Ave <- dec2020/LENdec2020
jan2021Ave <- jan2021/LENjan2021
feb2021Ave <- feb2021/LENfeb2021
mar2021Ave <- mar2021/LENmar2021
apr2021Ave <- apr2021/LENapr2021
may2021Ave <- may2021/LENmay2021
jun2021Ave <- jun2021/LENjun2021
july2021Ave <- july2021/LENjuly2021
aug2021Ave <- aug2021/LENaug2021
sep2021Ave <- sep2021/LENsep2021
oct2021Ave <- oct2021/LENoct2021
nov2021Ave <- nov2021/LENnov2021
dec2021Ave <- nov2021/LENnov2021

monthsAve <- c(july2020Ave, aug2020Ave, sep2020Ave, oct2020Ave, nov2020Ave, dec2020Ave, jan2021Ave, feb2021Ave, 
            mar2021Ave, apr2021Ave, may2021Ave, jun2021Ave, july2021Ave, aug2021Ave, sep2021Ave, oct2021Ave,
            nov2021Ave, dec2021Ave)
#graphs the averages
barplot(monthsAve, main = 'Average Views per month', names.arg=c("July 2020", "Aug 2020", "Sep 2020", 
                                                      'oct2020', 'nov2020', 'dec2020', 'jan2021', 'feb2021', 
                                                      'mar2021', 'apr2021', 'may2021', 'jun2021', 'july2021', 
                                                      'aug2021', 'sep2021', 'oct2021',
                                                      'nov2021', 'dec2021'), col = c('red','orange','yellow','green', 'blue', 'purple'))


#correlation matrix
#takes the columns for the correlation
corYouTube <- cor(youtube[,c(4,5,6,7)])
library(corrplot)
#heat map for correlation matrix
corrplot(corYouTube, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

#takes columns from the dislikes dataframe
corDislikes <- cor(dislikesDF[,c(4,5,6,7)])
#heat map for the correlation matrix
corrplot(corDislikes, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)


#creates column that shows the precent likes to total likes and dislikes
youtube$percertageLike <- youtube$likes/(youtube$likes+youtube$dislikes)
hist(youtube$percertageLike, col = 'blue')

#number of unique channel names
channels <- unique(youtube$channel_title)
length(channels)

#this is for inspect to work
detach(package:tm, unload=TRUE)

library(arules)
library(arulesViz)
library(datasets)

#creates a copy of the youtube DF and factors and discritizes for Apriori Method
youtubeApr <- youtube
youtubeApr <- youtubeApr[,c(1,2,3,4,5,6,7)]
youtubeApr$title <- factor(youtubeApr$title)
youtubeApr$channel_title <- factor(youtubeApr$channel_title)
youtubeApr <- discretizeDF(youtubeApr)
#transaction used in method
transactions <- as(youtubeApr, 'transactions')
#applies the apriori method to the transaction and parameters are set
rules_pep <- apriori(transactions, parameter = list(supp = 0.1, conf = 0.75))
rules_pep2 <- apriori(transactions, parameter = list(supp = 0.01, conf = 0.5), appearance = list(default="rhs",lhs="channel_title=Sky Sports Football"),control = list (verbose=F))
rules_pep3 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="dislikes=[3,404)"),control = list (verbose=F))
rules_pep8 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="dislikes=[1.63e+03,2.4e+06]"),control = list (verbose=F))
rules_pep4 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="likes=[22,2e+04)"),control = list (verbose=F))
rules_pep5 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="likes=[8.78e+04,3.18e+07]"),control = list (verbose=F))
rules_pep6 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="view_count=[2.04e+04,7.11e+05)"),control = list (verbose=F))
rules_pep7 <- apriori(transactions, parameter = list(supp = 0.02, conf = 0.7), appearance = list(default="rhs",lhs="view_count=[2.55e+06,1.32e+09]"),control = list (verbose=F))

#sorts by confidence
rules_pep <- sort(rules_pep, decreasing = TRUE, by = 'confidence')
rules_pep2 <- sort(rules_pep2, decreasing = TRUE, by = 'confidence')
rules_pep3 <- sort(rules_pep3, decreasing = TRUE, by = 'confidence')
rules_pep8 <- sort(rules_pep8, decreasing = TRUE, by = 'confidence')
rules_pep4 <- sort(rules_pep4, decreasing = TRUE, by = 'confidence')
rules_pep5 <- sort(rules_pep5, decreasing = TRUE, by = 'confidence')
rules_pep6 <- sort(rules_pep6, decreasing = TRUE, by = 'confidence')
rules_pep7 <- sort(rules_pep7, decreasing = TRUE, by = 'confidence')

#prints the rules
inspect(rules_pep)
inspect(rules_pep2)
inspect(rules_pep3)
inspect(rules_pep8)
inspect(rules_pep4)
inspect(rules_pep5)
inspect(rules_pep6)
inspect(rules_pep7)



