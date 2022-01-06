setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")

library(sandwich)
library(lmtest)
library(MASS)
library(emmeans)

options(show.signif.stars=F)


DATA <- read.csv("allrepsv2.csv")
dim(DATA)
#  [1] 1306    8

any(is.na(DATA)) # resolves to FALSE ... no missing data

names(DATA)
#  [1] "rep"     "n.a1"    "n.t1"    "n.t2"    "n.tm"    "trt"     "fid"    
#  [8] "gfp.lab"

with(DATA, table(fid, trt, rep) )
#  , , rep = 1
#  
#     trt
#  fid Control Infected
#    1      28       62
#    2       9       77
#    3      60       82
#    4       6      152
#    5      21       90
#    6       4        0
#  
#  , , rep = 2
#  
#     trt
#  fid Control Infected
#    1      18       41
#    2      26       49
#    3       9       39
#    4      18       48
#    5      11       88
#    6       0       62
#  
#  , , rep = 3
#  
#     trt
#  fid Control Infected
#    1      10      105
#    2       7       30
#    3       5       60
#    4      11       33
#    5      16       29
#    6       0        0


ufish <- data.matrix( DATA[,c("rep","trt","fid")] )  # will make 1=Control, 2=Infected
ufish <- apply(ufish, 1, paste, sep="", collapse="/")
#  length(unique(ufish))   # n=32 fish
table(ufish)
#:: ufish
#:: 1/1/1 1/1/2 1/1/3 1/1/4 1/1/5 1/1/6 1/2/1 1/2/2 1/2/3 1/2/4 1/2/5 2/1/1 2/1/2 
#::    28     9    60     6    21     4    62    77    82   152    90    18    26 
#:: 2/1/3 2/1/4 2/1/5 2/2/1 2/2/2 2/2/3 2/2/4 2/2/5 2/2/6 3/1/1 3/1/2 3/1/3 3/1/4 
#::     9    18    11    41    49    39    48    88    62    10     7     5    11 
#:: 3/1/5 3/2/1 3/2/2 3/2/3 3/2/4 3/2/5 
#::    16   105    30    60    33    29 

n.ufish <- as.numeric(as.factor(ufish))
#   table(ufish, n.ufish)  # it's diagonal 

DATA$ufish <- as.factor(ufish)
DATA$n.ufish <- n.ufish
rm(ufish, n.ufish)

( n <- length(unique(DATA$ufish))  )

KEEP <- c("DATA","KEEP","tmp","n") ; KEEP <- sort(unique(KEEP))

tmp <- DATA
tmp <- tmp[order(tmp$n.ufish, tmp$gfp.lab), ] ; rownames(tmp) <- NULL
tmp$frep <- as.factor(tmp$rep)
tmp$fgfp <- factor(tmp$gfp.lab, levels=c(0,1), labels=c("GFPneg","GFPpos"))

tmp$ugrp <- apply(tmp[,c("trt","gfp.lab")], 1, paste, sep="", collapse=":")



########    N.tm
f1 <- lm( log(n.tm) ~ trt*fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) # no trt:gfp interaction (p=0.720)

f2 <- lm( log(n.tm) ~ trt + fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f2, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f2$coef)
coeftest(f2, vcov=V, df=dfe)
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.733888   0.060511 111.2828 < 2.2e-16
#:: trtInfected   -0.229688   0.079733  -2.8807  0.007681
#:: fgfpGFPpos    -0.149960   0.044966  -3.3350  0.002490

exp(f2$coef)
exp(coefci(f2, vcov=V, df=dfe) )
#:: > exp(f2$coef)
#::   (Intercept)   trtInfected    fgfpGFPpos
#::   840.4080116     0.7947816     0.8607426
#:: > exp(coefci(f2, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   742.2812563 951.5067503
#:: trtInfected     0.6748354   0.9360472
#:: fgfpGFPpos      0.7848819   0.9439355

