; Script generated by the pharmML2Nmtran Converter v.0.4.0
; Source 	: PharmML 0.8.1
; Target 	: NMTRAN 7.3.0
; Model 	: Madrasi_2014_HIV_tenofovir
; Model Name: Generated from MDL. MOG ID: madrasi2004_mog
; Dated 	: Thu Sep 01 21:56:36 CEST 2016

$PROBLEM Generated from MDL. MOG ID: madrasi2004_mog

$INPUT  ID TIME DV DOSE=AMT MDV CMT DVID
$DATA "Simulated_14dayMTN001.csv" IGNORE=@
$SUBS ADVAN13 TOL=9

$MODEL 
COMP (COMP1) 	;A1
COMP (COMP2) 	;A2
COMP (COMP3) 	;A3
COMP (COMP4) 	;A4
COMP (COMP5) 	;A5
COMP (COMP6) 	;A6



$PK 
POP_CL = THETA(1)
POP_V1 = THETA(2)
POP_V2 = THETA(3)
RUV_PROP = THETA(4)

ETA_CL = ETA(1)
ETA_V1 = ETA(2)
ETA_V2 = ETA(3)


MU_1 = LOG(POP_CL)
CL =  EXP(MU_1 + ETA(1)) ;

MU_2 = LOG(POP_V1)
V1 =  EXP(MU_2 + ETA(2)) ;

MU_3 = LOG(POP_V2)
V2 =  EXP(MU_3 + ETA(3)) ;

A_0(1) = 0
A_0(2) = 0
A_0(3) = 0
A_0(4) = 0
A_0(5) = 0
A_0(6) = 0

$DES 
A1_DES = A(1)
A2_DES = A(2)
A3_DES = A(3)
A4_DES = A(4)
A5_DES = A(5)
A6_DES = A(6)
K23_DES = (71.41/V1)
K32_DES = (71.41/V2)
NM_K_DES = (CL/V1)
KA_DES = 1
FB_DES = 0.32
KO_DES = 0.0144375
M_DES = 447.18
N_DES = (45*(10**8))
VC1_DES = 2.8E-13
VC2_DES = (VC1_DES*N_DES)
M1_DES = 287.2
M2_DES = 367.2
FU_DES = 0.93
VMAX_DES = 1.77
VU_DES = (VMAX_DES*FU_DES)
KM_DES = 4.4229E-5
KCAT1_DES = (2.4*3600)
KM1_DES = 0.003
E1_DES = 5.6E-8
KE1_DES = (KCAT1_DES*E1_DES)
KL_DES = (34*(10**9))
KCAT2_DES = (0.12*3600)
KM2_DES = 2.9E-4
E2_DES = 2.877E-7
KE2_DES = (KCAT2_DES*E2_DES)
GSHI_DES = 3100
GSHO_DES = 20
GR_DES = ((GSHI_DES-GSHO_DES)/GSHO_DES)
PA1_DES = ((KE1_DES*A4_DES)/(KM1_DES+(A4_DES/(M1_DES*VC2_DES))))
PA2_DES = ((KE2_DES*A5_DES)/(KM2_DES+(A5_DES/(M2_DES*VC2_DES))))
C1_DES = ((A2_DES*(10**6))/V1)
C2_DES = ((A3_DES*(10**6))/V2)
C3_DES = ((A4_DES*(10**6))/VC2_DES)
C4_DES = ((A5_DES*(10**6))/VC2_DES)
C5_DES = ((A6_DES*(10**9))/M_DES)
DADT(1) = -((A1_DES*KA_DES))
DADT(2) = (((((FB_DES*KA_DES)*A1_DES)-(K23_DES*A2_DES))+(K32_DES*A3_DES))-(NM_K_DES*A2_DES))
DADT(3) = ((K23_DES*A2_DES)-(K32_DES*A3_DES))
DADT(4) = ((((((VU_DES*GR_DES)*A2_DES)/(KM_DES+((FU_DES*A2_DES)/V1)))-((VU_DES*A4_DES)/(KM_DES+((FU_DES*A4_DES)/VC2_DES))))-(KL_DES*A4_DES))-PA1_DES)
DADT(5) = (PA1_DES-PA2_DES)
DADT(6) = (PA2_DES-(A6_DES*KO_DES))

$ERROR 
EPS_Y1 = EPS(1)
EPS_Y2 = EPS(2)

A1 = A(1)
A2 = A(2)
A3 = A(3)
A4 = A(4)
A5 = A(5)
A6 = A(6)
K23 = (71.41/V1)
K32 = (71.41/V2)
NM_K = (CL/V1)
KA = 1
FB = 0.32
KO = 0.0144375
M = 447.18
N = (45*(10**8))
VC1 = 2.8E-13
VC2 = (VC1*N)
M1 = 287.2
M2 = 367.2
FU = 0.93
VMAX = 1.77
VU = (VMAX*FU)
KM = 4.4229E-5
KCAT1 = (2.4*3600)
KM1 = 0.003
E1 = 5.6E-8
KE1 = (KCAT1*E1)
KL = (34*(10**9))
KCAT2 = (0.12*3600)
KM2 = 2.9E-4
E2 = 2.877E-7
KE2 = (KCAT2*E2)
GSHI = 3100
GSHO = 20
GR = ((GSHI-GSHO)/GSHO)
PA1 = ((KE1*A4)/(KM1+(A4/(M1*VC2))))
PA2 = ((KE2*A5)/(KM2+(A5/(M2*VC2))))
C1 = ((A2*(10**6))/V1)
C2 = ((A3*(10**6))/V2)
C3 = ((A4*(10**6))/VC2)
C4 = ((A5*(10**6))/VC2)
C5 = ((A6*(10**9))/M)

IF(DVID.EQ.2) THEN
	IPRED = A2
W = RUV_PROP*IPRED
Y = IPRED+W*EPS_Y1
IRES = DV - IPRED
IWRES = IRES/W

ENDIF

IF(DVID.EQ.6) THEN
	IPRED = A6
W = RUV_PROP*IPRED
Y = IPRED+W*EPS_Y2
IRES = DV - IPRED
IWRES = IRES/W

ENDIF

$THETA 
(29.28 )	;POP_CL
(244.0 )	;POP_V1
(464.54 )	;POP_V2
(1.0  FIX )	;RUV_PROP

$OMEGA 
(0.36 )	;PPV_CL
(0.79 )	;PPV_V1
(0.42 )	;PPV_V2

$SIGMA 
0.183	;SIGMA_Y1
0.567	;SIGMA_Y2


$EST METHOD=COND NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME DOSE MDV CMT DVID PRED RES WRES DV IPRED IRES IWRES Y NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID CL V1 V2 ETA_CL ETA_V1 ETA_V2 NOAPPEND NOPRINT FILE=patab

