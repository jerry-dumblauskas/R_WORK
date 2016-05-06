library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
set.seed(125)
trainIndex = createDataPartition(segmentationOriginal$Case, p = 0.70,list=FALSE)
training = segmentationOriginal[trainIndex,]
testing = segmentationOriginal[-trainIndex,]
modFit <- train(Class ~ ., method="rpart", data=training)

print(modFit$finalModel)
plot(modFit$finalModel, uniform=TRUE, main="class tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE, cex=.8)

library(rattle)
fancyRpartPlot(modFit$finalModel)