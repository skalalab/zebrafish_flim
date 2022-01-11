

setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")

library(MASS)
library(sandwich)
library(lmtest)
library(beeswarm)
library(emmeans)

options(show.signif.stars=F)

KEEP <- c("KEEP","DATA","tmp","wksp","n")
KEEP <- sort(unique(KEEP) ) ; 

DATA <- read.csv("Metformin_burn_nof3.csv") # 1302 x 12

names(DATA)
#  [1] "fa1" "ft1" "ft2" "ftm" "na1" "nt1" "nt2" "ntm" "rr"  "trt" "fid" "rep"

DATA$trt <- as.factor(DATA$trt)  # CON as reference, MET is the other level


DATA <- DATA[order(DATA$rep, DATA$trt, DATA$fid),]
rownames(DATA) <- NULL

nuid <- apply(DATA[,c("rep", "trt", "fid")], 1, paste, sep="", collapse="/") 

DATA$nuid <- as.numeric( as.factor(nuid) ) ; rm(nuid)  # n=27 unique fish larvae

DATA$frep <- as.factor(DATA$rep)

(n <- length(unique(DATA$nuid) ) ) ; KEEP <- c(KEEP, "n") ; KEEP <- sort(unique(KEEP)) 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 


#::::::::: Ntm
f1 <- lm( log(ntm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: 
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::       817.000       840.000
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                 2.5 %  97.5 %
#:: trtCON        778.000 857.000
#:: trtMET        810.000 872.000


f1 <- lm( log(ntm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.705032   0.023130 289.8854 < 2.2e-16
#:: trtMET         0.028723   0.028350   1.0132 0.3215267

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::   816.5044411     1.0291396
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   778.3563218 856.5222426
#:: trtMET          0.9705196   1.0913002

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Nt1
f1 <- lm( log(nt1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::       315.000       348.000
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                 2.5 %  97.5 %
#:: trtCON        305.000 326.000
#:: trtMET        340.000 357.000


f1 <- lm( log(nt1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    5.754058   0.015786 364.5123 < 2.2e-16
#:: trtMET         0.098896   0.019789   4.9975 4.693e-05

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::   315.4681240     1.1039518
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   305.3328732 325.9398054
#:: trtMET          1.0596718   1.1500822

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 


#::::::::: Nt2
f1 <- lm( log(nt2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::      2480.000      2610.000
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                  2.5 %   97.5 %
#:: trtCON        2440.000 2530.000
#:: trtMET        2540.000 2670.000

f1 <- lm( log(nt2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.8180201  0.0082312 949.8051 < 2.2e-16
#:: trtMET         0.0471889  0.0138406   3.4095 0.0024028

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::  2484.9804332     1.0483200
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   2443.025635 2527.655734
#:: trtMET           1.018731    1.078769

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Na1
f1 <- lm( na1 ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::        trtCON        trtMET
#::    76.4410089    77.3976382
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %    97.5 %
#:: trtCON        74.9362030 77.945815
#:: trtMET        76.3432705 78.452006


f1 <- lm( na1 ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::               Estimate Std. Error  t value Pr(>|t|)
#:: (Intercept)   76.44101    0.72743 105.0835  < 2e-16
#:: trtMET         0.95663    0.88909   1.0760  0.29310

f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   (Intercept)        trtMET
#::    76.4410089     0.9566292
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %    97.5 %
#:: (Intercept)   74.9362030 77.945815
#:: trtMET        -0.8825956  2.795854

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 


#::::::::: Ftm
f1 <- lm( log(ftm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::       430.000       427.000
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                2.5 %  97.5 %
#:: trtCON        411.00 450.000
#:: trtMET        412.00 442.000

f1 <- lm( log(ftm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.0639362  0.0220485 275.0272 < 2.2e-16
#:: trtMET        -0.0082268  0.0281031  -0.2927    0.7723

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::   430.0649199     0.9918070
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   410.8899385 450.1347392
#:: trtMET          0.9357916   1.0511754

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Ft1
f1 <- lm( log(ft1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::        207.00        223.00
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                 2.5 %  97.5 %
#:: trtCON        201.000 213.000
#:: trtMET        216.000 229.000

f1 <- lm( log(ft1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    5.331721   0.014702 362.6444 < 2.2e-16
#:: trtMET         0.073213   0.020636   3.5478  0.001716

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::   206.7934841     1.0759599
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   200.5987265 213.1795442
#:: trtMET          1.0309949   1.1228859

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Ft2
f1 <- lm( log(ft2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::      1450.000      1430.000
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                  2.5 %   97.5 %
#:: trtCON        1410.000 1500.000
#:: trtMET        1380.000 1470.000

f1 <- lm( log(ft2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.281920   0.015721 463.2053 < 2.2e-16
#:: trtMET        -0.018999   0.021604  -0.8794    0.3883

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::  1453.7761714     0.9811807
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                      2.5 %       97.5 %
#:: (Intercept)   1407.2587272 1501.8312665
#:: trtMET           0.9382966    1.0260247

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Fa1
f1 <- lm( fa1 ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::        trtCON        trtMET
#::     79.455953     79.724428
#:: > coefci(f1, vcov=V, df=dfe)
#::                   2.5 %     97.5 %
#:: trtCON        78.575392 80.3365141
#:: trtMET        79.134632 80.3142244

f1 <- lm( fa1 ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::               Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)   79.45595    0.42567 186.6618 < 2.2e-16
#:: trtMET         0.26848    0.51919   0.5171  0.610022

f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   (Intercept)        trtMET
#::    79.4559528     0.2684756
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %     97.5 %
#:: (Intercept)   78.5753915 80.3365141
#:: trtMET        -0.8055564  1.3425076

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 



#::::::::: Redox Ratio
f1 <- lm( log(rr)  ~ -1 + trt + C(frep, sum),  data=DATA )
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#:: > signif( exp(f1$coef) , 3)
#::        trtCON        trtMET
#::         0.648         0.687
#:: > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::               2.5 % 97.5 %
#:: trtCON        0.636  0.660
#:: trtMET        0.674  0.699

###### 
# library(emmeans)
# f1 <- lm( log(rr)  ~ trt + frep,  data=DATA )
# summary(f1)
# V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
# dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
# emmeans(object=f1, spec="trt", vcov=V, df=dfe, trans="log", type="response")
######

f1 <- lm( log(rr) ~ trt + C(frep, sum),  data=DATA )
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)   -0.4339542  0.0088001 -49.3124 < 2.2e-16
#:: trtMET         0.0579277  0.0128611   4.5041 0.0001602
exp(f1$coef)
exp( coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trtMET
#::     0.6479419     1.0596384
#:: > exp( coefci(f1, vcov=V, df=dfe) )
#::                   2.5 %    97.5 %
#:: (Intercept)   0.6362532 0.6598454
#:: trtMET        1.0318181 1.0882087


ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) 


#~~~~~~~~~~~~~~~~~~ OMI Index
library(emmeans)

DATA <- read.csv("OMIindex_metformin.csv") # 1302 x 4

tmp <- DATA

tmp$trt <- factor(tmp$trt, levels=c("Control","Metformin"), labels=c("con","met") )

tmp <- tmp[order(tmp$trt, tmp$rep, tmp$fid, tmp$omi),] ; rownames(tmp) <- NULL

tmp$ufish <- as.factor( apply(tmp[,c("trt","rep","fid")], 1, paste, sep="", collapse="/")  )
tmp$n.ufish <- as.numeric(tmp$ufish)
tmp <- tmp[order(tmp$n.ufish),] ; rownames(tmp) <- NULL
tmp$frep <- as.factor(tmp$rep)

( n <- length(unique(tmp$n.ufish)) )  # n=27

summary(tmp$omi)  # min is -0.6893
r <- 0.70 # to make all positive
 
tmp$y <- tmp$omi + r # to make everthing positive

f1 <- glm( y  ~ 0+frep/trt, data=tmp, family=quasi(link="identity", variance="mu^2")  )

dfe <- n - length(f1$coef) 
( b <- cbind(f1$coef) ) # metformin higher for all reps
V <- vcovCL(f1, cluster=~n.ufish, type="HC3")
ok <- grep(pattern=":trtmet", x=rownames(b) )
K <- matrix(0, nrow=1, ncol=length(b))
K[ok] <- 1/length(ok)

eff <- as.numeric( K%*%b )
se  <- sqrt(diag( K%*%V%*%t(K) ))
 
c("effect"=eff, "95low"=eff-qt(0.975,dfe)*se, 
                "95hi" =eff+qt(0.975,dfe)*se,
                "pval" = 2*pt(-abs(eff)/se, dfe) )
#::                 
#::      effect       95low        95hi        pval 
#:: 0.091470271 0.027785378 0.155155165 0.007028413 
#:: 
# 
# f1 <- glm( y  ~ frep*trt, data=tmp, family=quasi(link="identity", variance="mu^2")  )
# f0 <- glm( y  ~ frep+trt, data=tmp, family=quasi(link="identity", variance="mu^2")  )
# V <- vcovCL(f1, cluster=~n.ufish, type="HC3")
# dfe <- length(unique(tmp$n.ufish)) - length(f1$coef) 
# waldtest(f0, f1, vcov=V) # p=0.269 for whether treatment varies by replicate
# 

f1 <- glm( y ~ 0 + trt/C(frep, sum), 
               data=tmp, 
               family=quasi(link="identity", variance="mu^2") )
V <- vcovCL(f1, cluster=~n.ufish, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)[1:2,]-r  # scale back by 0.70
coefci(  f1, vcov=V, df=dfe)[1:2,]-r  # scale back by 0.70
#:: 
#:: > coeftest(f1, vcov=V, df=dfe)[1:2,]-r  # scale back by 0.70
#::         Estimate
#:: trtcon 0.9440218
#:: trtmet 1.0354920
#:: > coefci(  f1, vcov=V, df=dfe)[1:2,]-r  # scale back by 0.70
#::            2.5 %    97.5 %
#:: trtcon 0.9060951 0.9819484
#:: trtmet 0.9843322 1.0866519
#:: 

# Other way
#@@   f1 <- glm( y ~ trt*frep,
#@@                  data=tmp, 
#@@                  family=quasi(link="identity", variance="mu^2") )
#@@   V <- vcovCL(f1, cluster=~n.ufish, type="HC3")
#@@   dfe <- n - length(f1$coef) 
#@@   pairs( emmeans( f1, "trt", vcov=V, df=dfe), reverse=T )
#@@   #:: 
#@@   #::  contrast  estimate     SE df t.ratio p.value
#@@   #::  met - con   0.0915 0.0306 21 2.987   0.0070 
#@@   #:: 
#@@   confint( pairs( emmeans( f1, "trt", vcov=V, df=dfe), reverse=T ) )
#@@   #:: 
#@@   #:: 
#@@   #:: contrast  estimate     SE df lower.CL upper.CL
#@@   #:: met - con   0.0915 0.0306 21   0.0278    0.155
#@@   #:: 
#@@   

remove(list=ls())




