$PROB USECASE
;Model based on:
; Holford NHG. The visual predictive check � superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
;Data obtained from:
; O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant drugs: The pharmacodynamics of warfarin in man. Journal of Clinical Investigation 1963;42(10):1542-1551
; O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs Initiation of warfarin therapy without a loading dose. Circulation 1968;38:169-177

$INPUT ID 
TIME ; units="h"
WT ; units="kg"
AMT ; units="mg"
DVID 
DV ; units="mg/L"
MDV 
LOGTWT
$DATA ../data/warfarin_conc.csv IGNORE=#

;$EST METHOD=SAEM AUTO=1
$EST METHOD=COND INTER 
NSIG=3 SIGL=9 
MAXEVAL=9990
$COV

$THETA
(0.001,0.1,) ; POP_CL units="L/h/70kg"
(0.001,8,)   ; POP_V units="L/70kg"
(0.001,0.362,) ; POP_KA units="1/h"
(0.001,1,) ; POP_TLAG units="h"
0.75 FIX ; POP_BETA_CL_WT
1 FIX ; POP_BETA_V_WT
(0,0.1,) ; RUV_PROP
(0,0.1,) ; RUV_ADD units "mg/L"

$OMEGA BLOCK(2) SD CORRELATION 
0.1 ; PPV_CL
.01 0.1 ; PPV_V
$OMEGA
0.1 SD ; PPV_KA
0 FIX SD ; PPV_TLAG

$SIGMA 
1 SD FIX ; EPS1

$SUBR ADVAN13 TOL=9
$MODEL
COMP (GUT)
COMP (CENTRAL)
$PK
;@MCL_start_IGNORE
   MU_1=LOG(THETA(1)) + THETA(5)*LOGTWT
   MU_2=LOG(THETA(2)) + THETA(6)*LOGTWT
   MU_3=LOG(THETA(3))
   MU_4=LOG(THETA(4))

   CL=EXP(MU_1 + ETA(1))
   V=EXP(MU_2 + ETA(2))
   KA=EXP(MU_3 + ETA(3))
   TLAG=EXP(MU_4 + ETA(4))
   S2=V

;@MCL_"     CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"     V : { type = linear, trans = log, pop = POP_V, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_V }
;@MCL_"     KA : { type = linear, trans = log, pop = POP_KA, ranEff = eta_PPV_KA }
;@MCL_"     TLAG : { type = linear, trans = log, pop = POP_TLAG, ranEff = eta_PPV_TLAG } 
;@MCL_end_IGNORE

$DES
   IF (T>=TLAG) THEN
      RATEIN=A(1)*KA
   ELSE
      RATEIN=0
   ENDIF
   DADT(1)=-RATEIN
   DADT(2)=RATEIN - CL*A(2)/V

$ERROR
   CC=A(2)/V

;@MCL_start_IGNORE
   PROP=CC*THETA(7)
   ADD=THETA(8)
   SDCC=ADD+PROP
;@MCL_"         CC_obs : { type = continuous, error = combinedError1(additive = RUV_ADD, proportional = RUV_PROP, f = CC), eps = eps_RUV_EPS1, prediction = CC } 
;@MCL_end_IGNORE
   Y=CC + SDCC*ERR(1)

$TABLE ID TIME WT LOGTWT ; covariates
CL V KA TLAG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

