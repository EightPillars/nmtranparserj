$PROB COUNT DATA
	
$INPUT
ID TIMEX CP DV MDV

$DATA ../data/count.csv
	IGNORE=#

$ESTIM MAXEVAL=9990 METHOD=COND LAPLACE -2LL NOABORT

$THETA
(0, 10,) ; POP_BASE
(0, .5,) ; POP_BETA

$OMEGA
0.04 ; PPV_EVENT
	
$PRED

;@MCL_start_IGNORE
BASE=POP_BASE
BETA=POP_BETA
COUNT = BASE+BETA*CP+PPV_EVENT
;@MCL_"      COUNT: {type=linear, trans=log, pop=POP_BASE, fixEff={coeff = POP_BETA, cov=CP}, ranEff=eta_PPV_EVENT} 
;@MCL_end_IGNORE

;@MCL_$ERROR

;@MCL_start_IGNORE
   IF (DV.GT.0) THEN
      LDVFAC=GAMLN(DV+1)
   ELSE
      LDVFAC=0
   ENDIF
   Y1=-2*(-COUNT+DV*LOG(COUNT)-LDVFAC)
;@MCL_end_IGNORE
   Y=Y1
;@MCL_"	  Y : { type = count, distn = ~ Poisson(lambda = COUNT), link = identity }
   DVID=1

$TABLE ID TIMEX CP ; covariates
BASE BETA ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=usecase.fit