b <- cbind(f2$coef)
K <- rbind( c(1, 0, 0, 0, 0),
            c(1, 0, 1, 0, 0),
            c(1, 1, 0, 0, 0), 
            c(1, 1, 1, 0, 0) )
rownames(K) <- c("Con:GFP-", "Con:GFP+", "Infected:GFP-", "Infected:GFP+")
se <- sqrt(diag( K%*%V%*%t(K) ) ) 
eff <- K%*%b 
eci <- cbind( eff, eff-qt(0.975, dfe)*se, eff+qt(0.975,dfe)*se ) 
round(exp(eci),1)
#::                [,1]  [,2]  [,3]
#:: Con:GFP-      840.4 742.3 951.5
#:: Con:GFP+      723.4 614.8 851.2
#:: Infected:GFP- 667.9 609.5 732.0
#:: Infected:GFP+ 574.9 540.2 611.9

# 
# f3 <- lm( log(n.tm) ~ trt + fgfp + frep,  data=tmp)
# V  <- vcovCL(f3, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
# dfe <- n - length(f3$coef)
# emmeans(f3, "fgfp", by="trt", trans="log", type="response", vcov=V, df=dfe)
# 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



##########    N.t1
f1 <- lm( log(n.t1) ~ trt*fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) # no trt:gfp interaction (p=0.191)

f2 <- lm( log(n.t1) ~ trt + fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f2, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f2$coef)
coeftest(f2, vcov=V, df=dfe)
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)    5.954570   0.075885 78.4680 < 2.2e-16
#:: trtInfected   -0.350580   0.109105 -3.2132 0.0033855
#:: fgfpGFPpos    -0.252964   0.060871 -4.1557 0.0002928

exp(f2$coef)
exp(coefci(f2, vcov=V, df=dfe) )
#:: > exp(f2$coef)
#::   (Intercept)   trtInfected    fgfpGFPpos
#::   385.5109526     0.7042796     0.7764959
#:: > exp(coefci(f2, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   329.9251574 450.4618433
#:: trtInfected     0.5630169   0.8809857
#:: fgfpGFPpos      0.6853259   0.8797944

b <- cbind(f2$coef)
K <- rbind( c(1, 0, 0, 0, 0),
            c(1, 0, 1, 0, 0),
            c(1, 1, 0, 0, 0), 
            c(1, 1, 1, 0, 0) )
rownames(K) <- c("Con:GFP-", "Con:GFP+", "Infected:GFP-", "Infected:GFP+")
se <- sqrt(diag( K%*%V%*%t(K) ) ) 
eff <- K%*%b 
eci <- cbind( eff, eff-qt(0.975, dfe)*se, eff+qt(0.975,dfe)*se ) 
round(exp(eci),1)
#::                [,1]  [,2]  [,3]
#:: Con:GFP-      385.5 329.9 450.5
#:: Con:GFP+      299.3 237.3 377.6
#:: Infected:GFP- 271.5 243.5 302.8
#:: Infected:GFP+ 210.8 194.2 228.9

# 
#  f3 <- lm( log(n.t1) ~ trt + fgfp + frep,  data=tmp)
#  V  <- vcovCL(f3, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  emmeans(f3, "fgfp", by="trt", trans="log", type="response", vcov=V, df=dfe)
# 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



##########    N.t2
f1 <- lm( log(n.t2) ~ trt*fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) # no trt:gfp interaction (p=0.750)


f2 <- lm( log(n.t2) ~ trt + fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f2, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f2$coef)
coeftest(f2, vcov=V, df=dfe)
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.790277   0.025773 302.2667 < 2.2e-16
#:: trtInfected   -0.206424   0.036211  -5.7007 4.672e-06
#:: fgfpGFPpos    -0.099820   0.012936  -7.7163 2.678e-08

