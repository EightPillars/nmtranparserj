$PROB VANCAUTER_V1
	
$INPUT
TIME ISR DV ID MDV AMT RATE CMT wt ht age sex T2D
; sex: 1=male, 2=female
; T2D: 0=nondiabetic; 1=diabetic

$DATA vc_dataMDL_v1.csv
	IGNORE=@

$SUBR ADVAN6  TOL = 5

$MODEL
COMP(x1)
COMP(x2)

$PK
BSA = 0.2024726*wt**0.425*ht**0.725
BMI = wt/ht**2
IF (T2D.EQ.0.AND.BMI.LE.27) NOD = 1 ; normal
IF (T2D.EQ.0.AND.BMI.GT.27) NOD = 2 ; obese
IF (T2D.EQ.1) NOD = 3 ; diabetic
IF (NOD.EQ.1) T1 = 4.95
IF (NOD.EQ.2) T1 = 4.55
IF (NOD.EQ.3) T1 = 4.52
T2 = 29.2 + 0.14*age
IF (sex.EQ.1) V = 1.92*BSA + 0.64
IF (sex.EQ.2) V = 1.11*BSA + 2.04
IF (NOD.EQ.1) Fpar = .76
IF (NOD.EQ.2) Fpar = .78
IF (NOD.EQ.3) Fpar = .78
Aupp = Fpar/V ; A (upper case)
Bupp = (1-Fpar)/V ; B (upper case)
Alow = LOG(2)/T1 ; a (lower case)
Blow = LOG(2)/T2 ; b (lower case)

A_0(1) = 0
A_0(2) = 0

$DES
DADT(1) = -Alow*A(1) + ISR
DADT(2) = -Blow*A(2) + ISR

$ERROR
Y = Aupp*A(1) + Bupp*A(2) + ERR(1)

$OMEGA 0 FIX

$SIM (123) ONLYSIM