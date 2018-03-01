$PROB COUNT DATA

$INPUT
ID TIMEX CP DV MDV

$DATA ../data/binary.csv
IGNORE=#

$ESTIM MAXEVAL=9990 METHOD=COND LAPLACE LIKE NOABORT

$THETA
(0.01, 0.1, 0.99) ; POP_BASEP
(0, .5, 10) ; POP_BETA

$OMEGA
0.04 ; PPV_EVENT

$PRED
   BASE = LOG(POP_BASEP/(1-POP_BASEP))
   BETA=POP_BETA
   LP = BASE+BETA*CP+PPV_EVENT

;@MCL_$ERROR

   P1 = 1/(1+EXP(-LP)) ; invlogit(LP)
;@MCL_start_IGNORE
   IF (DV.EQ.1) THEN
      DVID=DV+1
      Y1=P1
   ELSE
      DVID=DV+1
      Y1=1-P1
   ENDIF
;@MCL_"      P1 : {type=linear, trans=logit, pop=POP_BASEP, fixEff={coeff=POP_BETA, cov=CP}, ranEff=eta_PPV_EVENT}
;@MCL_end_IGNORE
  IF (DV.EQ.0) THEN
     Y=Y1
  ENDIF
  IF (DV.EQ.1) THEN
     Y=Y1
  ENDIF
;@MCL_"      Y : { type=discrete, distn = ~ Bernoulli(probability=P1), link=identity}

$TABLE ID TIMEX CP ; covariates
BASE BETA ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=usecase.fit
