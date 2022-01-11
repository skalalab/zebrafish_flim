


setwd("/media/lasarevm/ExtraDrive/UWMad/Y2020/Jan2020/Miskolci/wksp")


library(MASS)
library(sandwich)
library(lmtest)
library(beeswarm)
library(emmeans)

options(show.signif.stars=F)


DATA <- read.csv("Burn_nof3_wksp.csv")  # 1963 x 13
names(DATA)
#::  [1] "fa1"  "ft1"  "ft2"  "ftm"  "na1"  "nt1"  "nt2"  "ntm"  "rr"   "trt" 
#:: [11] "tyme" "fid"  "rep" 
#:: 
#:: NB: tyme is 'time' , either 24 or 72 hours post wound (hpw)

DATA <- DATA[order(DATA$rep, DATA$trt, DATA$tyme, DATA$fid),]
rownames(DATA) <- NULL
fuid <- DATA[,c("rep","trt","tyme","fid")]
fuid <- as.factor( apply(fuid, 1, paste, sep="", collapse=":") )
nuid <- as.numeric(fuid)
# table(fuid, nuid)   

DATA$nuid <- nuid ; rm(nuid, fuid) 

length(unique(DATA$nuid)) # n=53 distinct larvae
with(DATA, tapply( nuid, list(rep, trt, tyme), function(x) length(unique(x)) ) )
#::  , , 24
#::  
#::    BURN TRANS
#::  1    4     5
#::  2    5     5
#::  3    5     6
#::  
#::  , , 72
#::  
#::    BURN TRANS
#::  1    3     3
#::  2    4     3
#::  3    4     6
#:
#: Matches her statement about selecting 5~6 larvae at each time point, though
#: lower for the 72 hpw group

KEEP <- c("KEEP","DATA","tmp","wksp","n") ; KEEP <- sort(unique(KEEP)) ; 


########################################################

DATA$frep  <- as.factor(DATA$rep)
DATA$ftyme <- as.factor(DATA$tyme) 

ugrp <- apply(DATA[,c("trt","tyme")], 1, paste, sep="", collapse=":" ) 
ugrp <- as.factor(ugrp)
DATA$ugrp <- ugrp ; rm(ugrp)

(n <- length(unique(DATA$nuid)) )



#::::::::: N.tm.out 

