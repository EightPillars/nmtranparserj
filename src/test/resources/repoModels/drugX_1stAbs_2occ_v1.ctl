$PROB DRUGX_1STABS_2OCC_V1
	
$INPUT
ID DV TIME MDV AMT RATE WT OCC CMT

$DATA drugX_PO_2occ_dataMDL_v1.csv
	IGNORE=@

$THETA
(0, 10, INF) ; pop_Vc
(0, 30, INF) ; pop_Vp
(0, 6, INF) ; pop_CL
(0, 1.5, INF) ; pop_ka
(0, 10, INF) ; pop_Q
(0, .15, INF) ; b

$OMEGA
.16 ; omega_Vc
.25 ; omega_Vp
.49 ; omega_CL
$OMEGA  BLOCK(1)
.09  ;    omega_CL1
$OMEGA  BLOCK(1) SAME

$SIGMA
1 FIX ; sigma

$SUBR ADVAN6  TOL = 5

$MODEL
COMP(Ad)
COMP(Ac)
COMP(Ap)

$PK
grp_Vc = THETA(1)*(WT/70)
grp_Vp = THETA(2)
grp_CL = THETA(3)
grp_ka = THETA(4)
grp_Q = THETA(5)
OCC1 = 0
OCC2 = 0
IF (OCC.EQ.1) THEN
	OCC1 = 1
ENDIF
IF (OCC.EQ.2) THEN
	OCC2 = 1
ENDIF
Vc = grp_Vc*EXP(ETA(1))
Vp = grp_Vp*EXP(ETA(2))
CL = grp_CL*EXP(ETA(3)+OCC1*ETA(4)+OCC2*ETA(5))
ka = grp_ka
Q = grp_Q
kcp = Q/Vc
kpc = Q/Vp
kel = CL/Vc

;initial conditions
A_0(1) = 0
A_0(2) = 0
A_0(3) = 0

$DES
DADT(1) = -ka*A(1)
DADT(2) = ka*A(1)-kel*A(2)-kcp*A(2)+kpc*A(3)
DADT(3) = kcp*A(2)-kpc*A(3)

$ERROR
Cc = A(2)/Vc
Y = Cc+THETA(6)*EPS(1)

$EST METHOD=COND INTER
MAX=9990 POSTHOC NOABORT SIG=3 
