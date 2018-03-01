$PROB UseCase
;Model based on:
; Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
;Data obtained from:
; O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant drugs: The pharmacodynamics of warfarin in man. Journal of Clinical Investigation 1963;42(10):1542-1551
; O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs Initiation of warfarin therapy without a loading dose. Circulation 1968;38:169-177

$INPUT ID TIME WT AGE SEX AMT DVID DV MDV
$DATA ../data/warfarin_conc_sex.csv IGNORE=#

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
0.001 ; POP_BETA_CL_AGE
(0,1,) ; POP_BETA_CL_FEM
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
   female=0
;@MCL_end_IGNORE
   FSIZE_V=WT/70**POP_BETA_V_WT
   FSIZE_CL=(WT/70)**POP_BETA_CL_WT
   FAGE_CL=EXP(POP_BETA_CL_AGE*(AGE-40))
   IF (SEX.EQ.female) THEN
      FSEX_CL=POP_BETA_CL_FEM
   ELSE
      FSEX_CL=1
   ENDIF
   GRP_CL=POP_CL*FSIZE_CL*FAGE_CL*FSEX_CL
   GRP_V=POP_V*FSIZE_V
   GRP_KA=POP_KA
   GRP_TLAG=POP_TLAG

;@MCL_start_IGNORE
   CL=GRP_CL*EXP(PPV_CL)
   V=GRP_V*EXP(PPV_V)
   KA=GRP_KA*EXP(PPV_KA)
   TLAG=GRP_TLAG*EXP(PPV_TLAG)
;@MCL_"     CL :   {type=general, trans=log, pop=GRP_CL, ranEff=eta_PPV_CL} ## Type 2 - Gaussian with general covariate model
;@MCL_"     V  :   {type=general, trans=log, pop=GRP_V, ranEff=eta_PPV_V}
;@MCL_"     KA :   {type=general, trans=log, pop = GRP_KA, ranEff = eta_PPV_KA}
;@MCL_"     TLAG : {type=general, trans=log, pop = GRP_TLAG, ranEff = eta_PPV_TLAG} 
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

$TABLE ID TIME WT SEX AGE ; covariates
CL V KA TLAG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

