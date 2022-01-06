

setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")


library(MASS)
library(sandwich)
library(lmtest)
library(beeswarm)

options(show.signif.stars=F)

DATA <- read.csv("TWODG_nof2.csv") ;

DATA$trt <- factor(DATA$trt, levels=c("CON","2DG") )
DATA$frep <- as.factor(DATA$rep)

DATA <- DATA[order(DATA$rep, DATA$trt, DATA$fid),]
rownames(DATA) <- NULL

any(is.na(DATA)) # resolves to FALSE ... no missing

nuid <- apply(DATA[,c("rep","trt","fid")], 1, paste, sep="", collapse="/") 

DATA$nuid <- nuid ; rm(nuid)
# > names(DATA)
#  [1] "rep"  "fid"  "trt"  "fa1"  "ft1"  "ft2"  "ftm"  "na1"  "nt1"  "nt2" 
# [11] "ntm"  "rr"   "frep" "nuid"


KEEP <- c("DATA","KEEP","tmp","n")
( n <- length(unique(DATA$nuid) ) )  # number of unique fish used ... resolves to 17


#:::: Fa1
# with(DATA, beeswarm(fa1 ~ trt, log=T) )
# with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(fa1), fun=mean) )

f1 <- lm( log(fa1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#::  > exp(f1$coef)
#::         trtCON        trt2DG
#::      77.300573     77.805229
#::  > exp(coefci(f1, vcov=V, df=dfe))
#::                    2.5 %    97.5 %
#::  trtCON        76.369078 78.243429
#::  trt2DG        76.748587 78.876418



f1 <- lm( log(fa1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)   4.3477014  0.0056525 769.1588 < 2.2e-16
#:: trt2DG        0.0065073  0.0085349   0.7624 0.4584541
#:: 

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#::  > exp(f1$coef)
#::    (Intercept)        trt2DG
#::      77.300573      1.006528
#::  > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %    97.5 %
#::  (Intercept)   76.3690775 78.243429
#::  trt2DG         0.9882712  1.025123

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok])


#:::: Ft1 
with(DATA, beeswarm(ft1 ~ trt, log=T) )
with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(ft1), fun=mean) )



