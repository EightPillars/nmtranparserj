; Script generated by the pharmML2Nmtran Converter v.0.3.0
; Source	: PharmML 0.6.1
; Target	: NMTRAN 7.3.0
; Model 	: Executable_Ribba_2012
; Dated 	: Tue Dec 15 08:08:24 CET 2015

$PROBLEM "generated by MDL2PharmML v.6.0"

$INPUT  ID TIME=TIME AMT DV MDV XEVID=DROP
$DATA "Simulated_Ribba_2012.csv" IGNORE=#
$SUBS ADVAN13 TOL=6

$MODEL 
COMP (COMP1) 	;C_M
COMP (COMP2) 	;PT_M
COMP (COMP3) 	;Q_M
COMP (COMP4) 	;QP_M


$PK 
TVPT0 = THETA(1)
TVQ0 = THETA(2)
TVLAMBDAP = THETA(3)
TVKPQ = THETA(4)
TVKQPP = THETA(5)
TVDELTAQP = THETA(6)
TVGAMA = THETA(7)
TVKDE = THETA(8)
SDADD = THETA(9)
SDPROP = THETA(10)

ETA_PT0 =  ETA(1)
ETA_Q0 =  ETA(2)
ETA_LAMBDAP =  ETA(3)
ETA_KPQ =  ETA(4)
ETA_KQPP =  ETA(5)
ETA_DELTAQP =  ETA(6)
ETA_GAMA =  ETA(7)
ETA_KDE =  ETA(8)


MU_1 = LOG(TVPT0)
PT0 =  EXP(MU_1 +  ETA(1)) ;

MU_2 = LOG(TVQ0)
Q0 =  EXP(MU_2 +  ETA(2)) ;

MU_3 = LOG(TVLAMBDAP)
LAMBDAP =  EXP(MU_3 +  ETA(3)) ;

MU_4 = LOG(TVKPQ)
KPQ =  EXP(MU_4 +  ETA(4)) ;

MU_5 = LOG(TVKQPP)
KQPP =  EXP(MU_5 +  ETA(5)) ;

MU_6 = LOG(TVDELTAQP)
DELTAQP =  EXP(MU_6 +  ETA(6)) ;

MU_7 = LOG(TVGAMA)
GAMA =  EXP(MU_7 +  ETA(7)) ;

MU_8 = LOG(TVKDE)
KDE =  EXP(MU_8 +  ETA(8)) ;

A_0(1) = 0
A_0(2) = PT0
A_0(3) = Q0
A_0(4) = 0

$DES 
C_M_DES = A(1)
PT_M_DES = A(2)
Q_M_DES = A(3)
QP_M_DES = A(4)
K_DES = 100
C_DES = C_M_DES
PT_DES = PT_M_DES
Q_DES = Q_M_DES
QP_DES = QP_M_DES
DPSTAR_DES = ((PT_DES+Q_DES)+QP_DES)
EFF_DES = ((PT_M_DES+Q_M_DES)+QP_M_DES)
DADT(1) = (-(KDE)*C_DES)
DADT(2) = (((((LAMBDAP*PT_DES)*(1-(DPSTAR_DES/K_DES)))+(KQPP*QP_DES))-(KPQ*PT_DES))-(((GAMA*PT_DES)*KDE)*C_DES))
DADT(3) = ((KPQ*PT_DES)-(((GAMA*Q_DES)*KDE)*C_DES))
DADT(4) = (((((GAMA*Q_DES)*KDE)*C_DES)-(KQPP*QP_DES))-(DELTAQP*QP_DES))

$ERROR 
C_M = A(1)
PT_M = A(2)
Q_M = A(3)
QP_M = A(4)
K = 100
C = C_M
PT = PT_M
Q = Q_M
QP = QP_M
DPSTAR = ((PT+Q)+QP)
EFF = ((PT_M+Q_M)+QP_M)
IPRED = EFF
W = SDADD+SDPROP*IPRED
Y = IPRED+W*EPS(1)
IRES = DV - IPRED
IWRES = IRES/W

$THETA 
( 0.0 , 10.0 )	;TVPT0
( 0.0 , 50.0 )	;TVQ0
( 0.0 , 0.15 )	;TVLAMBDAP
( 0.0 , 0.05 )	;TVKPQ
( 0.0 , 0.005 )	;TVKQPP
( 0.0 , 0.01 )	;TVDELTAQP
( 0.0 , 1.0 )	;TVGAMA
( 0.0 , 0.3 )	;TVKDE
( 0.0 , 3.0 )	;SDADD
(0.0  FIX )	;SDPROP

$OMEGA 
(0.25 )	;OMPT0
(0.25 )	;OMQ0
(0.25 )	;OMLAMBDAP
(0.25 )	;OMKPQ
(0.25 )	;OMKQPP
(0.25 )	;OMDELTAQP
(0.25 )	;OMGAMA
(0.49  FIX )	;OMKDE

$SIGMA 
1.0 FIX	;SIGMA



$EST METHOD=SAEM AUTO=1 PRINT=100 CINTERVAL=30 ATOL=6 SIGL=6


$TABLE  ID TIME AMT MDV PRED IPRED RES IRES WRES IWRES Y DV NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID PT0 Q0 LAMBDAP KPQ KQPP DELTAQP GAMA KDE ETA_PT0 ETA_Q0 ETA_LAMBDAP ETA_KPQ ETA_KQPP ETA_DELTAQP ETA_GAMA ETA_KDE NOAPPEND NOPRINT FILE=patab


