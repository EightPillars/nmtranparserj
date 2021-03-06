; Script generated by the pharmML2Nmtran Converter v.0.4.0
; Source 	: PharmML 0.8.1
; Target 	: NMTRAN 7.3.0
; Model 	: Executable_Simeoni_2004_oncology_TGI
; Model Name: Generated from MDL. MOG ID: simeoni2004
; Dated 	: Tue Sep 20 00:20:41 CEST 2016

$PROBLEM Generated from MDL. MOG ID: simeoni2004

$INPUT  ID TIME DV AMT MDV CMT
$DATA "Simulated_simeoni2004_data.csv" IGNORE=@
$SUBS ADVAN13 TOL=9

$MODEL 
COMP (COMP1) 	;Q1
COMP (COMP2) 	;Q2
COMP (COMP3) 	;X1
COMP (COMP4) 	;X2
COMP (COMP5) 	;X3
COMP (COMP6) 	;X4



$PK 
CV = THETA(1)
LAMBDA0_POP = THETA(2)
LAMBDA1_POP = THETA(3)
K1_POP = THETA(4)
K2_POP = THETA(5)
W0_POP = THETA(6)
K10_POP = THETA(7)
K12_POP = THETA(8)
K21_POP = THETA(9)
V1_POP = THETA(10)



LAMBDA0 = LAMBDA0_POP

LAMBDA1 = LAMBDA1_POP

K1 = K1_POP

K2 = K2_POP

W0 = W0_POP

K10 = K10_POP

K12 = K12_POP

K21 = K21_POP

V1 = V1_POP

A_0(1) = 0
A_0(2) = 0
A_0(3) = W0
A_0(4) = 0
A_0(5) = 0
A_0(6) = 0

$DES 
Q1_DES = A(1)
Q2_DES = A(2)
X1_DES = A(3)
X2_DES = A(4)
X3_DES = A(5)
X4_DES = A(6)
PSI_DES = 20
C_DES = (Q1_DES/V1)
WTOT_DES = (((X1_DES+X2_DES)+X3_DES)+X4_DES)
DADT(1) = ((K21*Q2_DES)-((K10+K12)*Q1_DES))
DADT(2) = ((K12*Q1_DES)-(K21*Q2_DES))
DADT(3) = (((LAMBDA0*X1_DES)/((1+(((WTOT_DES*LAMBDA0)/LAMBDA1)**PSI_DES))**(1/PSI_DES)))-((K2*C_DES)*X1_DES))
DADT(4) = (((K2*C_DES)*X1_DES)-(K1*X2_DES))
DADT(5) = ((K1*X2_DES)-(K1*X3_DES))
DADT(6) = ((K1*X3_DES)-(K1*X4_DES))

$ERROR 
EPS_RES_W = EPS(1)

Q1 = A(1)
Q2 = A(2)
X1 = A(3)
X2 = A(4)
X3 = A(5)
X4 = A(6)
PSI = 20
C = (Q1/V1)
WTOT = (((X1+X2)+X3)+X4)
IPRED = WTOT
W = CV*IPRED
Y = IPRED+W*EPS_RES_W
IRES = DV - IPRED
IWRES = IRES/W

$THETA 
( 0.0 , 0.1 )	;CV
( 0.0 , 0.3 )	;LAMBDA0_POP
( 0.0 , 0.7 )	;LAMBDA1_POP
( 0.0 , 0.7 )	;K1_POP
( 0.0 , 0.5 )	;K2_POP
( 0.0 , 0.02 )	;W0_POP
(20.832  FIX )	;K10_POP
(0.144  FIX )	;K12_POP
(2.011  FIX )	;K21_POP
(0.81  FIX )	;V1_POP

$OMEGA 0 FIX

$SIGMA 
1.0 FIX


$EST METHOD=COND NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME AMT MDV CMT PRED RES WRES DV IPRED IRES IWRES Y NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID LAMBDA0 LAMBDA1 K1 K2 W0 K10 K12 K21 V1 NOAPPEND NOPRINT FILE=patab


