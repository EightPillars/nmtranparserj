$PROBLEM dog QT assesment, all data, circ rhytm included
$INPUT ID TIM2 EVID AMT RATE DOSE ICL IV1 IQ IV2 DV=QTCR MDV CONCIPRED TIME
$DATA Simulated_dog_PKPD.txt IGNORE=C

$SUBROUTINE ADVAN6 TOL=5
$MODEL
NCOMPARTMENTS=3

$PK
CL = ICL
V1 = IV1
Q = IQ
V2 = IV2
; BASELINE calculations
;----------------------------
BSL= THETA(1)*EXP(ETA(1))
PHA = THETA(2)
AMP=THETA(3)

PI=3.1415926535

; PD PARAMETERS TO BE ESTIMATED
TVSLOPE = THETA(4)
SLOPE = TVSLOPE
TVKEO = THETA(5)
KEO = TVKEO
;----------------------------
$DES

DADT(1)= (-(CL+Q)*A(1) + Q*A(2)) / V1
DADT(2)= ( Q*A(1) - Q*A(2) ) /V2
CP=CONCIPRED
DADT(3) = KEO*(CP-A(3))

$ERROR
;---------------
CIRC=AMP*COS(2*PI*(TIME-PHA)/24)
BASELINE=BSL+CIRC
;---------------
AB=0
IF (A(3).EQ.0) AB=0.00001
CE=(A(3))+AB*1
EE=BASELINE+SLOPE*CE
IPRED=EE
W=EE
IF (W.EQ.0) W = 1
IRES=DV-IPRED
IWRES = IRES/W
Y=IPRED+W*EPS(1)
;------------------
$THETA
( 0 , 221 , 1000 ) ; QTcR BSL
(0, 7.6, 100) ;phase of circadian rhythm,
3.7 ; the amplitude of circadian rhythm,
23		; SLOPE
0.3		; KEO

$OMEGA
0.1               ; OMEGA1
$SIGMA
0.1 ; proportional error

$EST METHOD=1 INTERACTION
MAXEVAL=9999 SIG=3 PRINT=5 NOABORT POSTHOC
;----------------------------------
$COV PRINT=E UNCONDITIONAL

$TABLE ID TIME DOSE CE BASELINE IPRED CONCIPRED IRES IWRES CWRES NOPRINT ONEHEADER FILE=SDTAB6
