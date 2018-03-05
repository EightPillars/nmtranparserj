; Script generated by the pharmML2Nmtran Converter v.0.4.0
; Source 	: PharmML 0.8.1
; Target 	: NMTRAN 7.3.0
; Model 	: Executable_AitOudhia_2012_CRP_canakinumab
; Model Name: Generated from MDL. MOG ID: ait2012_mog
; Dated 	: Tue Sep 20 00:44:43 CEST 2016

$PROBLEM Generated from MDL. MOG ID: ait2012_mog

$INPUT  ID TIME DV AMT CMT MDV K_A VP CLEARANCE CLD KD FR VCENTRAL CLL
$DATA "Simulated_ait2012_data_CRP.csv" IGNORE=@
$SUBS ADVAN13 TOL=9

$MODEL 
COMP (COMP1) 	;QS_F
COMP (COMP2) 	;QC
COMP (COMP3) 	;QP
COMP (COMP4) 	;QL
COMP (COMP5) 	;CRP1
COMP (COMP6) 	;CRP2
COMP (COMP7) 	;CRP3



$PK 
POP_CRP0 = THETA(1)
POP_BETA = THETA(2)
POP_KOUT = THETA(3)
POP_GAMA = THETA(4)
RES = THETA(5)

ETA_CRP0 = ETA(1)
ETA_BETA = ETA(2)
ETA_KOUT = ETA(3)
ETA_GAMA = ETA(4)

KDEG = (CLL/VCENTRAL) 
R00 = ((0.42*VCENTRAL)/17000) 
KSYN = (R00*KDEG) 
ILB_BASE = (R00/VCENTRAL) 

MU_1 = LOG(POP_CRP0)
CRP0 =  EXP(MU_1 + ETA(1)) ;

MU_2 = LOG(POP_BETA)
BETA =  EXP(MU_2 + ETA(2)) ;

MU_3 = LOG(POP_KOUT)
KOUT =  EXP(MU_3 + ETA(3)) ;

MU_4 = LOG(POP_GAMA)
GAMA =  EXP(MU_4 + ETA(4)) ;

KIN = ((CRP0*(KOUT**GAMA))**(1/GAMA))

CRP10 = (KIN/KOUT)

CRP20 = (KIN/KOUT)

CRP30 = ((KIN/KOUT)**GAMA)

A_0(1) = 0
A_0(2) = 0
A_0(3) = 0
A_0(4) = R00
A_0(5) = CRP10
A_0(6) = CRP20
A_0(7) = CRP30

$DES 
QS_F_DES = A(1)
QC_DES = A(2)
QP_DES = A(3)
QL_DES = A(4)
CRP1_DES = A(5)
CRP2_DES = A(6)
CRP3_DES = A(7)
FREE_DES = (0.5*(((QC_DES-QL_DES)-(KD*VCENTRAL))+(((((QC_DES-QL_DES)-(KD*VCENTRAL))**2)+(((4*KD)*VCENTRAL)*QC_DES))**0.5)))
ILB_TOTAL_DES = (QL_DES/VCENTRAL)
ILB_DRUG_DES = ((ILB_TOTAL_DES*(FREE_DES/VCENTRAL))/(KD+(FREE_DES/VCENTRAL)))
ILB_FREE_DES = (ILB_TOTAL_DES-ILB_DRUG_DES)
STIM_DES = ((ILB_FREE_DES/ILB_BASE)**BETA)
LNCRP3_DES = LOG(CRP3_DES)
DADT(1) = (-(K_A)*QS_F_DES)
DADT(2) = (((((K_A*QS_F_DES)*FR)-((CLEARANCE/VCENTRAL)*QC_DES))-((((CLEARANCE/VCENTRAL)+(CLD/VP))-(CLEARANCE/VCENTRAL))*FREE_DES))+((CLD/VP)*QP_DES))
DADT(3) = (((CLD/VCENTRAL)*FREE_DES)-((CLD/VP)*QP_DES))
DADT(4) = ((KSYN-(((CLEARANCE/VCENTRAL)-(CLL/VCENTRAL))*(QC_DES-FREE_DES)))-((CLL/VCENTRAL)*QL_DES))
DADT(5) = ((KIN*STIM_DES)-(KOUT*CRP1_DES))
DADT(6) = (KOUT*(CRP1_DES-CRP2_DES))
DADT(7) = (KOUT*((CRP2_DES**GAMA)-CRP3_DES))

$ERROR 
EPSILON = EPS(1)

QS_F = A(1)
QC = A(2)
QP = A(3)
QL = A(4)
CRP1 = A(5)
CRP2 = A(6)
CRP3 = A(7)
FREE = (0.5*(((QC-QL)-(KD*VCENTRAL))+(((((QC-QL)-(KD*VCENTRAL))**2)+(((4*KD)*VCENTRAL)*QC))**0.5)))
ILB_TOTAL = (QL/VCENTRAL)
ILB_DRUG = ((ILB_TOTAL*(FREE/VCENTRAL))/(KD+(FREE/VCENTRAL)))
ILB_FREE = (ILB_TOTAL-ILB_DRUG)
STIM = ((ILB_FREE/ILB_BASE)**BETA)
LNCRP3 = LOG(CRP3)
IPRED = LNCRP3
W = RES
Y = IPRED+W*EPSILON
IRES = DV - IPRED
IWRES = IRES/W

$THETA 
(8.44 )	;POP_CRP0
(0.25 )	;POP_beta
(1.06 )	;POP_kout
(1.92 )	;POP_gama
(0.111 )	;RES

$OMEGA 
(0.447 )	;OMEGA_CRP0
(0.567 )	;OMEGA_beta
(0.105 )	;OMEGA_kout
(0.4 )	;OMEGA_gama

$SIGMA 
1.0 FIX


$EST METHOD=COND NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME AMT CMT MDV K_A VP CLEARANCE CLD KD FR VCENTRAL CLL PRED RES WRES DV IPRED IRES IWRES Y NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID CRP0 BETA KOUT GAMA KIN CRP10 CRP20 CRP30 ETA_CRP0 ETA_BETA ETA_KOUT ETA_GAMA NOAPPEND NOPRINT FILE=patab

$TABLE  ID K_A VP CLEARANCE CLD KD FR VCENTRAL CLL NOAPPEND NOPRINT FILE=cotab

