
require('pROC')
require('EMCluster')

auc.Gr <- rep(0, 9)
auc.gmm <- rep(0, 9)
cnt <- 0

for(d in c(2,5,10)){
  for(id in 1:3){
    cnt <- cnt + 1
    name <- paste0('d', d, '_i', id)
    grInfo <- read.csv(file = paste0('synthetic/GT_', name, '.csv'), header = F)
    GTlabel <- as.factor(grInfo$V1==0)
    ROC.groupedGMM <- roc(GTlabel, grInfo$V2)
    auc.Gr[cnt] <- ROC.groupedGMM$auc
    X <- read.csv(paste0('synthetic/syn_', name, '.csv'), header = T)
    
    emobj <- simple.init(x = X[,-1], nclass = 3)
    emobj <- emcluster(x = X[ ,-1], emobj = emobj)
    
    score <- dmixmvn(X[,-1], emobj)
    gScore <- rep(0, length(grInfo$V1))
    for(g in 1:length(grInfo$V1)){
      gScore[g] <- mean(score[which(X$gid == g)])
    }
    ROC.GMM <- roc(GTlabel, gScore)
    auc.gmm[cnt] <- ROC.GMM$auc
  }
}

result <- cbind(groupGMM=auc.Gr, GMM=auc.gmm)
write.csv(result, 'auc.csv', row.names = F, quote = F)

