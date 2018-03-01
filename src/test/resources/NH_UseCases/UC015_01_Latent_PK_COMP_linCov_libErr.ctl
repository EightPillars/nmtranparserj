$PROB UseCase
;Model based on:
; Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
;Data obtained from:
; O'Reilly RA, Aggeler PM, Leong LS. Studies of the coumarin anticoagulant drugs: The pharmacodynamics of warfarin in man. Journal of Clinical Investigation 1963;42(10):1542-1551
; O'Reilly RA, Aggeler PM. Studies on coumarin anticoagulant drugs Initiation of warfarin therapy without a loading dose. Circulation 1968;38:169-177

$INPUT ID TIME WT AMT DVID DV MDV LOGTWT
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
0 FIX ; POP_TLAG units="h"
0.75 FIX ; POP_BETA_CL_WT
1 FIX ; POP_BETA_V_WT
(0.001,1,)  ; POP_KT units="1/h"
(0.001,0.1,)  ; POP_K1 units="1/h"
1 FIX ; POP_P1
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

$SUBR ADVAN5
$MODEL
   COMP=(GUT)
   COMP=(LATENT)
   COMP=(CENTRAL)
$PK
;@MCL_start_IGNORE
   MU_PPV_CL=LOG(POP_CL) + POP_BETA_CL_WT*logtWT
   MU_PPV_V=LOG(POP_V) + POP_BETA_V_WT*logtWT
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
   ALAG1=TLAG
   F1=POP_P1
   S3=V

;	    PKMACRO{
;		# defines two compartments a latent and central and two depots for dose.
;		# Dosing to latent compartment is oral bolus
;		# Dosing to central compartment is IV
;		DEP1 : { macro = iv, to=CENTRAL }
;		CENTRAL : { macro=compartment, volume=V}
;		{ macro = elimination, from=CENTRAL, cl=CL }
;		GUT : { macro=oral, ka=KA, p=F1, to=LATENT }
;		LATENT : { macro=compartment, volume=1 }
;		{ macro=transfer, from=LATENT, to=CENTRAL, kt=KT }
;		{ macro=elimination, from=LATENT, k=K1 }
;	    }
;	    SCALE = V
;	    CC = CENTRAL / V

   K12=KA ; transfer from GUT to LATENT
   K23=POP_KT ; transfer from LATENT to CENTRAL
   K20=POP_K1 ; elimination from LATENT
   K30=CL/V ; elimination from CENTRAL

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
CL V KA TLAG ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit

