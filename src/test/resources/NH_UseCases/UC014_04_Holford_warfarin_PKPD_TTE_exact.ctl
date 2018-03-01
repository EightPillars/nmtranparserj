$PROB Estimate time to event
; Model based on
; PK: Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
; TTE: Holford NHG. A Time to Event Tutorial for Pharmacometricians. CPT: pharmacomet syst pharmacol. 2013;2:e43 doi:10.1038/psp.2013.18.
$INPUT ID TIME TRT 
AMT RATX=DROP ADDL II
WT DVID DV MDV REP=DROP
CPX=DROP PCAX=DROP INRX=DROP ; individual predictions of CP, PCA, INR
ICL=DROP IV=DROP ITABS=DROP ITLAG=DROP IF1=DROP; individual PK parameters used for simulation
IPCA0=DROP IEMAX=DROP IC50=DROP ITEQ=DROP ; individual PD parameters used for simulation 
$DATA ../data/warfarin_TTE_PKPD_exact.csv IGNORE=#

$ESTIM MAX=9990 SIG=3 NOABORT ;PRINT=1
METHOD=COND LAPLACE NUMERICAL SLOW
$COV

$THETA
(0.001,0.1,) FIX ; POP_CL units="L/h/70kg"
(0.001,8,)   FIX ; POP_V units="L/70kg"
(0.001,0.362,) FIX ; POP_KA units="1/h"
(0.001,1, ) FIX ; POP_TLAG units="h"
0.75 FIX ; POP_BETA_CL_WT
1 FIX ; POP_BETA_V_WT
(0.01,96.7,200) FIX ; POP_PCA0
-1 FIX ; POP_EMAX
(0.01,1.2,10) FIX ; POP_C50 units="mg/L"
(0.01,12.9,100) FIX ; POP_TEQ units="h"
(0,0.1,) FIX ; RUV_C_PROP
(0,0.1,) FIX ; RUV_C_ADD units="mg/L"
(0,4,) FIX ; RUV_E_ADD

$OMEGA BLOCK(2) SD CORRELATION 
0.1 ; PPV_CL
.01 0.1 FIX ; PPV_V
$OMEGA
0.1 SD FIX ; PPV_KA
0 SD FIX ; PPV_TLAG
0.005 SD FIX ; PPV_PCA0
0.2 SD FIX ; PPV_C50
0.02 SD FIX ; PPV_TEQ

$SIGMA 1 FIX ; RUV_EPS1

;Event hazard
$THETA
(0.1,10,) ; POP_LBASE 1/y baseline hazard
0 FIX ; POP_BTAINR hazard ratio increase with INR

$SUBR ADVAN13 TOL=9
$MODEL
   COMP=GUT
   COMP=CENTRAL
   COMP=PCAAMT
;@MCL_start_IGNORE
   COMP=CHZEVT
;@MCL_end_IGNORE

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
   LBASE=POP_LBASE
   BTAINR=POP_BTAINR
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
;@MCL_start_IGNORE
   DADT(4)=LBASE*EXP(BTAINR*PCA0/A(3))
;@MCL_end_IGNORE

$ERROR

;@MCL_start_IGNORE
   IF (NEWIND.LE.1) THEN
      CEVTZ=0 ; For RTTE
   ENDIF
;@MCL_end_IGNORE

   CC=A(2)/V
   PCA=A(3)
   INR=PCA0/PCA

;@MCL_start_IGNORE
   PROPC=CC*RUV_C_PROP
   ADDC=RUV_C_ADD
   SDCC=ADDC+PROPC
;@MCL_"         CC_obs : { type = continuous, error = combinedError1(additive = RUV_C_ADD, proportional = RUV_C_PROP, f = CC), eps = eps_RUV_EPS1, prediction = CC } 
;@MCL_end_IGNORE
   IF (DVID.EQ.1) THEN ; Warfarin conc
      F_FLAG=0
      Y=CC + SDCC*RUV_EPS1
   ENDIF
;@MCL_"         PCA_obs : { type = continuous, error = additiveError(additive = RUV_E_ADD), eps = eps_RUV_EPS1, prediction = PCA } 
   IF (DVID.EQ.2) THEN ; PCA
      F_FLAG=0
      Y=PCA + RUV_E_ADD*RUV_EPS1
   ENDIF

;@MCL_start_IGNORE
   CEVTT=A(4)
   CDEVT=CEVTT-CEVTZ  ; CUMHAZ since last event
   SEVTT=EXP(-CDEVT) ; Probability of not having event at this time
;@MCL_end_IGNORE

   HAZEVT=LBASE*EXP(BTAINR*INR)

;@MCL_start_IGNORE
   IF (DVID.EQ.3.AND.DV.EQ.0) THEN
      F_FLAG=1
      Y1=SEVTT ; likelihood of censored event
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1) THEN 
      F_FLAG=1
      Y1=SEVTT * HAZEVT ; likelihood of event at exact time
      CEVTZ=CEVTT ; CUMHAZ at start of new event interval for RTTE
   ELSE ; in case event hazard includes random variable
      CEVTZ=CEVTZ
   ENDIF
;@MCL_end_IGNORE

   IF (DVID.EQ.3.AND.DV.EQ.0) THEN 
      F_FLAG=1
      Y=Y1 ; likelihood of censored event
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1) THEN 
      F_FLAG=1
      Y=Y1 ; likelihood of event at exact time
   ENDIF

;@MCL_"         Y1_obs : {type=tte, hazard = HAZEVT, event=exact}

$TABLE ID TIME WT ; covariates
CL V KA TLAG PCA0 EMAX C50 TEQ ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit
