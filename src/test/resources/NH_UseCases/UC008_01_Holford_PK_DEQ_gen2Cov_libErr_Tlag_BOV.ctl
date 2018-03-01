$PROB UseCase
;Model based on:
; Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
;Data obtained from:
; O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant drugs: The pharmacodynamics of warfarin in man. Journal of Clinical Investigation 1963;42(10):1542-1551
; O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs Initiation of warfarin therapy without a loading dose. Circulation 1968;38:169-177

$INPUT ID TIME WT AGE SEX AMT OCC DV MDV
$DATA ../data/warfarin_conc_bov_P4.csv IGNORE=#
;IGNORE=(ID.EQ.27,ID.EQ.29,ID.EQ.31)
;$EST METHOD=SAEM AUTO=1
$EST METHOD=COND INTER 
NSIG=3 SIGL=9 
MAXEVAL=9990
$COV

$THETA
(0.001,0.1,) ; POP_CL units="L/h/70kg"
(0.001,8,)   ; POP_V units="L/70kg"
(0.001,2,) ; POP_KA units="1/h"
(0.001,1,) ; POP_TLAG units="h"
0.75 FIX ; POP_BETA_CL_WT
1 FIX ; POP_BETA_V_WT
(0,0.03,) ; RUV_PROP Simulation coded as variance 0.01
(0,0.5,) ; RUV_ADD Simulation coded as variance 0.05

$OMEGA
0.1 ; BSV_CL
0.1 ; BSV_V

$OMEGA BLOCK(2) 
0.1  ; BOV_CL
0.01 0.1 FIX; BOV_V
$OMEGA BLOCK(2) SAME
;; BOV_CL2
;; BOV_V2

$OMEGA
0.1 ; BSV_KA
0 FIX ; BSV_TLAG

$OMEGA BLOCK(1)
0.1 ; BOV_KA
$OMEGA BLOCK(1) SAME
;; BOV_KA2

$SIGMA 
1 FIX ; EPS1

$SUBR ADVAN13 TOL=9
$MODEL
COMP (GUT)
COMP (CENTRAL)
$PK

   LOGTWT=LOG(WT/70)
   GRP_CL=POP_CL*(WT/70)**POP_BETA_CL_WT
   GRP_V=POP_V*WT/70**POP_BETA_V_WT
   GRP_KA=POP_KA
   GRP_TLAG=POP_TLAG

   IF (OCC.EQ.1) THEN
      BOV_CL=BOV_CL
      BOV_V=BOV_V
      BOV_KA=BOV_KA
   ENDIF
   IF (OCC.EQ.2) THEN
      BOV_CL=BOV_CL2
      BOV_V=BOV_V2
      BOV_KA=BOV_KA2
   ENDIF

;@MCL_start_IGNORE
   CL=GRP_CL*EXP(BSV_CL+BOV_CL)
   V=GRP_V*EXP(BSV_V+BOV_V)
   KA=GRP_KA*EXP(BSV_KA+BOV_KA)
   TLAG=GRP_TLAG*EXP(BSV_TLAG)
;@MCL_"     CL :   {type=general, trans=log, pop=GRP_CL, ranEff=[eta_BSV_CL,eta_BOV_CL]} ## Type 2 - Gaussian with general covariate model
;@MCL_"     V :    {type=general, trans=log, pop=GRP_V, ranEff=[eta_BSV_V,eta_BOV_V]}
;@MCL_"     KA :   {type=general, trans=log, pop = GRP_KA, ranEff = [eta_BSV_KA,eta_BOV_KA]}
;@MCL_"     TLAG : {type=general, trans=log, pop = GRP_TLAG, ranEff = [eta_BSV_TLAG]} 
;@MCL_end_IGNORE

$DES
   if (T>=TLAG) THEN
      ratein=A(1)*KA
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
CL V KA TLAG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

