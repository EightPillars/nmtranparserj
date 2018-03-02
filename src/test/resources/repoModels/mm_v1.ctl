$PROB MM_v1
	
$INPUT
TIME INS DV ID Gb Ib wgt MDV TP INSP AMT RATE

$DATA mm_dataMDL_v1.csv
	IGNORE=@

$SUBR ADVAN6  TOL = 5

$MODEL
COMP(G)
COMP(Z)

$PK
SI = THETA(1)
SG = THETA(2) 
V = THETA(3) 
lambda = THETA(4)
F1 = wgt/V

;initial conditions
A_0(1) = Gb
A_0(2) = 0

$DES
I = (T-TP)/(TIME-TP)*(INS-INSP)+INSP
DADT(1) = -(SG+SI*A(2))*A(1)+SG*Gb
DADT(2) = -lambda*A(2)+lambda*(I-Ib)

$ERROR
Y = A(1)+THETA(5)*ERR(1)

$THETA
(0, 5.4E-4, INF) ; POP_SI
(0, .047, INF) ; POP_SG
(0, 64, INF) ; POP_V
(0, .062, INF) ; POP_lambda
(0, 2, INF) ; alpha

$OMEGA
1 FIX ; sigma

$EST MAX=9999 NOABORT

