test1 <- rnorm(300,1)
test6 <- rnorm(1000,6)
test2 <- rnorm(200,2)

mean(c(mean(test1),mean(test2),mean(test6)))

gm<-mean(c(test1,test2,test6)); gm

test1_norm <- (test1-mean(test1))+gm
test2_norm <- (test2-mean(test2))+gm
test6_norm <- (test6-mean(test6))+gm

test1_norm
test2_norm
test6_norm

mean(c(test1_norm,test2_norm,test6_norm))
