;O'REILLY RA, AGGELER PM. STUDIES ON COUMARIN ANTICOAGULANT DRUGS
;INITIATION OF WARFARIN THERAPY WITHOUT A LOADING DOSE.
;CIRCULATION 1968;38:169-177
;
;O'REILLY RA, AGGELER PM, LEONG LS. STUDIES OF THE COUMARIN ANTICOAGULANT
;DRUGS: THE PHARMACODYNAMICS OF WARFARIN IN MAN.
;JOURNAL OF CLINICAL INVESTIGATION 1963;42(10):1542-1551
;

$PROB WARFARIN PK
$INPUT ID TIME WT AGE SEX AMT RATX DVID DV MDV
$DATA warfpk.csv IGNORE=#

$SUBR ADVAN2 TRANS2

$PK

   ; COVARIATE MODEL
   TVCL=THETA(1)*(WT/70)**0.75
   TVV=THETA(2)
   TVKA=THETA(3)
   TVLG=THETA(4)

   ; MODEL FOR RANDOM BETWEEN SUBJECT VARIABILITY
   CL=TVCL*EXP(ETA(1))
   V=TVV*EXP(ETA(2))
   KA=TVKA*EXP(ETA(3))
   ALAG1=TVLG*EXP(ETA(4))


   ; SCALE CONCENTRATIONS
   S2=V

$ERROR
   Y=F*EXP(EPS(1))+EPS(2)
   IPRED=F

$THETA
   (0.001,0.1) ; CL
   (0.001,8)   ; V
   (0.001,0.362) ; KA
   (0.001,1) ; LAG

$OMEGA
   0.1 ; PPVCL
   0.1 ; PPVV
   0.1 ; PPVKA
   0.1 ; PPVLAG

$SIGMA 
   0.1 ; RUVPROP
   0.1 ; RUVADD

$EST MAX=9990 SIG=3 PRINT=1 METHOD=COND INTER NOABORT
$COV

$TABLE ID TIME DVID Y 
ONEHEADER NOPRINT FILE=warf.fit

$TABLE ID WT SEX AGE CL V ETA(1) ETA(2) 
ONEHEADER NOAPPEND NOPRINT FILE=warf.fit




