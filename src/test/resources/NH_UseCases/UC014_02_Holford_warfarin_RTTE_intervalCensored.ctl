$PROB Estimate time to event
; Model based on
; PK: Holford NHG. The visual predictive check – superiority to standard diagnostic (Rorschach) plots [www.page-meeting.org/?abstract=738]. PAGE. 2005;14
; TTE: Holford NHG. A Time to Event Tutorial for Pharmacometricians. CPT: pharmacomet syst pharmacol. 2013;2:e43 doi:10.1038/psp.2013.18.
$INPUT ID TIME TRT 
AMT RATE ADDL II
WT DVID DV MDV REP=DROP
CPX=DROP PCAX=DROP INRX=DROP ; inidividual predictions of CP, PCA, INR
ICL IV ITABS ITLAG IF1; individual PK parameters used for simulation
IPCA0 IEMAX IC50 ITEQ ; individual PD parameters used for simulation 
$DATA ../data/warfarin_RTTE_intervalCensored.csv IGNORE=#

$ESTIM MAX=9990 SIG=3 NOABORT ;PRINT=1
METHOD=ZERO LIKE
$COV


;Event hazard
$THETA
(0.1,10,) ; POP_LBASEEVT 1/y baseline hazard haemorrhagic event
0 FIX ; POP_BTAINR hazard ratio increase with INR

$OMEGA 0 FIX ; PPV_LBASEEVT

$SUBR ADVAN6 TOL=3
$MODEL
   COMP=CENTRAL
   COMP=PCA
   COMP=CHZEVT

$PK

   LN2=LOG(2)

   CL=ICL ;FSZCL*POP_CL*EXP(PPV_CL)*24 ; L/h -> L/d
   V=IV ;FSZV*POP_V*EXP(PPV_V)
   TABS=ITABS; POP_TABS*EXP(PPV_TABS)/24 ; h -> d
   TLAG=ITLAG; POP_LAG*EXP(PPV_LAG)/24 ; h -> d
   F1=IF1

   PCA0=IPCA0; POP_PCA0*EXP(PPV_PCA0)
   EMAX=IEMAX; POP_EMAX*EXP(PPV_EMAX)
   C50=IC50; POP_C50*EXP(PPV_C50)
   TEQ=ITEQ; POP_TEQ*EXP(PPV_TEQ)/24 ; h -> d

   LBASEEVT=POP_LBASEEVT/365 *EXP(PPV_LBASEEVT) ; 1/y -> 1/d
   BTAINR=POP_BTAINR 


   D1=TABS
   ALAG1=TLAG
   S1=V
   A_0(2)=PCA0
   KPCA=LN2/TEQ
   RPCA=PCA0*KPCA
   
$DES
   DCP=A(1)/V
   DPCA=A(2)
   DINR=PCA0/DPCA
   PD=1+EMAX*DCP/(C50+DCP)
   DHAZEVT=LBASEEVT*EXP(BTAINR*DINR)
   DADT(1)= - CL*DCP ; warfarin conc
   DADT(2)=RPCA*PD - KPCA*DPCA ; turnover for PCA
   DADT(3)=DHAZEVT

$ERROR

;@MCL_start_IGNORE
   IF (NEWIND.LE.1) THEN
      SEVTZ=1
      IEVTZ=0
      SDRPZ=1
      IDRPZ=0
      INTMETHOD=1
      CEVTZ=0 ; For RTTE
   ENDIF
;@MCL_end_IGNORE

   CP=A(1)/V
   PCA=A(2)
   INR=PCA0/PCA

   HAZEVT=LBASEEVT*EXP(BTAINR*INR)
;@MCL_start_IGNORE

   CEVTT=A(3)
   CDEVT=CEVTT-CEVTZ  ; CUMHAZ since last event
   SEVTT=EXP(-CDEVT) ; Probability of not having event at this time

   IF (DVID.EQ.3.AND.DV.EQ.0.AND.MDV.EQ.0) THEN ; Censored event or Method 2 start of interval
      Y1=SEVTT 
      IEVTZ=CEVTT
      INTMETHOD=2
   ELSE
      IEVTZ=IEVTZ
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.0.AND.MDV.EQ.1) THEN ; Method 1 start of interval
      SEVTZ=SEVTT 
      INTMETHOD=1
   ELSE
      SEVTZ=SEVTZ
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1.AND.INTMETHOD.EQ.1) THEN ; Event in interval
      Y1=SEVTZ-SEVTT
      CEVTZ=CEVTT ; CUMHAZ at start of new event interval for RTTE
   ELSE ; in case event hazard includes random variable
      CEVTZ=CEVTZ
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1.AND.INTMETHOD.EQ.2) THEN ; Event in interval
      Y1=1-EXP(-(CEVTT-IEVTZ))
      CEVTZ=CEVTT ; CUMHAZ at start of new event interval for RTTE
   ELSE ; in case event hazard includes random variable
      CEVTZ=CEVTZ
   ENDIF
;@MCL_end_IGNORE

   IF (DVID.EQ.3.AND.DV.EQ.0.AND.MDV.EQ.0) THEN ; Censored event or Method 2 start of interval
      Y=Y1 
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1.AND.INTMETHOD.EQ.1) THEN ; Event in interval method 1
      Y=Y1 
   ENDIF
   IF (DVID.EQ.3.AND.DV.EQ.1.AND.INTMETHOD.EQ.2) THEN ; Event in interval method 2
      Y=Y1
  ENDIF
;@MCL_"     Y : {type=tte, hazard = HAZEVT, event=intervalCensored, maxEvent=INF}

$TABLE ID TIME WT ; covariates
LBASEEVT BTAINR ; EBE estimates
DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit
