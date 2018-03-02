; Script generated by the pharmML2Nmtran Converter v.0.3.0
; Source	: PharmML 0.6.1
; Target	: NMTRAN 7.3.0
; Model 	: Hamren_COV
; Dated 	: Sat Nov 14 15:41:06 CET 2015

$PROBLEM "generated by MDL2PharmML v.6.0"

$INPUT  ID TIME=TIME DV AMT RATE CMT CL V SEX TREAT ORIG EVID DOSE=DROP
$DATA "hamren2008_data_DAY.csv" IGNORE=#
$SUBS ADVAN13 TOL=9

$MODEL 
COMP (COMP1) 	;QP
COMP (COMP2) 	;FPG
COMP (COMP3) 	;NON_RBC1
COMP (COMP4) 	;NON_RBC2
COMP (COMP5) 	;NON_RBC3
COMP (COMP6) 	;NON_RBC4
COMP (COMP7) 	;RBC1
COMP (COMP8) 	;RBC2
COMP (COMP9) 	;RBC3
COMP (COMP10) 	;RBC4
COMP (COMP11) 	;VHB


$PK 
BETA_FPG_BASELINE = THETA(1)
POP_FPG_BASELINE_N = THETA(2)
K_OUT_FPG = THETA(3)
E_MAX_FPG = THETA(4)
BETA_EC_50_FPG = THETA(5)
POP_EC_50_FPG_F = THETA(6)
BETA_FPG_WASHOUT = THETA(7)
POP_RES_FPG = THETA(8)
POP_GAMMA = THETA(9)
K_GLUCOSE = THETA(10)
RBC_LIFESPAN = THETA(11)
BETA_K_IN_RBC = THETA(12)
POP_K_IN_RBC_F = THETA(13)
E_MAX_DILUTION = THETA(14)
POP_EC_50_DILUTION = THETA(15)
K_OUT_DILUTION = THETA(16)
POP_RES_HBA1C = THETA(17)
POP_RES_HB = THETA(18)
POP_FPG_WASHOUT_N = THETA(19)

ETA_FPG_BASELINE =  ETA(1)
ETA_EC_50_FPG =  ETA(2)
ETA_FPG_WASHOUT =  ETA(3)
ETA_RES_FPG =  ETA(4)
ETA_GAMMA =  ETA(5)
ETA_K_IN_RBC =  ETA(6)
ETA_EC_50_DILUTION =  ETA(7)
ETA_RES_HBA1C =  ETA(8)
ETA_RES_HB =  ETA(9)

IF (SEX.EQ.2) THEN
	POP_EC_50_FPG = POP_EC_50_FPG_F 
ELSE
	POP_EC_50_FPG = (POP_EC_50_FPG_F+BETA_EC_50_FPG) 
ENDIF
 

IF (SEX.EQ.2) THEN
	POP_K_IN_RBC = POP_K_IN_RBC_F 
ELSE
	POP_K_IN_RBC = (POP_K_IN_RBC_F+BETA_K_IN_RBC) 
ENDIF
 

IF (TREAT.EQ.1) THEN
	POP_FPG_BASELINE = POP_FPG_BASELINE_N 
ELSE
	POP_FPG_BASELINE = (POP_FPG_BASELINE_N+BETA_FPG_BASELINE) 
ENDIF
 

IF (TREAT.EQ.1) THEN
	POP_FPG_WASHOUT = POP_FPG_WASHOUT_N 
ELSE
	POP_FPG_WASHOUT = (POP_FPG_WASHOUT_N+BETA_FPG_WASHOUT) 
ENDIF
 


FPG_BASELINE = (POP_FPG_BASELINE*EXP(ETA_FPG_BASELINE))

EC_50_FPG = (POP_EC_50_FPG*EXP(ETA_EC_50_FPG))

FPG_WASHOUT = (POP_FPG_WASHOUT*EXP(ETA_FPG_WASHOUT))

RES_FPG = (POP_RES_FPG*EXP(ETA_RES_FPG))

GAMMA = (POP_GAMMA*EXP(ETA_GAMMA))

K_IN_RBC = (POP_K_IN_RBC*EXP(ETA_K_IN_RBC))

EC_50_DILUTION = (POP_EC_50_DILUTION*EXP(ETA_EC_50_DILUTION))

RES_HBA1C = (POP_RES_HBA1C*EXP(ETA_RES_HBA1C))

RES_HB = (POP_RES_HB*EXP(ETA_RES_HB))

K_IN_FPG = (K_OUT_FPG*FPG_BASELINE)

K_TR = (4/RBC_LIFESPAN)

