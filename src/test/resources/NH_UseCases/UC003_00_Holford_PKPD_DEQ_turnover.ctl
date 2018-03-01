$PROB UseCase
;Model based on:
; Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
;Data obtained from:
; O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant drugs: The pharmacodynamics of warfarin in man. Journal of Clinical Investigation 1963;42(10):1542-1551
; O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs Initiation of warfarin therapy without a loading dose. Circulation 1968;38:169-177

$INPUT ID TIME WT AGE SEX AMT DVID DV MDV
$DATA ../data/warfarin_conc_pca.csv
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
(0.01,96.7,200) ; POP_PCA0
-1 FIX ; POP_EMAX
(0.01,1.2,10) ; POP_C50 units="mg/L"
(0.01,12.9,100) ; POP_TEQ units="h"
(0,0.05,) ; RUV_C_PROP
(0,0.3,) ; RUV_C_ADD
(0,4,) ; RUV_E_ADD

$OMEGA BLOCK(2) SD CORRELATION 
0.1 ; PPV_CL
.01 0.1 ; PPV_V
$OMEGA
0.1 SD ; PPV_KA
0 FIX SD ; PPV_TLAG
0.005 SD ; PPV_PCA0
0.2 SD ; PPV_C50
0.02 SD ; PPV_TEQ

$SIGMA 1 FIX ; RUV_EPS1

$SUBR ADVAN13 TOL=9
$MODEL
   COMP=GUT
   COMP=CENTRAL
   COMP=PCAAMT
$PK
;@MCL_start_COVARIATES
   LOGTWT=LOG(WT/70)
;@MCL_end_COVARIATES

;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + POP_BETA_CL_WT*LOGTWT
   MU_PPV_V=LOG(POP_V) + POP_BETA_V_WT*LOGTWT
   MU_PPV_KA=LOG(POP_KA)
   MU_PPV_TLAG=LOG(POP_TLAG)

   MU_PPV_PCA0=LOG(POP_PCA0)
   MU_PPV_C50=LOG(POP_C50)
   MU_PPV_TEQ=LOG(POP_TEQ)

   CL=EXP(MU_PPV_CL + PPV_CL)
   V=EXP(MU_PPV_V + PPV_V)
   KA=EXP(MU_PPV_KA + PPV_KA)
   TLAG=EXP(MU_PPV_TLAG + PPV_TLAG)

   PCA0=EXP(MU_PPV_PCA0 + PPV_PCA0)
   C50=EXP(MU_PPV_C50 + PPV_C50)
   TEQ=EXP(MU_PPV_TEQ + PPV_TEQ)
   
;@MCL_"      CL : { type = linear, trans = log, pop = POP_CL, fixEff = [{coeff=POP_BETA_CL_WT, cov=LOGTWT}] , ranEff = eta_PPV_CL }
;@MCL_"      V : { type = linear, trans = log, pop = POP_V, fixEff = [{coeff=POP_BETA_V_WT, cov=LOGTWT}] , ranEff = eta_PPV_V }
;@MCL_"      KA : { type = linear, trans = log, pop = POP_KA, ranEff = eta_PPV_KA }
;@MCL_"      TLAG : { type = linear, trans = log, pop = POP_TLAG, ranEff = eta_PPV_TLAG } 
;@MCL_"      PCA0 : { type = linear, trans = log, pop = POP_PCA0, ranEff = eta_PPV_PCA0 } 
;@MCL_"      C50 : { type = linear, trans = log, pop = POP_C50, ranEff = eta_PPV_C50 } 
;@MCL_"      TEQ : { type = linear, trans = log, pop = POP_TEQ, ranEff = eta_PPV_TEQ } 
;@MCL_end_IGNORE

   EMAX=POP_EMAX
   S2=V
   A_0(3)=PCA0
   KPCA=LOG(2)/TEQ
   RPCA=PCA0*KPCA

$DES
   IF (T>=TLAG) THEN
      RATEIN=A(1)*KA
   ELSE
      RATEIN=0
   ENDIF

   PD=1+EMAX*A(2)/V/(C50+A(2)/V)

   DADT(1)=-RATEIN
   DADT(2)=RATEIN - CL*A(2)/V
   DADT(3)=RPCA*PD - KPCA*A(3)

$ERROR

   CC=A(2)/V
   PCA=A(3)

;@MCL_start_IGNORE
   PROPC=CC*RUV_C_PROP
   ADDC=RUV_C_ADD
   SDCC=ADDC+PROPC
;@MCL_"         CC_obs : { type = continuous, error = combinedError1(additive = RUV_C_ADD, proportional = RUV_C_PROP, f = CC), eps = eps_RUV_EPS1, prediction = CC } 
;@MCL_end_IGNORE
   IF (DVID.EQ.1) THEN ; Warfarin conc
      Y=CC + SDCC*RUV_EPS1
   ENDIF
;@MCL_"         PCA_obs : { type = continuous, error = additiveError(additive = RUV_E_ADD), eps = eps_RUV_EPS1, prediction = PCA } 
   IF (DVID.EQ.2) THEN ; PCA
      Y=PCA + RUV_E_ADD*RUV_EPS1
   ENDIF

$TABLE ID TIME DVID CC PCA Y
MDV
ONEHEADER NOPRINT FILE=ka1_pd.fit



