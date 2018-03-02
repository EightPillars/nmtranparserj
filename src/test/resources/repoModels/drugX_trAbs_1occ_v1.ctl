$PROB DRUGX_TRABS_1OCC_V1
	
$INPUT
ID DV TIME MDV AMT RATE WT CMT

$DATA drugX_delAbs_1occ_dataMDL_v1.csv
	IGNORE=@

$THETA
(0, 10, INF) ; pop_Vc
(0, 30, INF) ; pop_Vp
(0, 6, INF) ; pop_CL
(0, 1.5, INF) ; pop_ka
(0, 10, INF) ; pop_Q
(0, 1, INF) ; pop_MTT
(0, 9, INF) ; pop_n
(0, .15, INF) ; b

$OMEGA
.16 ; omega_Vc
.25 ; omega_Vp
.49 ; omega_CL

$SIGMA
1 FIX ; sigma

$SUBR ADVAN6  TOL = 5

$MODEL
COMP(Aa)
COMP(Ac)
COMP(Ap)

$PK
grp_Vc = THETA(1)*(WT/70)
grp_Vp = THETA(2)
grp_CL = THETA(3)
grp_ka = THETA(4)
grp_Q = THETA(5)
grp_MTT = THETA(6)
grp_n = THETA(7)
Vc = grp_Vc*EXP(ETA(1))
Vp = grp_Vp*EXP(ETA(2))
CL = grp_CL*EXP(ETA(3))
ka = grp_ka
Q = grp_Q
MTT = grp_MTT
n = grp_n
kcp = Q/Vc
kpc = Q/Vp
kel = CL/Vc
ktr = (n+1)/MTT
LNFAC = LOG(2.5066)+(n+0.5)*LOG(n)-n
F1 = 0 
IF (AMT.GT.0) THEN
	DOSE = AMT
ENDIF

;initial conditions
A_0(1) = 0
A_0(2) = 0
A_0(3) = 0

$DES
IF (T.EQ.0) THEN
	DADT(1) = 0
ELSE 
	DADT(1) = EXP(LOG(DOSE)+LOG(ktr)+n*LOG(ktr*T)-ktr*T-LNFAC)-ka*A(1)
ENDIF
DADT(2) = ka*A(1)-kel*A(2)-kcp*A(2)+kpc*A(3)
DADT(3) = kcp*A(2)-kpc*A(3)

$ERROR
Cc = A(2)/Vc
Y = Cc+THETA(8)*EPS(1)

$EST METHOD=COND INTER
MAX=9990 POSTHOC NOABORT SIG=3 