NON_RBC10 = (K_IN_RBC/(K_TR+(K_GLUCOSE*(FPG_BASELINE**GAMMA))))

NON_RBC20 = ((K_TR*NON_RBC10)/(K_TR+(K_GLUCOSE*(FPG_BASELINE**GAMMA))))

NON_RBC30 = ((K_TR*NON_RBC20)/(K_TR+(K_GLUCOSE*(FPG_BASELINE**GAMMA))))

NON_RBC40 = ((K_TR*NON_RBC30)/(K_TR+(K_GLUCOSE*(FPG_BASELINE**GAMMA))))

RBC10 = (((K_GLUCOSE*(FPG_BASELINE**GAMMA))*NON_RBC10)/K_TR)

RBC20 = ((((K_GLUCOSE*(FPG_BASELINE**GAMMA))*NON_RBC20)+(K_TR*RBC10))/K_TR)

RBC30 = ((((K_GLUCOSE*(FPG_BASELINE**GAMMA))*NON_RBC30)+(K_TR*RBC20))/K_TR)

RBC40 = ((((K_GLUCOSE*(FPG_BASELINE**GAMMA))*NON_RBC40)+(K_TR*RBC30))/K_TR)

KOUT = (CL/V)

A_0(1) = 0
A_0(2) = FPG_BASELINE
A_0(3) = NON_RBC10
A_0(4) = NON_RBC20
A_0(5) = NON_RBC30
A_0(6) = NON_RBC40
A_0(7) = RBC10
A_0(8) = RBC20
A_0(9) = RBC30
A_0(10) = RBC40
A_0(11) = 1

$DES 
QP_DES = A(1)
FPG_DES = A(2)
NON_RBC1_DES = A(3)
NON_RBC2_DES = A(4)
NON_RBC3_DES = A(5)
NON_RBC4_DES = A(6)
RBC1_DES = A(7)
RBC2_DES = A(8)
RBC3_DES = A(9)
RBC4_DES = A(10)
VHB_DES = A(11)
CP_DES = (QP_DES/V)
TOTRBC_DES = (((((((NON_RBC1_DES+NON_RBC2_DES)+NON_RBC3_DES)+NON_RBC4_DES)+RBC1_DES)+RBC2_DES)+RBC3_DES)+RBC4_DES)
GLYRBC_DES = (((RBC1_DES+RBC2_DES)+RBC3_DES)+RBC4_DES)
HBA1C_DES = ((100*GLYRBC_DES)/TOTRBC_DES)
HB_DES = (TOTRBC_DES/VHB_DES)
LOGHBA1C_DES = LOG(HBA1C_DES)
LOGFPG_DES = LOG(FPG_DES)
LOGHB_DES = LOG(HB_DES)
DADT(1) = (-(KOUT)*QP_DES)
DADT(2) = ((K_IN_FPG*(1+FPG_WASHOUT))-((K_OUT_FPG*FPG_DES)*(1+((E_MAX_FPG*CP_DES)/(EC_50_FPG+CP_DES)))))
DADT(3) = (K_IN_RBC-((K_TR+(K_GLUCOSE*(FPG_DES**GAMMA)))*NON_RBC1_DES))
DADT(4) = ((K_TR*NON_RBC1_DES)-((K_TR+(K_GLUCOSE*(FPG_DES**GAMMA)))*NON_RBC2_DES))
DADT(5) = ((K_TR*NON_RBC2_DES)-((K_TR+(K_GLUCOSE*(FPG_DES**GAMMA)))*NON_RBC3_DES))
DADT(6) = ((K_TR*NON_RBC3_DES)-((K_TR+(K_GLUCOSE*(FPG_DES**GAMMA)))*NON_RBC4_DES))
DADT(7) = (((K_GLUCOSE*(FPG_DES**GAMMA))*NON_RBC1_DES)-(K_TR*RBC1_DES))
DADT(8) = ((((K_GLUCOSE*(FPG_DES**GAMMA))*NON_RBC2_DES)+(K_TR*RBC1_DES))-(K_TR*RBC2_DES))
DADT(9) = ((((K_GLUCOSE*(FPG_DES**GAMMA))*NON_RBC3_DES)+(K_TR*RBC2_DES))-(K_TR*RBC3_DES))
DADT(10) = ((((K_GLUCOSE*(FPG_DES**GAMMA))*NON_RBC4_DES)+(K_TR*RBC3_DES))-(K_TR*RBC4_DES))
DADT(11) = (K_OUT_DILUTION*((1+((E_MAX_DILUTION*CP_DES)/(EC_50_DILUTION+CP_DES)))-VHB_DES))

