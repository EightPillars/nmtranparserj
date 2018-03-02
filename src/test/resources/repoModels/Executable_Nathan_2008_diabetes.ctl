; Script generated by the pharmML2Nmtran Converter v.0.4.0
; Source 	: PharmML 0.8.1
; Target 	: NMTRAN 7.3.0
; Model 	: Executable_Nathan_2008_diabetes
; Model Name: Generated from MDL. MOG ID: Method_2_Nathan_mog
; Dated 	: Mon Sep 19 13:05:04 CEST 2016

$PROBLEM Generated from MDL. MOG ID: Method_2_Nathan_mog

$INPUT  ID TIME DV MPG EV=DROP
$DATA "Simulated_Nathan_data.csv" IGNORE=@

$PRED 
RES = THETA(1)
BETA0_POP = THETA(2)
BETA1_POP = THETA(3)



BETA0 = BETA0_POP

BETA1 = BETA1_POP

HBA1C = (BETA0+(BETA1*MPG))

EPS_1 = EPS(1)

IPRED = HBA1C
W = RES
Y = IPRED+W*EPS_1
IRES = DV - IPRED
IWRES = IRES/W

$THETA 
( 0.0 , 1.0 )	;RES
(1.63 )	;BETA0_POP
(0.035 )	;BETA1_POP

$OMEGA 0 FIX

$SIGMA 
1.0 FIX


$EST METHOD=COND NSIG=3 SIGL=9 MAXEVALS=9999 PRINT=10 NOABORT

$TABLE  ID TIME MPG PRED RES WRES DV IPRED IRES IWRES Y NOAPPEND NOPRINT FILE=sdtab

$TABLE  ID BETA0 BETA1 NOAPPEND NOPRINT FILE=patab

$TABLE  ID MPG NOAPPEND NOPRINT FILE=cotab