f1 <- lm( log(ft1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::   254.7753976   237.5409493
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                    2.5 %      97.5 %
#:: trtCON        241.468471 268.8156469
#:: trt2DG        223.010481 253.0181646
#::

f1 <- lm( log(ft1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    5.540382   0.025011 221.5170 < 2.2e-16
#:: trt2DG        -0.070042   0.038968  -1.7974   0.09387
#::

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::   254.7753976     0.9323543
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   241.4684708 268.8156469
#:: trt2DG          0.8575966   1.0136288

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#:::: Ft2 
#: with(DATA, beeswarm(ft2 ~ trt, log=T) )
#: with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(ft2), fun=mean) )


f1 <- lm( log(ft2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#::  > exp(f1$coef)
#::         trtCON        trt2DG
#::   1719.9862377  1573.7034369
#::  > exp(coefci(f1, vcov=V, df=dfe))
#::                       2.5 %       97.5 %
#::  trtCON        1625.9752697 1819.4327510
#::  trt2DG        1495.7659708 1655.7018649


f1 <- lm( log(ft2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.450072   0.026207 284.2776 < 2.2e-16
#:: trt2DG        -0.088885   0.035659  -2.4926  0.025832

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::  1719.9862377     0.9149512
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                      2.5 %       97.5 %
#:: (Intercept)   1625.9752697 1819.4327510
#:: trt2DG           0.8475837    0.9876732

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#:::: Ftm 
# with(DATA, beeswarm(ftm ~ trt, log=T) )
# with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(ftm), fun=mean) )


f1 <- lm( log(ftm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::    538.455860    489.223306
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %      97.5 %
#:: trtCON        502.4538909 577.0374515
#:: trt2DG        457.4010099 523.2595434


f1 <- lm( log(ftm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.288706   0.032265 194.9077 < 2.2e-16
#:: trt2DG        -0.095886   0.045513  -2.1068   0.05366
#::
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::   538.4558596     0.9085672
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %      97.5 %
#:: (Intercept)   502.4538909 577.0374515
#:: trt2DG          0.8240676   1.0017312

ok <- 1  ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 

#:::: Na1 
#: with(DATA, beeswarm(na1 ~ trt, log=T) )
#: with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(na1), fun=mean) )


f1 <- lm( log(na1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::      71.19214      74.24174
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                    2.5 %    97.5 %
#:: trtCON        69.7947322 72.617523
#:: trt2DG        72.2656622 76.271856

f1 <- lm( log(na1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value Pr(>|t|)
#:: (Intercept)   4.2653824  0.0092428 461.4811  < 2e-16
#:: trt2DG        0.0419442  0.0156678   2.6771  0.01805
#:: 

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::     71.192138      1.042836
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                    2.5 %    97.5 %
#:: (Intercept)   69.7947322 72.617523
#:: trt2DG         1.0083749  1.078475

ok <- 1  ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#:::: Nt1 
#:: with(DATA, beeswarm(nt1 ~ trt, log=T) )
#:: with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(nt1), fun=mean) )

f1 <- lm( log(nt1) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::    358.483825    343.533745
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %     97.5 %
#:: trtCON        347.2216696 370.111268
#:: trt2DG        332.3753351 355.066763

f1 <- lm( log(nt1) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                Estimate Std. Error  t value Pr(>|t|)
#:: (Intercept)    5.881884   0.014883 395.2170  < 2e-16
#:: trt2DG        -0.042598   0.021440  -1.9869  0.06686
#::
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %     97.5 %
#:: (Intercept)   347.2216696 370.111268
#:: trt2DG          0.9152285   1.003391
#::

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 

#:::: Nt2 
#: with(DATA, beeswarm(nt2 ~ trt, log=T) )
#: with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(nt2), fun=mean) )



f1 <- lm( log(nt2) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::   2667.780039   2569.250873
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %      97.5 %
#:: trtCON        2618.869785 2717.603745
#:: trt2DG        2531.112038 2607.964384
#::

f1 <- lm( log(nt2) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    7.8890020  0.0086274 914.4173 < 2.2e-16
#:: trt2DG        -0.0376323  0.0109869  -3.4252  0.004102
#::
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::   2667.780039      0.963067
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %       97.5 %
#:: (Intercept)   2618.869785 2717.6037452
#:: trt2DG           0.940638    0.9860308

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 

#:::: Ntm
# with(DATA, beeswarm(ntm ~ trt, log=T) )
# with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(ntm), fun=mean) )

f1 <- lm( log(ntm) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::   1007.004195    903.593877
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %      97.5 %
#:: trtCON        957.4810425 1059.088800
#:: trt2DG        854.9347190  955.022503


f1 <- lm( log(ntm) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)    6.9147351  0.0235124 294.0886 < 2.2e-16
#:: trt2DG        -0.1083550  0.0349053  -3.1043  0.007766
#::
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::   1007.004195      0.897309
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                     2.5 %       97.5 %
#:: (Intercept)   957.4810425 1059.0888005
#:: trt2DG          0.8325855    0.9670639

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#:::: redox ratio
#:: with(DATA, beeswarm(rr ~ trt, log=T) )
#:: with(DATA, interaction.plot(x.factor=frep, trace.factor=trt, response=log10(rr), fun=mean) )


f1 <- lm( log(rr) ~ -1 + trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::        trtCON        trt2DG
#::     0.7783694     0.7619960
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                   2.5 %    97.5 %
#:: trtCON        0.7718511 0.7849429
#:: trt2DG        0.7529834 0.7711166
#:: 


f1 <- lm( log(rr) ~ trt + C(frep, sum),  data=DATA)
summary(f1)
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 
#:: > coeftest(f1, vcov=V, df=dfe) 
#:: 
#:: t test of coefficients:
#:: 
#::                 Estimate Std. Error  t value Pr(>|t|)
#:: (Intercept)   -0.2505540  0.0039210 -63.9008  < 2e-16
#:: trt2DG        -0.0212599  0.0067745  -3.1382  0.00726
#:: 

exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe) )
#:: > exp(f1$coef)
#::   (Intercept)        trt2DG
#::     0.7783694     0.9789645
#:: > exp(coefci(f1, vcov=V, df=dfe) )
#::                   2.5 %    97.5 %
#:: (Intercept)   0.7718511 0.7849429
#:: trt2DG        0.9648431 0.9932926

ok <- 1; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 








