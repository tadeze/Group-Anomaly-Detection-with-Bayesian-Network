
# read data
X <- read.csv(file = 'spectrum_s1.csv')
Xmean <- apply(X[ ,-1], 2, mean)
Xsd <- apply(X[ ,-1], 2, sd)

# normalize
Xnorm <- X
Xnorm[,-1] <- scale(X[,-1])

# apply pca
pcomp <- princomp(Xnorm[ ,-1])

vars <- pcomp$sdev^2
vars <- vars / sum(vars)
k <- 1
sum <- vars[k]
while(sum < 0.95){
  k <- k + 1
  sum <- sum + vars[k]
}

Xred <- Xnorm[,1:(k+1)]
Xred[ ,-1] <- as.matrix(Xnorm[ ,-1]) %*% pcomp$loadings[,1:k]

write.csv(Xred, 'spectrum_s1_norm_pca.csv', row.names = F, quote = F)
