
$PROB WARFARIN PK
;O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant
;drugs: The pharmacodynamics of warfarin in man.
;Journal of Clinical Investigation 1963;42(10):1542-1551

;O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs
;Initiation of warfarin therapy without a loading dose.
;Circulation 1968;38:169-177

$INPUT ID 
TIME ; units="h"
WT ; units="kg"
AGE ; units="y"
SEX
AMT ; units="mg"
SS
ADDL
II
DVID
DV ; units="mg/L"
MDV
$DATA ../data/warfarin_conc_SSADDL.csv IGNORE=#
IGNORE (DVID.EQ.2) ; ignore PCA observations

$EST METHOD=COND INTER  NSIG=3 SIGL=9
MAX=9990 NOABORT ;PRINT=1
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
;@MCL_start_COVARIATES
   LOGTWT=LOG(WT/70)
;@MCL_end_COVARIATES
;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + POP_BETA_CL_WT*LOGTWT
   MU_PPV_V=LOG(POP_V) + POP_BETA_V_WT*LOGTWT
   MU_PPV_KA=LOG(POP_KA)
   MU_PPV_TLAG=LOG(POP_TLAG)

   CL=EXP(MU_PPV_CL + PPV_CL)
   V=EXP(MU_PPV_V + PPV_V)
   KA=EXP(MU_PPV_KA + PPV_KA)
   TLAG=EXP(MU_PPV_TLAG + PPV_TLAG)
;@MCL_"     CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"     V : { type = linear, trans = log, pop = POP_V, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_V }
;@MCL_"     KA : { type = linear, trans = log, pop = POP_KA, ranEff = eta_PPV_KA }
;@MCL_"     TLAG : { type = linear, trans = log, pop = POP_TLAG, ranEff = eta_PPV_TLAG } 
;@MCL_end_IGNORE
;   ALAG1=TLAG

$DES
   IF (T>=TLAG) THEN
      ratein=A(1)*KA
   ELSE
      ratein=0
   ENDIF
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

$TABLE ID TIME WT SEX AGE ; covariates
CL V KA TLAG ; EBE estimates
DVID Y ; predictions
MDV
ONEHEADER NOPRINT FILE=warf.fit