exp(f2$coef)
exp(coefci(f2, vcov=V, df=dfe) )
#:: > exp(f2$coef)
#::   (Intercept)   trtInfected    fgfpGFPpos
#::  2416.9869649     0.8134881     0.9050006
#:: > exp(coefci(f2, vcov=V, df=dfe) )
#::                      2.5 %       97.5 %
#:: (Intercept)   2292.4936951 2548.2408091
#:: trtInfected      0.7552384    0.8762306
#:: fgfpGFPpos       0.8812952    0.9293437

b <- cbind(f2$coef)
K <- rbind( c(1, 0, 0, 0, 0),
            c(1, 0, 1, 0, 0),
            c(1, 1, 0, 0, 0), 
            c(1, 1, 1, 0, 0) )
rownames(K) <- c("Con:GFP-", "Con:GFP+", "Infected:GFP-", "Infected:GFP+")
se <- sqrt(diag( K%*%V%*%t(K) ) ) 
eff <- K%*%b 
eci <- cbind( eff, eff-qt(0.975, dfe)*se, eff+qt(0.975,dfe)*se ) 
round(exp(eci),1)
#::                 [,1]   [,2]   [,3]
#:: Con:GFP-      2417.0 2292.5 2548.2
#:: Con:GFP+      2187.4 2060.0 2322.6
#:: Infected:GFP- 1966.2 1872.8 2064.3
#:: Infected:GFP+ 1779.4 1711.2 1850.3

# 
#  f3 <- lm( log(n.t2) ~ trt + fgfp + frep,  data=tmp)
#  V  <- vcovCL(f3, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  emmeans(f3, "fgfp", by="trt", trans="log", type="response", vcov=V, df=dfe)
# 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



##########    N.a1
f1 <- lm( log(n.a1) ~ trt*fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f1, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) # no trt:gfp interaction (p=0.394)


f2 <- lm( log(n.a1) ~ trt + fgfp + C(frep, sum),  data=tmp)
V  <- vcovCL(f2, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f2$coef)
coeftest(f2, vcov=V, df=dfe)
#::  t test of coefficients:
#::  
#::                  Estimate Std. Error  t value Pr(>|t|)
#::  (Intercept)    4.2943101  0.0116002 370.1933  < 2e-16
#::  trtInfected    0.0289238  0.0145237   1.9915  0.05663
#::  fgfpGFPpos     0.0109716  0.0092436   1.1869  0.24559

exp(f2$coef)
exp(coefci(f2, vcov=V, df=dfe) )
#:: > exp(f2$coef)
#::   (Intercept)   trtInfected    fgfpGFPpos
#::    73.2816417     1.0293461     1.0110320
#:: > exp(coefci(f2, vcov=V, df=dfe) )
#::                    2.5 %    97.5 %
#:: (Intercept)   71.5580146 75.046786
#:: trtInfected    0.9991239  1.060482
#:: fgfpGFPpos     0.9920371  1.030391

b <- cbind(f2$coef)
K <- rbind( c(1, 0, 0, 0, 0),
            c(1, 0, 1, 0, 0),
            c(1, 1, 0, 0, 0), 
            c(1, 1, 1, 0, 0) )
rownames(K) <- c("Con:GFP-", "Con:GFP+", "Infected:GFP-", "Infected:GFP+")
se <- sqrt(diag( K%*%V%*%t(K) ) ) 
eff <- K%*%b 
eci <- cbind( eff, eff-qt(0.975, dfe)*se, eff+qt(0.975,dfe)*se ) 
round(exp(eci),1)
#::                 [,1] [,2] [,3]
#::   Con:GFP-      73.3 71.6 75.0
#::   Con:GFP+      74.1 72.0 76.3
#::   Infected:GFP- 75.4 74.2 76.7
#::   Infected:GFP+ 76.3 75.2 77.3

# 
#  f3 <- lm( log(n.a1) ~ trt + fgfp + frep,  data=tmp)
#  V  <- vcovCL(f3, cluster = ~ n.ufish, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  emmeans(f3, "fgfp", by="trt", trans="log", type="response", vcov=V, df=dfe)
# 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