$ERROR 
QP = A(1)
FPG = A(2)
NON_RBC1 = A(3)
NON_RBC2 = A(4)
NON_RBC3 = A(5)
NON_RBC4 = A(6)
RBC1 = A(7)
RBC2 = A(8)
RBC3 = A(9)
RBC4 = A(10)
VHB = A(11)
CP = (QP/V)
TOTRBC = (((((((NON_RBC1+NON_RBC2)+NON_RBC3)+NON_RBC4)+RBC1)+RBC2)+RBC3)+RBC4)
GLYRBC = (((RBC1+RBC2)+RBC3)+RBC4)
HBA1C = ((100*GLYRBC)/TOTRBC)
HB = (TOTRBC/VHB)
LOGHBA1C = LOG(HBA1C)
LOGFPG = LOG(FPG)
LOGHB = LOG(HB)

IF(ORIG.EQ.1) THEN
	IPRED = LOGHBA1C
W = RES_HBA1C
Y = IPRED+W*EPS(1)
IRES = DV - IPRED
IWRES = IRES/W

ENDIF

IF(ORIG.EQ.2) THEN
	IPRED = LOGFPG
W = RES_FPG
Y = IPRED+W*EPS(1)
IRES = DV - IPRED
IWRES = IRES/W

ENDIF

IF(ORIG.EQ.3) THEN
	IPRED = LOGHB
W = RES_HB
Y = IPRED+W*EPS(1)
IRES = DV - IPRED
IWRES = IRES/W

ENDIF

$THETA 
(-0.52 )	;BETA_FPG_BASELINE
( 6.0 , 8.72 , 10.0 )	;POP_FPG_BASELINE_N
( 1.0E-4 , 0.0367 , 0.1 )	;K_OUT_FPG
( 0.4 , 0.698 , 0.99 )	;E_MAX_FPG
( 0.0 , 0.6 )	;BETA_EC_50_FPG
( 0.2 , 0.88 , 4.0 )	;POP_EC_50_FPG_F
( 0.01 , 0.164 , 1.0 )	;BETA_FPG_WASHOUT
( 0.01 , 0.0964 , 0.2 )	;POP_RES_FPG
( 0.4 , 0.743 , 1.5 )	;POP_GAMMA
( 0.0 , 1.81E-4 )	;K_GLUCOSE
( 1.0 , 135.0 , 333.0 )	;RBC_LIFESPAN
( 0.0 , 0.09 )	;BETA_K_IN_RBC
( 0.1 , 1.02 , 2.0 )	;POP_K_IN_RBC_F
( 0.0 , 0.682 , 1.0 )	;E_MAX_DILUTION
( 0.01 , 8.25 , 20.0 )	;POP_EC_50_DILUTION
( 0.0 , 0.0305 )	;K_OUT_DILUTION
( 0.0 , 0.0495 , 0.1 )	;POP_RES_HBA1C
( 0.0 , 0.0298 , 0.1 )	;POP_RES_HB
(0.0  FIX )	;POP_FPG_WASHOUT_N

$OMEGA 
(0.0196 )	;OMEGA_FPG_BASELINE
(1.21 )	;OMEGA_EC_50_FPG
(0.64 )	;OMEGA_FPG_WASHOUT
(0.13 )	;OMEGA_RES_FPG
(0.0035 )	;OMEGA_GAMMA
(0.005 )	;OMEGA_K_IN_RBC
(0.31 )	;OMEGA_EC_50_DILUTION
(0.068 )	;OMEGA_RES_HBA1C
(0.029 )	;OMEGA_RES_HB


$SIGMA 
1.0 FIX	;SIGMA_RES_HBA1C

1.0 FIX	;SIGMA_RES_FPG

1.0 FIX	;SIGMA_RES_HB



$EST METHOD=COND NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME AMT RATE CMT CL V SEX TREAT ORIG EVID PRED IPRED RES IRES WRES IWRES Y DV NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID FPG_BASELINE EC_50_FPG FPG_WASHOUT RES_FPG GAMMA K_IN_RBC EC_50_DILUTION RES_HBA1C RES_HB K_IN_FPG K_TR NON_RBC10 NON_RBC20 NON_RBC30 NON_RBC40 RBC10 RBC20 RBC30 RBC40 KOUT ETA_FPG_BASELINE ETA_EC_50_FPG ETA_FPG_WASHOUT ETA_RES_FPG ETA_GAMMA ETA_K_IN_RBC ETA_EC_50_DILUTION ETA_RES_HBA1C ETA_RES_HB NOAPPEND NOPRINT FILE=patab

$TABLE  ID CL V SEX TREAT NOAPPEND NOPRINT FILE=cotab


