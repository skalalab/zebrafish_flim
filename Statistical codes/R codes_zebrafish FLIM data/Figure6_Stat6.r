
library(beeswarm)
library(sandwich)
library(lmtest)
library(emmeans)

options(show.signif.stars=F)

setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")

DATA <- read.csv("Stat6_correctfilter_forstatistics.csv") # 489 x 14
names(DATA)
#::  [1] "grp"   "fid"   "rep"   "rr"    "f.a1"  "f.t1"  "f.t2"  "f.tm"  "n.a1" 
#:: [10] "n.t1"  "n.t2"  "n.tm"  "f.int" "n.int"

any(is.na(DATA)) # resolves to FALSE ... no missing

KEEP <- c("KEEP","DATA","tmp","wksp", "n") ; KEEP <- sort(unique(KEEP))

tmp <- DATA

tmp$f.rep <- as.factor(tmp$rep)

tmp$grp <- factor(tmp$grp, levels=c("wt","stat6") )

tmp$uid <- apply(tmp[,c("grp","rep","fid")], 1, paste, sep="", collapse=":")
tmp$uid <- as.numeric(as.factor(tmp$uid) )

tmp <- tmp[order(tmp$grp, tmp$f.rep, tmp$fid), ] ; rownames(tmp) <- NULL ; 

(n <- length(unique(tmp$uid) ) ) # 24 larvae

#####  f.a1
f1 <- lm( f.a1 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               72.393227               74.423278
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %    97.5 %
#:: grpwt                   70.4684262 74.318028
#:: grpstat6                73.4237678 75.422789

f1 <- lm( f.a1 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)             72.39323    0.91617 79.0173 < 2.2e-16
#:: grpstat6                 2.03005    1.03233  1.9665 0.0648571
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)             70.4684262 74.318028
#:: grpstat6                -0.1387912  4.198894
#:: 

#:: Alternate way
# f1 <- lm( f.a1 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 




