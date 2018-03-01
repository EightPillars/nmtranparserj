; Script generated by the pharmML2Nmtran Converter v.0.4.0
; Source 	: PharmML 0.8.1
; Target 	: NMTRAN 7.3.0
; Model 	: fileef024c91855
; Model Name: Generated from MDL. MOG ID: outputMog
; Dated 	: Thu Dec 07 13:46:54 GMT 2017

$PROBLEM Generated from MDL. MOG ID: outputMog

$INPUT  ID TIME WT=DROP AMT DVID DV MDV LOGTWT
$DATA warfarin_conc.csv IGNORE=@
$SUBS ADVAN13 TOL=9

$MODEL 
COMP (COMP1 DEFDOSE) 	;GUT
COMP (COMP2) 	;CENTRAL



$PK 
POP_CL = THETA(1)
POP_V = THETA(2)
POP_KA = THETA(3)
POP_TLAG = THETA(4)
RUV_PROP = THETA(5)
RUV_ADD = THETA(6)
BETA_CL_WT = THETA(7)
BETA_V_WT = THETA(8)

ETA_CL = ETA(1)
ETA_V = ETA(2)
ETA_KA = ETA(3)
ETA_TLAG = ETA(4)

PPV_TLAG = 0.0 

MU_1 = LOG(POP_CL) + BETA_CL_WT * LOGTWT
CL =  EXP(MU_1 + ETA(1)) ;

MU_2 = LOG(POP_V) + BETA_V_WT * LOGTWT
V =  EXP(MU_2 + ETA(2)) ;

MU_3 = LOG(POP_KA)
KA =  EXP(MU_3 + ETA(3)) ;

MU_4 = LOG(POP_TLAG)
TLAG =  EXP(MU_4 + ETA(4)) ;

A_0(1) = 0
A_0(2) = 0

$DES 
GUT_DES = A(1)
CENTRAL_DES = A(2)
RATEIN_DES = 0 
IF (T.GE.TLAG) THEN
	RATEIN_DES = (GUT_DES*KA) 
ENDIF
CC_DES = (CENTRAL_DES/V)
DADT(1) = -(RATEIN_DES)
DADT(2) = (RATEIN_DES-((CL*CENTRAL_DES)/V))

$ERROR 
EPS_Y = EPS(1)

GUT = A(1)
CENTRAL = A(2)
RATEIN = 0 
IF (TIME.GE.TLAG) THEN
	RATEIN = (GUT*KA) 
ENDIF
CC = (CENTRAL/V)
IPRED = CC
W = RUV_ADD+RUV_PROP*IPRED
Y = IPRED+W*EPS_Y
IRES = DV - IPRED
IWRES = IRES/W

$THETA 
( 0.001 , 0.1 )	;POP_CL
( 0.001 , 8.0 )	;POP_V
( 0.001 , 0.362 )	;POP_KA
( 0.001 , 1.0 )	;POP_TLAG
( 0.0 , 0.1 )	;RUV_PROP
( 1.0E-4 , 0.1 )	;RUV_ADD
(0.75  FIX )	;BETA_CL_WT
(1.0  FIX )	;BETA_V_WT

$OMEGA BLOCK(2) CORRELATION SD
(0.1 )	;PPV_CL
(0.01 )	;CORR_CL_V
(0.1 )	;PPV_V

$OMEGA 
(0.1 SD )	;PPV_KA
(0.1  FIX SD )	;PPV_TLAG

$SIGMA 
1.0 FIX


$EST METHOD=COND INTER NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME AMT DVID MDV LOGTWT PRED RES WRES DV IPRED IRES IWRES Y NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID CL V KA TLAG ETA_CL ETA_V ETA_KA ETA_TLAG NOAPPEND NOPRINT FILE=patab

$TABLE  ID LOGTWT NOAPPEND NOPRINT FILE=cotab


