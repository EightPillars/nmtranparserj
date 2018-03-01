$PROB Ordered categorical outcome
$DATA ../data/category.csv
$INPUT ID TIMEX CP DV MDV 
$ESTIM MAXEVAL=9990 METHOD=COND LAPLACE LIKE NOABORT 


$THETA 
(0,1,10) ; POP_BETA
 -1.09861 ; POP_Lgt0
 1.09861  ; POP_Lgt1
 1.09861  ; POP_Lgt2

$OMEGA
0.04 ; PPV_EVENT

$PRED
  BETA=POP_BETA
; Effect of drug
  EDRUG=BETA*CP

; Compute cumulative logit
  B0=POP_LGT0
  B1=B0 + POP_LGT1
  B2=B1 + POP_LGT2

; A0 - A2 are the cumulative logits with subject-specific random effects
  A0=B0 + EDRUG + PPV_EVENT
  A1=B1 + EDRUG + PPV_EVENT
  A2=B2 + EDRUG + PPV_EVENT

;@MCL_start_IGNORE
;Avoids overflow for computing ODDS when P1 is essentially 1
  IF(A0.GT.50) EXIT 1 1
  IF(A1.GT.50) EXIT 1 2
  IF(A2.GT.50) EXIT 1 3
;@MCL_end_IGNORE

;@MCL_$ERROR

; P0 - P2 are the cumulative probabilities
; p0=P(Y<=0), p1=P(Y<=1) =p0+p1, p2=P(Y<=2) =p0+p1+p2

  P0=1/(1+EXP(-A0))
  P1=1/(1+EXP(-A1))
  P2=1/(1+EXP(-A2))

;@MCL_start_IGNORE
; exit if the probabilities are not ordered correctly
   IF (P0.GE.P1) EXIT 1 101
   IF (P1.GE.P2) EXIT 1 102
   IF (P2.GE.1)  EXIT 1 103
;@MCL_end_IGNORE

   PROB0 = P0
   PROB1 = P1 - P0
   PROB2 = P2 - P1
   PROB3 = 1 - P2

;@MCL_start_IGNORE
   IF (DV.EQ.0) THEN
      DVID=DV+1
      Y1=PROB0
   ENDIF
   IF (DV.EQ.1) THEN
      DVID=DV+1
      Y1=PROB1
   ENDIF
   IF (DV.EQ.2) THEN
      DVID=DV+1
      Y1=PROB2
   ENDIF
   IF (DV.EQ.3) THEN
      DVID=DV+1
      Y1=PROB3
   ENDIF
;@MCL_end_IGNORE

  IF (DV.EQ.0) THEN
     Y=Y1
  ENDIF
  IF (DV.EQ.1) THEN
     Y=Y1
  ENDIF
  IF (DV.EQ.2) THEN
     Y=Y1
  ENDIF
  IF (DV.EQ.3) THEN
     Y=Y1
  ENDIF

;@MCL_"      Y : {type=categorical, categories=[0,1,2,3], probabilities=[PROB0, PROB1, PROB2, PROB3]} 

$TABLE ID TIMEX CP ; covariates
PROB0 PROB1 PROB2 PROB3 EDRUG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=usecase.fit
