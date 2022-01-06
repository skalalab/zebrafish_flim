

setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")

library(MASS)
library(sandwich)
library(lmtest)
library(beeswarm)
# library(emmeans)

options(show.signif.stars=F)

DATA <- read.csv("Infected_NoGFP_nof3.csv")
dim(DATA)
#  [1] 866  12

any(is.na(DATA) ) # FALSE ... no missing

names(DATA)
#  [1] "fid" "rep" "trt" "fa1" "ft1" "ft2" "ftm" "na1" "nt1" "nt2" "ntm" "rr"

DATA$frep <- as.factor(DATA$rep)

with(DATA, table(fid, trt, rep) )
#:: , , rep = 1
#:: 
#::    trt
#:: fid Control Infected
#::   1       6       73
#::   2       5       61
#::   3       1      100
#::   4       4      116
#::   5       2        0
#::   6       0        0
#:: 
#:: , , rep = 2
#:: 
#::    trt
#:: fid Control Infected
#::   1       6       53
#::   2       7       18
#::   3       4       25
#::   4       7       34
#::   5       5        0
#::   6       0        0
#:: 
#:: , , rep = 3
#:: 
#::    trt
#:: fid Control Infected
#::   1       8       59
#::   2       3       46
#::   3       6       52
#::   4      12       27
#::   5      18       44
#::   6      11       53

ufish <- data.matrix( DATA[,c("rep","trt","fid")] )  # will make 1=Control, 2=Infected
ufish <- apply(ufish, 1, paste, sep="", collapse="/")
#  length(unique(ufish))   # n=30 fish
table(ufish)
#:: ufish
#:: 1/1/1 1/1/2 1/1/3 1/1/4 1/1/5 1/2/1 1/2/2 1/2/3 1/2/4 2/1/1 2/1/2 2/1/3 2/1/4 
#::     6     5     1     4     2    73    61   100   116     6     7     4     7 
#:: 2/1/5 2/2/1 2/2/2 2/2/3 2/2/4 3/1/1 3/1/2 3/1/3 3/1/4 3/1/5 3/1/6 3/2/1 3/2/2 
#::     5    53    18    25    34     8     3     6    12    18    11    59    46 
#:: 3/2/3 3/2/4 3/2/5 3/2/6 
#::    52    27    44    53 

n.ufish <- as.numeric(as.factor(ufish))
#   table(ufish, n.ufish)  # it's diagonal 

DATA$ufish <- as.factor(ufish)
DATA$n.ufish <- n.ufish
rm(ufish, n.ufish)

(n <- length(unique(DATA$ufish) ) ) # 30 fish

KEEP <- c("KEEP", "DATA", "tmp", "wksp", "n") ; KEEP <- sort(unique(KEEP) ) ; 

