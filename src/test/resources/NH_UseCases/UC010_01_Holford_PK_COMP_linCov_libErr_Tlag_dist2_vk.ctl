$PROB UseCase
;Model based on:
; Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
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
(0.001,8,)   ; POP_VC units="L/70kg"
(0.001,0.2,) ; POP_Q units="L/h/70kg"
(0.001,20,)   ; POP_VP units="L/70kg"
(0.001,0.362,) ; POP_KA units="1/h"
(0.001,1,) ; POP_TLAG units="h"
0.75 FIX ; POP_BETA_CL_WT
1 FIX ; POP_BETA_V_WT
(0,0.1,) ; RUV_PROP
(0,0.1,) ; RUV_ADD units "mg/L"

$OMEGA BLOCK(2) SD CORRELATION 
0.1 ; PPV_CL
.01 0.1 ; PPV_VC
$OMEGA
0.1 SD ; PPV_Q
0.1 SD ; PPV_VP
0.1 SD ; PPV_KA
0 FIX SD ; PPV_TLAG

$SIGMA 
1 SD FIX ; EPS1

$SUB ADVAN4 TRANS1
$PK
;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + POP_BETA_CL_WT*logtWT
   MU_PPV_VC=LOG(POP_VC) + POP_BETA_V_WT*logtWT
   MU_PPV_Q=LOG(POP_Q) + POP_BETA_CL_WT*logtWT
   MU_PPV_VP=LOG(POP_VP) + POP_BETA_V_WT*logtWT
   MU_PPV_KA=LOG(POP_KA)
   MU_PPV_TLAG=LOG(POP_TLAG)

   CL=EXP(MU_PPV_CL + PPV_CL)
   VC=EXP(MU_PPV_VC + PPV_VC)
   Q=EXP(MU_PPV_Q + PPV_Q)
   VP=EXP(MU_PPV_VP + PPV_VP)
   KA=EXP(MU_PPV_KA + PPV_KA)
   TLAG=EXP(MU_PPV_TLAG + PPV_TLAG)
;@MCL_"     CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"     VC : { type = linear, trans = log, pop = POP_VC, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_VC }
;@MCL_"     Q : { type = linear, trans = log, pop = POP_Q, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_Q }
;@MCL_"     VP : { type = linear, trans = log, pop = POP_VP, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_VP }
;@MCL_"     KA : { type = linear, trans = log, pop = POP_KA, ranEff = eta_PPV_KA }
;@MCL_"     TLAG : { type = linear, trans = log, pop = POP_TLAG, ranEff = eta_PPV_TLAG } 
;@MCL_end_IGNORE
   ALAG1=TLAG
   V=VC
   K=CL/VC
   K23=Q/VC
   K32=Q/VP
   S2=VC

$ERROR
   CC=F

;@MCL_start_IGNORE
   PROP=CC*RUV_PROP
   ADD=RUV_ADD
   SDCC=ADD+PROP
;@MCL_"         CC_obs : { type = continuous, error = combinedError1(additive = RUV_ADD, proportional = RUV_PROP, f = CC), eps = eps_RUV_EPS1, prediction = CC } 
;@MCL_end_IGNORE
   Y=CC + SDCC*EPS1

$TABLE ID TIME WT LOGTWT ; covariates
CL VC Q VP KA TLAG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

