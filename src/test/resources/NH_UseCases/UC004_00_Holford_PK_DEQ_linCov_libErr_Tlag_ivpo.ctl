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
CMT
DV ; units="mg/L"
LOGTWT
MDV

$DATA ../data/warfarin_infusion_oral.csv IGNORE=#

;$EST METHOD=SAEM AUTO=1
$EST METHOD=COND INTER 
NSIG=3 SIGL=9 
MAXEVAL=9990
$COV

$THETA
(0.001,0.1) ; POP_CL  units="L/h/70kg"
(0.001,8)   ; POP_V  units="L/70kg"
(0.001,0.362) ; POP_KA units="1/h"
(0.001,1) ; POP_TLAG units="h"
(0,0.7,1) FIX ; POP_FORAL
0.75 FIX ; BETA_CL_WT
1 FIX ; BETA_V_WT
(0,0.05,) ; RUV_PROP
(0,0.3,) ; RUV_ADD

$OMEGA BLOCK(2) SD CORRELATION
0.1 ; PPV_CL
0.01 0.1 ; PPV_V
$OMEGA
0.1 SD ; PPV_KA
0 FIX SD ; PPV_TLAG
0.1 FIX SD ; PPV_FORAL

$SIGMA
1 FIX ; EPS1

$SUBR ADVAN13 TOL=9
$MODEL
COMP (GUT)
COMP (CENTRAL)
$PK

;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + BETA_CL_WT*logtWT
   MU_PPV_V=LOG(POP_V) + BETA_V_WT*logtWT
   MU_PPV_KA=LOG(POP_KA)
   MU_PPV_TLAG=LOG(POP_TLAG)
   MU_PPV_FORAL=LOG(POP_FORAL/(1-POP_FORAL))

   CL=EXP(MU_PPV_CL + PPV_CL)
   V=EXP(MU_PPV_V + PPV_V)
   KA=EXP(MU_PPV_KA + PPV_KA)
   TLAG=EXP(MU_PPV_TLAG + PPV_TLAG)
   LGTFO=MU_PPV_FORAL + PPV_FORAL
   FORAL=1/(1+EXP(-LGTFO))
   S2=V

;@MCL_"     CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"     V : { type = linear, trans = log, pop = POP_V, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_V }
;@MCL_"     KA : { type = linear, trans = log, pop = POP_KA, ranEff = eta_PPV_KA }
;@MCL_"     TLAG : { type = linear, trans = log, pop = POP_TLAG, ranEff = eta_PPV_TLAG } 
;@MCL_"     FORAL : { type = linear, trans = logit, pop = POP_FORAL, ranEff = eta_PPV_FORAL } 
;@MCL_end_IGNORE

$DES
   if (T>=TLAG) THEN
      ratein=A(1)*KA*FORAL
   else
      ratein=0
   endif
   DADT(1)=-ratein
   DADT(2)=ratein - CL*A(2)/V

$ERROR
   CC=A(2)/V

;@MCL_start_IGNORE
   PROP=CC*RUV_PROP
   ADD=RUV_ADD
   SDCC=ADD+PROP
;@MCL_"         CC_obs : { type = continuous, error = combinedError1(additive = RUV_ADD, proportional = RUV_PROP, f = CC), eps = eps_RUV_EPS1, prediction = CC } 
;@MCL_end_IGNORE
   Y=CC + SDCC*EPS1

   DVID=1

$TABLE ID TIME WT LOGTWT ; covariates
CL V KA TLAG FORAL ; EBE estimates
DVID Y MDV ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

