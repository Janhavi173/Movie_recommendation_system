install.packages("recommenderlab")
library(recommenderlab)

#load the data
data("MovieLense")

##Look at the data structure
str(MovieLense)
slotNames(MovieLense)
str(as(MovieLense, "data.frame"))

#examine records
head(as(MovieLense, "data.frame"))

recommenderRegistry$get_entries(dataType = "realRatingMatrix" )

#Collaborative Filtering model
evls <- evaluationScheme(MovieLense , method="split" ,train = 0.9 , given= 12);
evls

trg <- getData(evls , "train")
trg

test_known <- getData(evls , "known");
test_known

test_unknown <- getData(evls , "unknown");
test_unknown

#Create UBCF recommender model with the training data
rcmnd_ub<- Recommender(trg , "UBCF")

pred_ub <- predict (rcmnd_ub , test_known , type= "ratings");
pred_ub

#Evaluate model accuracy
acc_ub <- calcPredictionAccuracy(pred_ub , test_unknown)
as(acc_ub , "matrix")

#Compare
as(test_unknown , "matrix") [1:8,1:5] #eight records and five values
as(pred_ub , "matrix") [1:8 , 1:5]

#Repeat the process for IBCF
rcmnd_ib <- Recommender(trg, "IBCF")
pred_ib <- predict(rcmnd_ib, test_known , type="ratings")
pred_ib
acc_ib <-calcPredictionAccuracy(pred_ib , test_unknown)
acc <- rbind(UBCF = acc_ub , IBCF = acc_ib);
acc

#Get Top recommendations
pred_ub_top <- predict(rcmnd_ub , test_known);
pred_ub_top

movies <- as(pred_ub_top , "list")
movies[1]
