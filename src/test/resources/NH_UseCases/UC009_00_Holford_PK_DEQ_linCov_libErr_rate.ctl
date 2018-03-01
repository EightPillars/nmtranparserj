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
RATE ; units="mg/h"
DV ; units="mg/L"
LOGTWT
MDV
$DATA ../data/warfarin_infusion.csv IGNORE=#

;$EST METHOD=SAEM AUTO=1
$EST METHOD=COND INTER 
NSIG=3 SIGL=9 
MAXEVAL=9990
$COV

$THETA
(0.001,0.1,) ; POP_CL units="L/h/70kg"
(0.001,8,)   ; POP_V units="L/70kg"
0.75 FIX ; BETA_CL_WT
1 FIX ; BETA_V_WT
(0,0.1,) ; RUV_PROP
(0,0.1,) ; RUV_ADD units "mg/L"

$OMEGA BLOCK(2) SD CORRELATION 
0.1 ; PPV_CL
.01 0.1 ; PPV_V

$SIGMA 
1 SD FIX ; EPS1

$SUBR ADVAN13 TOL=9
$MODEL
COMP (CENTRAL)
$PK

;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + BETA_CL_WT*logtWT
   MU_PPV_V=LOG(POP_V) + BETA_V_WT*logtWT

   CL=EXP(MU_PPV_CL + PPV_CL)
   V=EXP(MU_PPV_V + PPV_V)

;@MCL_"     CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"     V : { type = linear, trans = log, pop = POP_V, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_V }
;@MCL_end_IGNORE

$DES
   DADT(1)= - CL*A(1)/V

$ERROR
   CC=A(1)/V

   PROP=CC*RUV_PROP
   ADD=RUV_ADD
   SDCC=ADD+PROP
   Y=CC + SDCC*EPS1

   DVID=1

$TABLE ID TIME WT LOGTWT ; covariates
CL V ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