f1 <- lm( log(ntm) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::   700.4736309   965.2794460   754.7843146  1007.5594819
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %      97.5 %
#:: ugrpBURN:24   668.9775664  733.452558
#:: ugrpBURN:72   927.1056677 1005.025038
#:: ugrpTRANS:24  714.6523881  797.169884
#:: ugrpTRANS:72  968.7159179 1047.960595


f1 <- lm( log(ntm) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(ntm) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(ntm) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(ntm) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=0.49, p=0.487

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

# Replay estimates
f1 <- lm( log(ntm) ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") 
#:: ftyme = 24:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       700 16.0 47      669      733
#::  TRANS      755 20.5 47      715      797
#:: 
#:: ftyme = 72:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       965 19.4 47      927     1005
#::  TRANS     1008 19.7 47      969     1048
pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
confint(pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
#:: 
#:: 
#::  contrast     ratio     SE df null t.ratio p.value
#::  TRANS / BURN  1.06 0.0236 47    1 2.639   0.0113 
#:: 
#::  contrast     ratio     SE df lower.CL upper.CL
#::  TRANS / BURN  1.06 0.0236 47     1.01     1.11
#:: 
pairs( emmeans( f1, "ftyme", vcov=V, df=dfe, trans="log", type="response"), reverse=T  )
confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
#::  contrast ratio     SE df null t.ratio p.value
#::  72 / 24   1.36 0.0296 47    1 13.945  <.0001 
#:: 
#::  contrast ratio     SE df lower.CL upper.CL
#::  72 / 24   1.36 0.0296 47      1.3     1.42
#:: 

#:: Comparable effects (1.08 and 1.39, both significant)  
#  V  <- vcovCL(f3, cluster = ~ nuid, type="HC2", fix=T, cadjust=T ) # model with no interaction
#  dfe <- n - length(f3$coef)
#  coeftest(f1, vcov=V, df=dfe) 
#  exp(f1$coef)

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 

#::::::::: N.t1.out 

f1 <- lm( log(nt1) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::   274.0665006   396.3008619   306.2324441   397.9823072
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                    2.5 %      97.5 %
#:: ugrpBURN:24   264.190732 284.3114372
#:: ugrpBURN:72   374.822027 419.0105217
#:: ugrpTRANS:24  288.867832 324.6408887
#:: ugrpTRANS:72  370.598362 427.3896842


f1 <- lm( log(nt1) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(nt1) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(nt1) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(nt1) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=3.70, p=0.06

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

# Replay estimates
f1 <- lm( log(nt1) ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") 
#:: ftyme = 24:
#::  trt   response    SE df lower.CL upper.CL
#::  BURN       274  5.00 47      264      284
#::  TRANS      306  8.89 47      289      325
#:: 
#:: ftyme = 72:
#::  trt   response    SE df lower.CL upper.CL
#::  BURN       396 10.98 47      375      419
#::  TRANS      398 14.10 47      371      427

pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") , reverse=T )
confint( pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") , reverse=T ) )
#:: 
#:: > pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") , reverse=T )
#:: ftyme = 24:
#::  contrast     ratio     SE df null t.ratio p.value
#::  TRANS / BURN  1.12 0.0364 47    1 3.404   0.0014 
#:: 
#:: ftyme = 72:
#::  contrast     ratio     SE df null t.ratio p.value
#::  TRANS / BURN  1.00 0.0447 47    1 0.095   0.9246 
#:: 
#:: > confint( pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") , reverse=T ) )
#:: ftyme = 24:
#::  contrast     ratio     SE df lower.CL upper.CL
#::  TRANS / BURN  1.12 0.0364 47    1.046     1.19
#:: 
#:: ftyme = 72:
#::  contrast     ratio     SE df lower.CL upper.CL
#::  TRANS / BURN  1.00 0.0447 47    0.918     1.10

pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, trans="log", type="response") , reverse=T )
confint( pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, trans="log", type="response") , reverse=T ) )
#:: 
#:: > pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, trans="log", type="response") , reverse=T )
#:: trt = BURN:
#::  contrast ratio     SE df null t.ratio p.value
#::  72 / 24   1.45 0.0450 47    1 11.841  <.0001 
#:: 
#:: trt = TRANS:
#::  contrast ratio     SE df null t.ratio p.value
#::  72 / 24   1.30 0.0598 47    1  5.700  <.0001 
#:: 
#:: > confint( pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, trans="log", type="response") , reverse=T ) )
#:: trt = BURN:
#::  contrast ratio     SE df lower.CL upper.CL
#::  72 / 24   1.45 0.0450 47     1.36     1.54
#:: 
#:: trt = TRANS:
#::  contrast ratio     SE df lower.CL upper.CL
#::  72 / 24   1.30 0.0598 47     1.18     1.43
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#::::::::: N.t2.out 

f1 <- lm( log(nt2) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::  2224.2592483  2829.7504173  2252.9227027  2832.0824665
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                      2.5 %      97.5 %
#:: ugrpBURN:24   2146.9667107 2304.334380
#:: ugrpBURN:72   2742.2172898 2920.077652
#:: ugrpTRANS:24  2170.5518502 2338.419469
#:: ugrpTRANS:72  2717.3474003 2951.662013


f1 <- lm( log(nt2) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(nt2) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(nt2) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(nt2) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=0.108, p=0.743 ... could drop interaction

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# No effect due to treatment in any form [F(2,47)=0.126, p=0.882] 
# (at either level of time)

# Replay estimates
f1 <- lm( log(nt2) ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") 
#:: ftyme = 24:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN      2224 39.1 47     2147     2304
#::  TRANS     2253 41.7 47     2171     2338
#:: 
#:: ftyme = 72:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN      2830 44.2 47     2742     2920
#::  TRANS     2832 58.2 47     2717     2952
#:: 

# 
# pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
# confint(pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
# 

pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
#:: 
#::    contrast ratio     SE df null t.ratio p.value
#::    72 / 24   1.26 0.0219 47    1 13.553  <.0001 
#::   
#::
#::    contrast ratio     SE df lower.CL upper.CL
#::    72 / 24   1.26 0.0219 47     1.22     1.31
#::   
#:: 
#
#:: Comparable conclusions from no-interaction model
#  V  <- vcovCL(f3, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  coeftest(f3, vcov=V, df=dfe) 
#  exp(f3$coef)
#  exp(coefci(f3, vcov=V, df=dfe) )
#
ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#::::::::: N.a1.out 

f1 <- lm( na1 ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#::  > f1$coef
#::    ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::     77.7277002    75.1755522    76.3733391    73.4437224
#::  > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %     97.5 %
#::  ugrpBURN:24   77.0751733 78.3802271
#::  ugrpBURN:72   74.1373450 76.2137593
#::  ugrpTRANS:24  75.5420033 77.2046750
#::  ugrpTRANS:72  72.8937002 73.9937447

f1 <- lm( na1 ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( na1 ~ C(frep, sum)              , data=DATA )
f3 <- lm( na1 ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( na1 ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=0.229, p=0.635 ... could drop interaction

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

# Replay estimates
f1 <- lm( na1 ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, type="response") 
#:: ftyme = 24:
#::  trt   emmean    SE df lower.CL upper.CL
#::  BURN    77.7 0.324 47     77.1     78.4
#::  TRANS   76.4 0.413 47     75.5     77.2
#:: 
#:: ftyme = 72:
#::  trt   emmean    SE df lower.CL upper.CL
#::  BURN    75.2 0.516 47     74.1     76.2
#::  TRANS   73.4 0.273 47     72.9     74.0

pairs( emmeans( f1, "trt" , vcov=V, df=dfe, type="response"), reverse=T )
confint(pairs( emmeans( f1, "trt", vcov=V, df=dfe, type="response"), reverse=T ) )
#::  contrast     estimate    SE df t.ratio p.value
#::  TRANS - BURN    -1.54 0.389 47 -3.966  0.0002 
#:: 
#::  contrast     estimate    SE df lower.CL upper.CL
#::  TRANS - BURN    -1.54 0.389 47    -2.33    -0.76

pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, type="response"), reverse=T )
confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, type="response"), reverse=T ) )
#::  contrast estimate    SE df t.ratio p.value
#::  72 - 24     -2.74 0.409 47 -6.695  <.0001 
#:: 
#::  contrast estimate    SE df lower.CL upper.CL
#::  72 - 24     -2.74 0.409 47    -3.56    -1.92

#:: Comparable results (no interaction model)  
#  f3 <- lm( na1 ~ C(frep, sum) + ftyme + trt, data=DATA )
#  V  <- vcovCL(f3, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  coeftest(f3, vcov=V, df=dfe) 
#  coefci(f3, vcov=V, df=dfe) 
#  

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#::::::::: F.tm.out 

f1 <- lm( log(ftm) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#:: > exp(f1$coef)
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::   563.4035710   500.7390634   568.8240228   526.3558965
#:: > exp(coefci(f1, vcov=V, df=dfe))
#::                     2.5 %     97.5 %
#:: ugrpBURN:24   532.5723733 596.019621
#:: ugrpBURN:72   442.0841209 567.176240
#:: ugrpTRANS:24  523.1113196 618.531385
#:: ugrpTRANS:72  490.7290363 564.569262


f1 <- lm( log(ftm) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(ftm) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(ftm) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(ftm) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=0.244, p=0.624 ... could drop interaction

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# No effect due to treatment in any form [F(2,47)=0.270, p=0.764] 
# (at either level of time)

# Replay estimates
f1 <- lm( log(ftm) ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") 
#:: ftyme = 24:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       563 15.8 47      533      596
#::  TRANS      569 23.7 47      523      619
#:: 
#:: ftyme = 72:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       501 31.0 47      442      567
#::  TRANS      526 18.3 47      491      565
#:: 

# 
#  pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
#  confint(pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
# 

pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
#:: 
#::   contrast ratio     SE df null t.ratio p.value
#::   72 / 24  0.907 0.0375 47    1 -2.361  0.0224 
#::  
#::   contrast ratio     SE df lower.CL upper.CL
#::   72 / 24  0.907 0.0375 47    0.834    0.986
#::  
#:: > confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=F ) )
#::  contrast ratio     SE df lower.CL upper.CL
#::  24 / 72    1.1 0.0457 47     1.01      1.2


#:: Comparable conclusions from no-interaction model
#  V  <- vcovCL(f3, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
#  dfe <- n - length(f3$coef)
#  coeftest(f3, vcov=V, df=dfe) 
#  exp(f3$coef)
#  exp(coefci(f3, vcov=V, df=dfe) )
#
#  gives 72/24 hour ratio of 0.90 (95% CI: 0.816--0.990)
ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 



#::::::::: F.t1.out 

f1 <- lm( log(ft1) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
exp(f1$coef)
exp(coefci(f1, vcov=V, df=dfe))
#::  > exp(f1$coef)
#::    ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::    325.5094314   287.7765670   343.6534192   282.7442604
#::  > exp(coefci(f1, vcov=V, df=dfe))
#::                      2.5 %     97.5 %
#::  ugrpBURN:24   304.6528094 347.793904
#::  ugrpBURN:72   244.5644975 338.623772
#::  ugrpTRANS:24  305.2298224 386.913938
#::  ugrpTRANS:72  256.7476304 311.373144


f1 <- lm( log(ft1) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(ft1) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(ft1) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(ft1) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=0.434, p=0.513 ... could drop interaction

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# No effect due to treatment in any form [F(2,47)=0.388, p=0.681] 
# (at either level of time)

# Replay estimates
f1 <- lm( log(ft1) ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, trans="log", type="response") 
#:: ftyme = 24:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       326 10.7 47      305      348
#::  TRANS      344 20.3 47      305      387
#:: 
#:: ftyme = 72:
#::  trt   response   SE df lower.CL upper.CL
#::  BURN       288 23.3 47      245      339
#::  TRANS      283 13.6 47      257      311
#:: 

# No need for difference due to treatment since no effect on this factor
#  pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
#  confint(pairs( emmeans( f1, "trt"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
# 

pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T )
confint(pairs( emmeans( f1, "ftyme"  , vcov=V, df=dfe, trans="log", type="response"), reverse=T ) )
#:: 
#::  contrast ratio     SE df null t.ratio p.value
#::  72 / 24  0.853 0.0465 47    1 -2.916  0.0054  # 14.7% reduction
#:: 
#::  contrast ratio     SE df lower.CL upper.CL
#::  72 / 24  0.853 0.0465 47    0.764    0.952    # 4.8--23.6% reduction


#:: Comparable conclusions from no-interaction model (more conservative)
# V  <- vcovCL(f3, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
# dfe <- n - length(f3$coef)
# coeftest(f3, vcov=V, df=dfe) 
# exp(f3$coef)
# exp(coefci(f3, vcov=V, df=dfe) )
#
#::  > coeftest(f3, vcov=V, df=dfe) 
#::  
#::  t test of coefficients:
#::  
#::                 Estimate Std. Error  t value Pr(>|t|)
#::  (Intercept)    5.792818   0.033801 171.3817  < 2e-16
#::  ftyme72       -0.142646   0.060067  -2.3748  0.02161 # p=0.022
#::  trtTRANS       0.025631   0.054084   0.4739  0.63771
#::  
#::  > exp(f3$coef)
#::    (Intercept)        ftyme72      trtTRANS 
#::    327.9359305      0.8670614     1.0259623   # 13.2% reduction for 72 vs 24
#::  > exp(coefci(f3, vcov=V, df=dfe) )
#::                      2.5 %      97.5 %
#::  (Intercept)   306.3895776 350.9974960
#::  ftyme72         0.7684197   0.9783656  # 2.2 to 23.2% reduction for 72 vs 24 
#::  trtTRANS        0.9202480   1.1438206

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#::::::::: F.t2.out 

f1 <- lm( log(ft2) ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
signif( exp(f1$coef) , 3)
signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::  > signif( exp(f1$coef) , 3)
#::    ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::       1720.000      1610.000      1680.000      1690.000
#::  C(frep, sum)2 
#::          0.975 
#::  > signif( exp(coefci(f1, vcov=V, df=dfe)) , 3)
#::                   2.5 %  97.5 %
#::  ugrpBURN:24   1660.000 1780.00
#::  ugrpBURN:72   1520.000 1720.00
#::  ugrpTRANS:24  1620.000 1760.00
#::  ugrpTRANS:72  1610.000 1790.00


f1 <- lm( log(ft2) ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( log(ft2) ~ C(frep, sum)              , data=DATA )
f3 <- lm( log(ft2) ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( log(ft2) ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) )
# F(3,47)=1.33, p=0.277 
#
# No effect due to time, treatment, or the interaction between these two 
# factors

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#::::::::: F.a1.out 

f1 <- lm( fa1 ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::    79.0694616    79.0369815    78.5621542    78.1345728
#:: > coefci(f1, vcov=V, df=dfe)
#::                    2.5 %     97.5 %
#:: ugrpBURN:24   78.2399543 79.8989689
#:: ugrpBURN:72   77.7546940 80.3192691
#:: ugrpTRANS:24  77.2105511 79.9137573
#:: ugrpTRANS:72  76.9690339 79.3001116


f1 <- lm( fa1 ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( fa1 ~ C(frep, sum)              , data=DATA )
f3 <- lm( fa1 ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( fa1 ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) 

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) )
# F(3,47)=0.644, p=0.591
#
# No effect due to time, treatment, or the interaction between these two 
# factors

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#::::::::: Redox Ratio

f1 <- lm( rr  ~ -1 + ugrp  + C(frep, sum)  , data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
# coeftest(f1, vcov=V, df=dfe) 
f1$coef
coefci(f1, vcov=V, df=dfe)
#:: > f1$coef
#::   ugrpBURN:24   ugrpBURN:72  ugrpTRANS:24  ugrpTRANS:72
#::    0.64174469    0.75065517    0.70212341    0.76145710
#:: > coefci(f1, vcov=V, df=dfe)
#::                     2.5 %       97.5 %
#:: ugrpBURN:24    0.62791911  0.655570261
#:: ugrpBURN:72    0.73644908  0.764861260
#:: ugrpTRANS:24   0.68750730  0.716739525
#:: ugrpTRANS:72   0.74255253  0.780361672


f1 <- lm( rr  ~ C(frep, sum) + ftyme*trt  , data=DATA )
f2 <- lm( rr  ~ C(frep, sum)              , data=DATA )
f3 <- lm( rr  ~ C(frep, sum) + ftyme + trt, data=DATA )
f4 <- lm( rr  ~ C(frep, sum) + ftyme      , data=DATA )

V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)
coeftest(f1, vcov=V, df=dfe) # clearly a significant interaction

( tt <- waldtest(f2, f1, vcov=V) ) # any effect due to time or treatment or interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

( tt <- waldtest(f3, f1, vcov=V) ) # any interaction?
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 
# F(1,47)=9.90, p=0.003 ... can't ignore

( tt <- waldtest(f4, f1, vcov=V) ) # any effect due to treatment (interaction or main effect)
c("F"=tt$F[2], "df1"=tt$Df[2], "df2"=dfe, "p"=1-pf(tt$F[2], tt$Df[2], dfe) ) 

# Replay estimates
f1 <- lm( rr ~ ftyme*trt + frep, data=DATA )
V  <- vcovCL(f1, cluster = ~ nuid, type="HC2", fix=T, cadjust=T )
dfe <- n - length(f1$coef)

emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, type="response") 
#::   ftyme = 24:
#::    trt   emmean      SE df lower.CL upper.CL
#::    BURN   0.642 0.00687 47    0.628    0.656
#::    TRANS  0.702 0.00727 47    0.688    0.717
#::   
#::   ftyme = 72:
#::    trt   emmean      SE df lower.CL upper.CL
#::    BURN   0.751 0.00706 47    0.736    0.765
#::    TRANS  0.761 0.00940 47    0.743    0.780
#:: 

pairs( emmeans( f1, "trt", by="ftyme" , vcov=V, df=dfe, type="response"), reverse=T )
confint(pairs( emmeans( f1, "trt", by="ftyme" , vcov=V, df=dfe, type="response"), reverse=T ) )
#:: 
#:: ftyme = 24:
#::  contrast     estimate      SE df t.ratio p.value
#::  TRANS - BURN   0.0604 0.00982 47 6.147   <.0001 
#:: 
#:: ftyme = 72:
#::  contrast     estimate      SE df t.ratio p.value
#::  TRANS - BURN   0.0108 0.01193 47 0.906   0.3698 
#:: 
#:: > confint(pairs( emmeans( f1, "trt", by="ftyme" , vcov=V, df=dfe, type="response"), reverse=T ) )
#:: ftyme = 24:
#::  contrast     estimate      SE df lower.CL upper.CL
#::  TRANS - BURN   0.0604 0.00982 47   0.0406   0.0801
#:: 
#:: ftyme = 72:
#::  contrast     estimate      SE df lower.CL upper.CL
#::  TRANS - BURN   0.0108 0.01193 47  -0.0132   0.0348

pairs( emmeans( f1, "ftyme", by="trt" , vcov=V, df=dfe, type="response"), reverse=T )
confint(pairs( emmeans( f1, "ftyme", by="trt" , vcov=V, df=dfe, type="response"), reverse=T ) )
#:: 
#:: trt = BURN:
#::  contrast estimate     SE df t.ratio p.value
#::  72 - 24    0.1089 0.0102 47 10.709  <.0001 
#:: 
#:: trt = TRANS:
#::  contrast estimate     SE df t.ratio p.value
#::  72 - 24    0.0593 0.0120 47  4.944  <.0001 
#:: 
#:: > confint(pairs( emmeans( f1, "ftyme", by="trt" , vcov=V, df=dfe, type="response"), reverse=T ) )
#:: trt = BURN:
#::  contrast estimate     SE df lower.CL upper.CL
#::  72 - 24    0.1089 0.0102 47   0.0885   0.1294
#:: 
#:: trt = TRANS:
#::  contrast estimate     SE df lower.CL upper.CL
#::  72 - 24    0.0593 0.0120 47   0.0352   0.0835
#:: 

ok <- 1 ; ok <- ls()%in%KEEP ; remove(list=ls()[!ok]) ; 


#~~~~~~~~~~~~~~~~~~~~~~~ OMI Index

remove(list=ls())

DATA <- read.csv("OMIindex_burn.csv") ; 


KEEP <- c("KEEP","DATA","tmp","wksp"); KEEP <- sort(unique(KEEP))

tmp <- DATA
tmp <- tmp[order(tmp$rep, tmp$trt, tmp$tyme, tmp$fid),]

rownames(tmp) <- NULL
fuid <- tmp[,c("rep","trt","tyme","fid")]
fuid <- as.factor( apply(fuid, 1, paste, sep="", collapse=":") )
nuid <- as.numeric(fuid)
# table(fuid, nuid)

tmp$nuid <- nuid ; rm(nuid, fuid) 

tmp <- tmp[order(tmp$nuid, tmp$omi),] ; rownames(tmp) <- NULL


tmp$trt <- factor(tmp$trt, levels=c("Burn","Transection"), labels=c("burn","trans") )

tmp$frep <- as.factor(tmp$rep)
tmp$ftyme <- as.factor(tmp$tyme)

summary(tmp$omi)
r <- 1.15  # shift things up by 1.15 to make all positive

tmp$y <- tmp$omi + r # to make everthing positive

tmp$txt <- apply(tmp[,c("trt","ftyme")], 1, paste, sep="", collapse="/")
tmp$txt <- as.factor(tmp$txt)

tmp$ugrp <- apply(tmp[,c("rep","trt","ftyme")], 1, paste, sep="", collapse="/") 
tmp$ugrp <- as.factor(tmp$ugrp)

(n <- length(unique(tmp$nuid) ) )
KEEP <- c(KEEP, "n") ; KEEP <- sort(unique(KEEP) ) ; 


f1 <- glm( y  ~ 0 + ugrp, data=tmp, family=quasi(link="identity", variance="mu^2")  )
dfe <- n - length(f1$coef) 
b <- cbind(f1$coef)
V <- vcovCL(f1, cluster=~nuid, type="HC3")

idx <- matrix(1:12, nrow=4)
Kint <- Kburn <- Ktime <- matrix(0, nrow=ncol(idx), ncol=length(b) )
for(i in 1:3){ 
     Kint[i, idx[,i]] <- c( 1, -1, -1,  1)       # interaction
    Kburn[i, idx[,i]] <- c( 1,  1, -1, -1)*5e-1  # burn vs trans (burn-trans)
    Ktime[i, idx[,i]] <- c(-1,  1, -1,  1)*5e-1  # 72 vs 24 hpw (72 - 24)
}

 Kint%*%b
Kburn%*%b
Ktime%*%b
# 
# > t(Kint%*%b)%*%solve(Kint%*%V%*%t(Kint))%*%(Kint%*%b)
#          [,1]
# [1,] 13.91683
# Strong interaction F(3,41)=13.92

#     The comparisons I am interested in:
#     1. Transection 24h vs Burn 24h  # trans 24 minus burn 24
#     2. Transection 72h vs Burn 72h  # trans 72 minus burn 72
#     3. Transection 24h vs Transection 72h # trans 24 minus trans 72
#     4. Burn 24h vs Burn 72h   # burn 24 minus burn 72

K1 <- K2 <- K3 <- K4 <- matrix(0, nrow=ncol(idx), ncol=length(b) )

for(i in 1:3){ 
     K1[i, idx[,i]] <- c(-1,  0,  1,  0)  # trans 24 minus burn 24
     K2[i, idx[,i]] <- c( 0, -1,  0,  1)  # trans 72 minus burn 72
     K3[i, idx[,i]] <- c( 0,  0,  1, -1)  # trans 24 minus trans 72
     K4[i, idx[,i]] <- c( 1, -1,  0,  0)  # burn 24 minus burn 72
}

k1 <- matrix( apply(K1, 2, sum)/3, nrow=1)
k2 <- matrix( apply(K2, 2, sum)/3, nrow=1)
k3 <- matrix( apply(K3, 2, sum)/3, nrow=1)
k4 <- matrix( apply(K4, 2, sum)/3, nrow=1)

kk <- rbind(k1, k2, k3, k4)
eff <- as.numeric( kk%*%b  )
se  <- sqrt(diag( kk%*%V%*%t(kk) ) ) 
tt <- round( cbind( eff , eff-qt(0.975,dfe)*se, 
                    eff+qt(0.975,dfe)*se, 
                    2*pt(-abs(eff)/se, dfe) ), 3 )
dimnames(tt) <- list(c("Comp1","Comp2","Comp3","Comp4"),
                     c("est","95low","95hi","pval") )
tt                     
#::  
#::           est  95low   95hi  pval
#::  Comp1  0.179  0.117  0.241 0.000   # trans 24 minus burn 24 
#::  Comp2  0.058 -0.056  0.172 0.312   # trans 72 minus burn 72
#::  Comp3 -0.411 -0.524 -0.298 0.000   # trans 24 minus trans 72
#::  Comp4 -0.532 -0.596 -0.468 0.000   # burn 24 minus burn 72
#:: 


f1 <- glm( y  ~ 0 + txt/C(frep, sum), 
                data=tmp, 
                family=quasi(link="identity", variance="mu^2")  )
V <- vcovCL(f1, cluster=~nuid, type="HC3")
dfe <- n - length(f1$coef) 
                
# scale back by 1.15
coeftest(f1, vcov=V, df=dfe) - r
coefci(  f1, vcov=V, df=dfe) - r
#:: > coeftest(f1, vcov=V, df=dfe) - r
#:: t test of coefficients:
#:: 
#::                           Estimate Std. Error  t value  Pr(>|t|)
#:: txtburn/24                 0.79038   -1.12956  93.7820 < 2.2e-16
#:: txtburn/72                 1.32241   -1.12582 101.0906 < 2.2e-16
#:: txttrans/24                0.96940   -1.12726  92.0692 < 2.2e-16
#:: txttrans/72                1.38034   -1.09884  48.3058 < 2.2e-16
#:: 
#:: > coefci(  f1, vcov=V, df=dfe) - r
#::                                2.5 %     97.5 %
#:: txtburn/24                 0.7491043  0.8316620
#:: txtburn/72                 1.2735736  1.3712478
#:: txttrans/24                0.9234827  1.0153138
#:: txttrans/72                1.2770101  1.4836643

#::::  Other way, similar conclusions
#  f1 <- glm( y ~ ftyme*trt + frep, family=quasi(link="identity", variance="mu^2"), data=tmp )
#  V  <- vcovCL(f1, cluster = ~ nuid, type="HC3")
#  dfe <- n - length(f1$coef)
#  
#  # need to subtract 'r' = 1.15 from each value; no effect on comparisons though
#  emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, type="response") 
#  pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, type="response") , reverse=T )
#  confint( pairs( emmeans( f1, "trt", by="ftyme", vcov=V, df=dfe, type="response") , reverse=T ) )
#  
#  pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, type="response") , reverse=T )
#  confint( pairs( emmeans( f1, "ftyme", by="trt", vcov=V, df=dfe, type="response") , reverse=T ) )
#  