#::::::::: N.tm
f1 <- lm( log(ntm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::    trtControl   trtInfected
#::   914.5184756   686.6937922
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                    2.5 %      97.5 %
#:: trtControl    842.733870 992.4177393
#:: trtInfected   608.444985 775.0057544


f1 <- lm( log(ntm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.818398   0.039769 171.4498 < 2.2e-16
#:: trtInfected   -0.286509   0.072679  -3.9421 0.0005436

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)   trtInfected
#::   914.5184756     0.7508802
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                    2.5 %      97.5 %
#:: (Intercept)   842.733870 992.4177393
#:: trtInfected     0.646681   0.8718689

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 


#::::::::: N.t1
f1 <- lm( log(nt1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::    trtControl   trtInfected
#::   377.1614237   275.2352063
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %      97.5 %
#:: trtControl    338.9324491 419.7023327
#:: trtInfected   234.8646203 322.5450418


f1 <- lm( log(nt1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    5.932673   0.051993 114.1060 < 2.2e-16
#:: trtInfected   -0.315047   0.100977  -3.1200  0.004390

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)   trtInfected
#::   377.1614237     0.7297544
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   338.9324491 419.7023327
#:: trtInfected     0.5929713   0.8980898

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 

#::::::::: N.t2
f1 <- lm( log(nt2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::    trtControl   trtInfected
#::  2696.5355217  2335.4171621
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                      2.5 %       97.5 %
#:: trtControl    2556.4117361 2844.3398678
#:: trtInfected   2219.4098839 2457.4880739


f1 <- lm( log(nt2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.899723   0.025961 304.2942 < 2.2e-16
#:: trtInfected   -0.143777   0.036867  -3.8999 0.0006067

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)   trtInfected
#::  2696.5355217     0.8660806
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                      2.5 %       97.5 %
#:: (Intercept)   2556.4117361 2844.3398678
#:: trtInfected      0.8028730    0.9342643

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 



#::::::::: N.a1
f1 <- lm( na1 ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::    trtControl   trtInfected
#::    75.3637233    78.8283794
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %    97.5 %
#:: trtControl    73.9198094 76.807637
#:: trtInfected   77.4511021 80.205657

f1 <- lm( na1 ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::               Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)   75.36372    0.70245 107.2864 < 2.2e-16
#:: trtInfected    3.46466    0.92784   3.7341 0.0009317

f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   (Intercept)   trtInfected
#::    75.3637233     3.4646561
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %    97.5 %
#:: (Intercept)   73.9198094 76.807637
#:: trtInfected    1.5574467  5.371865

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 



#::::::::: F.tm
f1 <- lm( log(ftm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::    trtControl   trtInfected
#::   480.9990285   407.8291314
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: trtControl    392.2732157 589.7931752
#:: trtInfected   355.4864443 467.8788828

f1 <- lm( log(ftm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)    6.175865   0.099199 62.2573 < 2.2e-16
#:: trtInfected   -0.165017   0.122595 -1.3460 0.1899107

exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::   (Intercept)   trtInfected
#::   480.9990285     0.8478793
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   392.2732157 589.7931752
#:: trtInfected     0.6590117   1.0908750

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 



#::::::::: F.t1
f1 <- lm( log(ft1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::    trtControl   trtInfected
#::   246.5654157   189.7111960
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: trtControl    187.3661052 324.4690609
#:: trtInfected   160.3037925 224.5133277

f1 <- lm( log(ft1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)    5.507627   0.133573 41.2331 < 2.2e-16
#:: trtInfected   -0.262124   0.162834 -1.6098  0.119526

exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::   (Intercept)   trtInfected
#::   246.5654157     0.7694153
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   187.3661052 324.4690609
#:: trtInfected     0.5505513   1.0752855

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 


#::::::::: F.t2
f1 <- lm( log(ft2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::    trtControl   trtInfected
#::  1681.9180061  1525.2311611
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                      2.5 %      97.5 %
#:: trtControl    1536.2876013 1841.353258
#:: trtInfected   1432.7353637 1623.698384

f1 <- lm( log(ft2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.427690   0.044060 168.5825 < 2.2e-16
#:: trtInfected   -0.097789   0.055260  -1.7696 0.0885188

exp( f1$coef )
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp( f1$coef )
#::   (Intercept)   trtInfected
#::  1681.9180061     0.9068404
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                      2.5 %      97.5 %
#:: (Intercept)   1536.2876013 1841.353258
#:: trtInfected      0.8094691    1.015925

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 


####### F.a1
f1 <- lm( fa1 ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::    trtControl   trtInfected
#::     78.488173     79.328129
#:: > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %     97.5 %
#:: trtControl    76.06959906 80.9067467
#:: trtInfected   77.85006308 80.8061945

f1 <- lm( fa1 ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::               Estimate Std. Error t value Pr(>|t|)
#:: (Intercept)   78.48817    1.17662 66.7066  < 2e-16
#:: trtInfected    0.83996    1.39228  0.6033  0.55154

f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   (Intercept)   trtInfected
#::    78.4881729     0.8399559
#:: > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %     97.5 %
#:: (Intercept)   76.06959906 80.9067467
#:: trtInfected   -2.02192502  3.7018369

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 



####### Redox Ratio
f1 <- lm( rr ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::    trtControl   trtInfected
#::    0.72481836    0.64993333
#:: > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %     97.5 %
#:: trtControl     0.70764143  0.7419953
#:: trtInfected    0.63853428  0.6613324

f1 <- lm( rr ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    0.7248184  0.0083565  86.7376 < 2.2e-16
#:: trtInfected   -0.0748850  0.0100325  -7.4643 6.327e-08

f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   (Intercept)   trtInfected
#::    0.72481836   -0.07488503
#:: > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %      97.5 %
#:: (Intercept)    0.70764143  0.74199529
#:: trtInfected   -0.09550711 -0.05426295

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok] ) ; 

#~~~~~~~~~~~~~~~~ OMI experiments

remove(list=ls())

DATA <- read.csv("OMIindex_infection.csv") 


KEEP <- c("KEEP","DATA","tmp","wksp"); KEEP <- sort(unique(KEEP))

tmp <- DATA


tmp$trt <- factor(tmp$trt, levels=c("Control","Infected"), labels=c("con","infect"))

ufish <- apply(tmp[,c("rep","fid","trt")], 1, paste, sep="", collapse="/")
ufish <- as.numeric(as.factor(ufish))

tmp$ufish <- ufish
tmp <- tmp[order(tmp$ufish, tmp$omi),] ; rownames(tmp) <- NULL
tmp$f.rep <- as.factor(tmp$rep)

range(tmp$omi) # -1.535 to 3.591
r <- 1.55

tmp$y <- ( tmp$omi + r ) # make everything positive

# Gamma fits, but with identity link so we can undo the additive shift
f1 <- glm( y  ~ 0 + f.rep/trt, data=tmp, family=quasi(link="identity", variance="mu^2")  )

dfe <- length(unique(tmp$ufish)) - length(f1$coef) 
b <- cbind(f1$coef)
V <- vcovCL(f1, cluster=~ufish, type="HC3")

# average treatment effect
ok <- grep(pattern=":trtinfect", x=rownames(b) )
K <- matrix(0, nrow=1, ncol=length(b))
K[ok] <- 1/length(ok)
se <- sqrt( diag( K%*%V%*%t(K) ) )
( est <- round( as.numeric( K%*%b ), 3) ) ; 
round( est + qt( c(0.025, 0.975), dfe)*se, 3 ) ; 
2*pt(-abs(est)/se, dfe) 
#:: 
#:: > ( est <- round( as.numeric( K%*%b ), 3) ) ; 
#:: [1] -0.334
#:: > round( est + qt( c(0.025, 0.975), dfe)*se, 3 ) ; 
#:: [1] -0.549 -0.119
#:: > 2*pt(-abs(est)/se, dfe) 
#:: [1] 0.003766754
#:: 


# means, for comparison
f1 <- glm( y ~ 0 + trt/C(f.rep, sum), data=tmp,
               family=quasi(link="identity", variance="mu^2") )
V <- vcovCL(f1, cluster=~ufish, type="HC3")
# subtract off the amount used to shift all values positive
f1$coef[1:2] - r
coefci(   f1, vcov=V, df=dfe )[1:2,] - r
#:: 
#:: > f1$coef[1:2] - r
#::    trtcon trtinfect 
#:: 1.2811665 0.9467495 
#:: > coefci(   f1, vcov=V, df=dfe )[1:2,] - r
#::               2.5 %   97.5 %
#:: trtcon    1.1010556 1.461277
#:: trtinfect 0.8295588 1.063940
#:: 
