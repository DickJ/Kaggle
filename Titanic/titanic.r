# Set working directory and import data files
setwd("~/Google Drive/Code/R/Kaggle/Titanic")
train <- read.csv("~/Google Drive/Code/R/Kaggle/Titanic/train.csv")
test <- read.csv("~/Google Drive/Code/R/Kaggle/Titanic/test.csv")

#Combine datasets
test$Survived <- 0
combi <- rbind(test, train)

#Fare cost buckets engineered variable (combi$Fare.Buckets)
combi$Fare.Buckets <- NA
combi$Fare.Buckets[combi$Fare >= 20 & combi$Fare < 30] <- "30+"
combi$Fare.Buckets[combi$Fare >= 10 & combi$Fare < 20] <- "20-30"
combi$Fare.Buckets[combi$Fare >= 10 & combi$Fare < 20] <- "10-20"
combi$Fare.Buckets[combi$Fare < 10] <- "<10"

#Titles engineered variable (combi$Title)
combi$Name <- as.character(combi$Name)
combi$Title <- sapply(combi$Name, function(x){strsplit(x, split='[.,]')[[1]][2]})
combi$Title <- sub(" ", "", combi$Title)
combi$Title[combi$Title %in% c("Mme", "Mlle")] <- "Mlle"
combi$Title[combi$Title %in% c("Capt", "Col", "Don", "Major", "Sir")] <- "Sir"
combi$Title[combi$Title %in% c("Dona", "Jonkheer", "Lady", "the Countess")] <- "Lady"
combi$Title <- factor(combi$Title)

#Deck engineered variable (combi$Deck)

#Fore-aft by room number engineered variable (combi$Room.Number)

#Family Id engineered variable (combi$Family.Id)

#Family members traveling with (combi$Family.Size)
combi$Family.Size <- NA
combi$Family.Size <- combi$SibSp + combi$Parch + 1 # '+1' is to include the individual

#Is a child engineered variable (combi$Is.Child)
combi$Is.Child <- 0
combi$Is.Child[combi$Age < 18] <- 1

# Correlation matrix
combi.complete.cases <- combi[complete.cases(combi[, c("Pclass", "Age", "SibSp", "Parch", "Fare")]), ]
cor(combi.complete.cases[, c("Pclass", "Age", "SibSp", "Parch", "Fare")])

# Create output file to submit to kaggle
filename = "file.csv"
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
write.csv(submit, file=filename, row.names=FALSE)