#####  f.t1
f1 <- lm( f.t1 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               491.78417               479.97052
#:: > coefci(f1, vcov=V, df=dfe) 
#::                                2.5 %    97.5 %
#:: grpwt                    453.6359309 529.93242
#:: grpstat6                 435.1753563 524.76568

f1 <- lm( f.t1 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)              491.784     18.158 27.0838 4.863e-16
#:: grpstat6                 -11.814     28.006 -0.4218  0.678144
#:: 
coefci(f1, vcov=V, df=dfe)
#::                                2.5 %    97.5 %
#:: (Intercept)              453.6359309 529.93242
#:: grpstat6                 -70.6515244  47.02422
#:: 

#:: Alternate way
# f1 <- lm( f.t1 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  f.t2
f1 <- lm( f.t2 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::              2034.17527              1795.32631
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %     97.5 %
#:: grpwt                   1940.70056 2127.64997
#:: grpstat6                1709.74482 1880.90779

f1 <- lm( f.t2 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)             2034.175     44.492 45.7198 < 2.2e-16
#:: grpstat6                -238.849     60.323 -3.9595 0.0009192
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %     97.5 %
#:: (Intercept)             1940.70056 2127.64997
#:: grpstat6                -365.58377 -112.11416
#:: 

#:: Alternate way
# f1 <- lm( f.t2 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  f.tm
f1 <- lm( f.tm ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               828.14985               747.00657
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %    97.5 %
#:: grpwt                    768.60933 887.69037
#:: grpstat6                 717.98481 776.02832

f1 <- lm( f.tm ~  grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)              828.150     28.340 29.2218 < 2.2e-16
#:: grpstat6                 -81.143     31.528 -2.5737 0.0191258
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)              768.60933 887.69037
#:: grpstat6                -147.38025 -14.90632
#:: 

#:: Alternate way
# f1 <- lm( f.tm ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  n.a1
f1 <- lm( n.a1 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6    grpwt:C(f.rep, sum)1 
#::               74.138942               77.679555               -8.577246 
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %    97.5 %
#:: grpwt                    72.753221 75.524663
#:: grpstat6                 76.771063 78.588047

f1 <- lm( n.a1 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)             74.13894    0.65958 112.4037 < 2.2e-16
#:: grpstat6                 3.54061    0.78869   4.4892 0.0002837
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)              72.753221 75.524663
#:: grpstat6                  1.883633  5.197592
#:: 

#:: Alternate way
# f1 <- lm( n.a1 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  n.t1
f1 <- lm( n.t1 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               331.48784               301.07520
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %    97.5 %
#:: grpwt                    287.94867 375.02700
#:: grpstat6                 276.06039 326.09000

f1 <- lm( n.t1 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#::  t test of coefficients:
#::  
#::                          Estimate Std. Error t value  Pr(>|t|)
#::  (Intercept)              331.488     20.724 15.9955 4.378e-12
#::  grpstat6                 -30.413     23.901 -1.2725 0.2194030
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)              287.94867 375.02700
#:: grpstat6                 -80.62618  19.80090
#:: 

#:: Alternate way
# f1 <- lm( n.t1 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  n.t2
f1 <- lm( n.t2 ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               2646.8015               2523.7264
#:: > coefci(f1, vcov=V, df=dfe) 
#::                             2.5 %     97.5 %
#:: grpwt                   2566.8426 2726.76031
#:: grpstat6                2439.1588 2608.29411

f1 <- lm( n.t2 ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)             2646.801     38.059 69.5448 < 2.2e-16
#:: grpstat6                -123.075     55.396 -2.2217 0.0393645
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)              287.94867 375.02700
#:: grpstat6                 -80.62618  19.80090
#:: 

#:: Alternate way
# f1 <- lm( n.t2 ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  n.tm
f1 <- lm( n.tm ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
#:: coefci(f1, vcov=V, df=dfe) 
#::                   grpwt                grpstat6
#::                934.6634                806.2994
#:: > coefci(f1, vcov=V, df=dfe) 
#::                             2.5 %    97.5 %
#:: grpwt                    871.3033  998.0235
#:: grpstat6                 756.7142  855.8847

f1 <- lm( n.tm ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)              934.663     30.158 30.9920 < 2.2e-16
#:: grpstat6                -128.364     38.296 -3.3519   0.00355
#:: 
coefci(f1, vcov=V, df=dfe)
#::                             2.5 %     97.5 %
#:: (Intercept)              871.3033  998.02351
#:: grpstat6                -208.8202  -47.90782
#:: 

#:: Alternate way
# f1 <- lm( n.tm ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 




#####  redox ratio
f1 <- lm( rr ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::             0.914326413             0.894162219
#:: > coefci(f1, vcov=V, df=dfe) 
#::                               2.5 %      97.5 %
#:: grpwt                    0.90775725 0.920895574
#:: grpstat6                 0.88164948 0.906674962

f1 <- lm( rr ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                           Estimate Std. Error  t value  Pr(>|t|)
#:: (Intercept)              0.9143264  0.0031268 292.4161 < 2.2e-16
#:: grpstat6                -0.0201642  0.0067267  -2.9976  0.007725
#:: 
coefci(f1, vcov=V, df=dfe)
#::                               2.5 %       97.5 %
#:: (Intercept)              0.90775725  0.920895574
#:: grpstat6                -0.03429652 -0.006031869
#:: 

#:: Alternate way
# f1 <- lm( rr ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  F.int
f1 <- lm( f.int ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::              30.6376890              35.2046183
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %    97.5 %
#:: grpwt                    26.592222 34.683156
#:: grpstat6                 29.172751 41.236485

f1 <- lm( f.int ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)             30.63769    1.92557 15.9110 4.787e-12
#:: grpstat6                 4.56693    3.45699  1.3211    0.2030
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %    97.5 %
#:: (Intercept)              26.592222 34.683156
#:: grpstat6                 -2.695937 11.829796
#:: 

#:: Alternate way
# f1 <- lm( f.int ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#####  N.int
f1 <- lm( n.int ~ 0 + grp/C(f.rep, sum), data=tmp, x=T, y=T )
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   grpwt                grpstat6
#::               289.74840               262.22447
#:: > coefci(f1, vcov=V, df=dfe) 
#::                             2.5 %     97.5 %
#:: grpwt                   260.28048 319.216316
#:: grpstat6                242.79128 281.657654

f1 <- lm( n.int ~  grp/C(f.rep, sum), data=tmp, x=T, y=T)
V <- vcovCL( f1, cluster=~uid, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                         Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)             289.7484    14.0262 20.6577 5.506e-14
#:: grpstat6                -27.5239    16.8016 -1.6382  0.118747
#:: 
coefci(f1, vcov=V, df=dfe)
#::                             2.5 %     97.5 %
#:: (Intercept)             260.28048 319.216316
#:: grpstat6                -62.82276   7.774892
#:: 

#:: Alternate way
# f1 <- lm( n.int ~ f.rep*grp, data=tmp,
#                 x=T,y=T )
#                 
# dfe <- n - length(f1$coef) 
# emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "grp", vcov=vcovCL(f1, cluster=~uid, type="HC3"), df=dfe), reverse=T ) )
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 

#########################   OMI index

remove(list=ls())

# second worksheet tab of 'Stat6_correctfilter_forstatistics.xlsx'
DATA <- read.csv("OMIindex_stat6.csv") ; # 489 x 4

names(DATA)
# [1] "grp" "fid" "rep" "omi"

KEEP <- c("KEEP","DATA","tmp","wksp", "n"); KEEP <- sort(unique(KEEP))

tmp <- DATA

tmp$trt <- factor(tmp$grp, levels=c("wt","stat6"), labels=c("wt","stat6") )

tmp <- tmp[order(tmp$trt, tmp$rep, tmp$fid, tmp$omi),] ; rownames(tmp) <- NULL

tmp$ufish <- as.factor( apply(tmp[,c("trt","rep","fid")], 1, paste, sep="", collapse="/")  )
tmp$n.ufish <- as.numeric(tmp$ufish)
tmp <- tmp[order(tmp$n.ufish),] ; rownames(tmp) <- NULL
tmp$f.rep <- as.factor(tmp$rep)

(n <- length(unique( tmp$n.ufish) ) ) # 24 fish


summary(tmp$omi) # 
#::    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#::  0.1774  0.7909  0.9263  1.0000  1.1688  2.7099 
#
# all positive 

f1 <- glm( omi ~ 0 + trt/C(f.rep, sum), data=tmp, family=quasi(link="identity", variance="mu^2") )
V <- vcovCL( f1, cluster=~n.ufish, type="HC3")
dfe <- n - length(f1$coef) 
f1$coef
coefci(f1, vcov=V, df=dfe) 
#:: > f1$coef
#::                   trtwt                trtstat6
#::              1.10532345              1.02838694
#:: > coefci(f1, vcov=V, df=dfe) 
#::                              2.5 %       97.5 %
#:: trtwt                    1.0426462  1.168000662
#:: trtstat6                 0.9562315  1.100542437

f1 <- glm( omi ~  trt/C(f.rep, sum), data=tmp, family=quasi(link="identity", variance="mu^2") )
V <- vcovCL( f1, cluster=~n.ufish, type="HC3")
dfe <- n - length(f1$coef) 
coeftest(f1, vcov=V, df=dfe)
#:: 
#:: t test of coefficients:
#:: 
#::                          Estimate Std. Error t value  Pr(>|t|)
#:: (Intercept)              1.105323   0.029833 37.0501 < 2.2e-16
#:: trtstat6                -0.076937   0.045493 -1.6912 0.1080419
#:: 
coefci(f1, vcov=V, df=dfe)
#::                              2.5 %       97.5 %
#:: (Intercept)              1.0426462  1.168000662
#:: trtstat6                -0.1725129  0.018639889


#:: Alternate way
# f1 <- glm( omi ~ f.rep*trt, data=tmp, family=quasi(link="identity", variance="mu^2") )
#                  
# dfe <- n - length(f1$coef) 
# emmeans(f1, "trt", vcov=vcovCL(f1, cluster=~n.ufish, type="HC3"), df=dfe) 
# pairs( emmeans(f1, "trt", vcov=vcovCL(f1, cluster=~n.ufish, type="HC3"), df=dfe), reverse=T )
# confint( pairs( emmeans(f1, "trt", vcov=vcovCL(f1, cluster=~n.ufish, type="HC3"), df=dfe), reverse=T ) )
#:: 

remove(list=ls())

# end

