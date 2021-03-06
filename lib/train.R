
library(gbm)
library(caret)
library(DMwR)
library(nnet)
library(randomForest)
library(e1071)

############ gbm ######################

train.baseline=function(train.data)
{
  gbm1=gbm(y~.,data=train.data,dist="adaboost",n.tree = 400,shrinkage=0.1)
  n=gbm.perf(gbm1)

  return(list(gbm=gbm1,n=n))
}

############ BP network ######################
train.bp<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.nnet <- nnet(y ~ ., data = traindata, linout = F,
                     size = 1, decay = 0.01, maxit = 200,
                     trace = F, MaxNWts=6000)
  return(model.nnet)
}

############ Random Forest ######################
# First tune random forest model, tune parameter 'mtry'
train.rf<- function(traindata) {
  
  traindata$y<- as.factor(traindata$y)
  y.index<- which(colnames(traindata)=="y")
  bestmtry <- tuneRF(y= traindata$y, x= traindata[,-y.index], stepFactor=1.5, improve=1e-5, ntree=600)
  best.mtry <- bestmtry[,1][which.min(bestmtry[,2])]
  
  
  model.rf <- randomForest(y ~ ., data = traindata, ntree=600, mtry=best.mtry, importance=T)
  return(model.rf)
}

############ SVM ######################
train.svm<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.svm<- svm(y~., data = traindata,cost=100, gamma=0.01)
  return(model.svm)
}

############ Logistic ######################
train.log <- function(train_data){
  model.log <- glm(y~.,family = binomial(link="logit"),data=train_data)
  return(model.log)
}


