;#Run 477. As run 456. Estimate CA50 instead of SLOP
$PROBLEM EC50 estimated
$INPUT ID AMT TIME DV RATE EVID CMT TYPE OCC BW INSU TOTG ODV
;DV contains insulin, glucose as well as hot glucose
$DATA Simulated_Jauslin_2007_SI.csv IGNORE=# 
$ABB DERIV2=NO
$SUBS ADVAN6 TRANS1 TOL=5

$MODEL
 COMP = GLU_C   ;1 central compartment glucose
 COMP = INS_C   ;2 central compartment insulin
 COMP = HOT_C   ;3 central compartment hot glucose
 COMP = GLU_E   ;4 effect compartment for glucose on insulin
 COMP = GLU_P   ;5 peripheral glucose compartment
 COMP = NOT_U   ;6 not used
 COMP = HOT_P   ;7 peripheral hot glucose compartent
 COMP = INS_E   ;8 effect compartment for insulin
 COMP = INS_S   ;9 insulin secretion (not used)
 COMP = GLU_A   ;10 not used 

$PK 
"FIRST
"      COMMON/PRCOMG/ IDUM1,IDUM2,IMAX,IDUM4,IDUM5
"INTEGER IDUM1,IDUM2,IMAX,IDUM4,IDUM5
"IMAX=5000000
;---------------------handling baseline values--------------
IF(EVID.EQ.4) BASG=TOTG
IF(EVID.EQ.4) BASI=INSU
  GSS = BASG*EXP(ETA(20)*THETA(20))*THETA(26)
  ISS = BASI*EXP(ETA(21)*THETA(21))*THETA(27)
IF(OCC.EQ.1) THEN
  GSS = BASG*EXP(ETA(22)*THETA(20))
  ISS = BASI*EXP(ETA(23)*THETA(21))
ENDIF
;----------------------initializing other parameters--------
OC=1
IF(OCC.EQ.1)OC=-1
  
  VG  = THETA(1)*EXP(ETA(1))*BW/70       ;central volume for glucose (in l)
  Q   = THETA(2)*EXP(ETA(2))             ;glucose flow central-peripheral
  VI  = THETA(3)*EXP(ETA(3))*BW/70       ;central volume for insulin

  CLG = THETA(4)*EXP(ETA(4))             ;glucose CL from central comp
  CLGI= THETA(5)*EXP(ETA(5))             ;insulin dependent glucose CL (2nd order)
IF(OCC.EQ.1) CLGI=THETA(6)*EXP(ETA(6))   ;different CLGI in OGTT
  
  CLI = THETA(7)*EXP(ETA(7))             ;insulin CL
  VP  = THETA(8)*EXP(ETA(8)+ETA(9)*OC)   ;pripheral volume for glucose
  KIS = THETA(9)                         ;k92 "ka" for insulin
IF(OCC.EQ.1) KIS = 0

  IFST= THETA(10)*EXP(ETA(10))           ;primary insulin response after iv administration  

  KEOG= THETA(11)*EXP(ETA(11))           ;keo for glucose 
  KEOI= THETA(12)*EXP(ETA(12))           ;keo for insulin

  IPRG= THETA(13)*EXP(ETA(13))           ;influence of glucose on insulin production
  GLUCPRG= THETA(14)*EXP(ETA(14))           ;influence of glucose on glucose production


  BIOG= THETA(15)*EXP(ETA(15))           ;biovailability glucose
  MTT = THETA(16)*EXP(ETA(16))           ;mean transit time glucose
;  KGS = 1/MTT
  NN  = THETA(17)*EXP(ETA(17))           ;number of transit compartments for glucose
  EMAX = THETA(18)*EXP(ETA(18))          ;max effect of glucose abs on insulin prod
  CA50 = THETA(19)*EXP(ETA(19))          ;conc of 50% effect

  RESG= THETA(20)                        ;proportional glucose residual error
IF(OCC.EQ.1) RESG = THETA(28)
  RESI= THETA(21)                        ;proportional insulin residual error
  RESH= THETA(22)                        ;proportional hot glucose residual error
IF(OCC.EQ.1) RESH = 1
  RESE= THETA(23)                        ;correction factor for early residual error
IF(OCC.EQ.1) RESE = 1
                                                                                                                                           
;-----basic calculations and initializing compartments------
  K15 = Q/VG
  K51 = Q/VP
  KG  = CLG/VG                          ;k10 for glucose dissappearance
  KGI = CLGI/VG                         ;2nd order rate constant for insulin-dep. glucose elimination
  KI  = CLI/VI                          ;k10 for insulin elimination
  GLUCPRO= GSS*(KG+KGI*ISS)*VG             ;baseline glucose production
  IPRO= KI*ISS*VI                       ;baseline insulin production
;  CA50= EMAX/SLOP

  F1  = 1
IF(AMT.EQ.1) F1=GSS*VG                  ;baseline glucose
  F2  = ISS*VI                          ;baseline insulin
IF(TIME.GT.0) F2=1                      ;initialization insulin
  F3  = 0.26                            ;correction for hot glucose
  F4  = GSS                             ;glucose effect (on ins.) compartment initialization
  F5  = K15*GSS*VG/K51                  ;glucose peripheral compartment initialization
  F6  = 1                               ;not used
  F7  = 0                               ;hot glucose peripheral compartment
  F8  = ISS                             ;insulin effect compartment initialization
  F9  = IFST                            ;insulin absorption/secretion compartment
IF(OCC.EQ.1) F9=0                       ;       - " -
  F10 = 0                               ;glucose absorption compartment

IF(OCC.EQ.1) THEN
KTR  = NN/MTT
;NFAC   = SQRT(2*3.1415)*NN**(NN+0.5)*EXP(-NN)
LNFAC = LOG(2.5066)+(NN+0.5)*LOG(NN)-NN+LOG(1+1/(12*NN))
ENDIF

$DES
PTOT   = K15*A(1)-K51*A(5)             ;distribution of tot glucose
PHOT   = K15*A(3)-K51*A(7)             ;distribution of hot glucose
IGLUCPR   = (A(4)/GSS+.0001)**IPRG     ;glucose on insulin production
GGLUCPR   = (A(4)/GSS+.0001)**GLUCPRG  ;glucose on glucose production

IGAPR  = 1
IF(OCC.EQ.1) THEN
TGLU   = EXP(LOG(75000*0.00555*BIOG)+LOG(KTR)+NN*LOG(KTR*T+.00001)-KTR*T-LNFAC)
IGAPR  = 1+TGLU*EMAX/(TGLU+CA50)       ;glucose absorption on insulin production
ENDIF

GLUCPRD   = GLUCPRO*GGLUCPR            ;glucose production
IPRD   = IPRO*IGLUCPR*IGAPR            ;insulin production
TELI   = (KG + KGI*A(8))*A(1)          ;tot glucose elimination
IELI   =  KI*A(2)                      ;insulin elimination
HELI   = (KG + KGI*A(8))*A(3)          ;hot glucose elimination

;IF(OCC.EQ.1) THEN
;TGLU   = EXP(LOG(75000*0.00555*BIOG)+LOG(KTR)+NN*LOG(KTR*T+.00001)-KTR*T-LNFAC)
;ENDIF

DADT(1) = GLUCPRD - TELI - PTOT
IF(OCC.EQ.1) DADT(1) = GLUCPRD + TGLU - TELI - PTOT
DADT(2) = IPRD + KIS*A(9)- IELI   
DADT(3) = - HELI - PHOT
DADT(4) = KEOG*(A(1)/VG - A(4))        ;glucose effect compartment
DADT(5) = PTOT
DADT(6) = KEOG*(A(1)/VG - A(6))
DADT(7) = PHOT
DADT(8) = KEOI*(A(2)/VI - A(8))        ;insulin effect-compartment
DADT(9) = - KIS*A(9)
;IF(OCC.EQ.1) DADT(10)= TGLU - KGS*A(10)
DADT(10)= 1

$ERROR
GLUC    =A(1)/VG
INSC    =A(2)/VI
HOTC    =A(3)/VG
GLUE    =A(4)
GLUP    =A(5)
NOTU    =A(6)
HOTP    =A(7)
INSE    =A(8)
INSS    =A(9)
;GLUA    =A(10)
       
IF (CMT.EQ.1) IPRED = GLUC+.00001
IF (CMT.EQ.2) IPRED = INSC+.00001
IF (CMT.EQ.3) IPRED = HOTC+.00001
IF (CMT.GE.4) IPRED = 1

IF (CMT.EQ.1) W = RESG
;IF(OCC.EQ.1.AND.CMT.EQ.1) W = W*RESGP
IF (CMT.EQ.2) W = RESI
;IF(OCC.EQ.1.AND.CMT.EQ.2) W = W*RESIP
IF (CMT.EQ.3) W = RESH
IF (CMT.GE.4) W = 1
IF(TIME.LE.2) W = W*RESE

IRES  = DV-LOG(IPRED)
IWRES = IRES/W
Y=LOG(IPRED)+ERR(1)*W
PRD   = IPRED
IPRED = LOG(IPRED)
OBS   = ODV

$THETA 9.33 FIX            ;1  ~VG_FIX
$THETA .442 FIX            ;2  ~Q_FIX
$THETA 6.09 FIX            ;3  ~VI_FIX
$THETA .0287 FIX           ;4  ~CLG_FIX
$THETA 0.000495 FIX        ;5  ~CLGI_FIX
$THETA 0.000983            ;6  ~CLGI_PO
$THETA 1.22 FIX            ;7  ~CLI_FIX
$THETA 8.56 FIX            ;8  ~VP_FIX
$THETA 0 FIX               ;9  ~KIS_FIX
$THETA 0 FIX               ;10 ~IFST_FIX
$THETA .0289 FIX           ;11 ~KEOG_FIX
$THETA .0213 FIX           ;12 ~KEOI_FIX
$THETA 1.42 FIX            ;13 ~IPRG_FIX
$THETA 0 FIX               ;14 ~GPRG_FIX
$THETA 0.811               ;15 ~BIOG
$THETA 34.8                ;16 ~MTT
$THETA 1.27                ;17 ~NN
$THETA 1.47                ;18 ~EMAX
$THETA 0.822               ;19 ~CA50

$THETA .0436 FIX           ;20 ~RESG_FIX
$THETA .252 FIX            ;21 ~RESI_FIX
$THETA .0512 FIX           ;22 ~RESH_FIX
$THETA 3.31 FIX            ;23 ~RESE_FIX
$THETA 1 FIX               ;24 ~RESGP_FIX
$THETA 1 FIX               ;25 ~RESIP_FIX

$THETA .891 FIX            ;26 ~SCALE_GSS_IV_FIX
$THETA .93 FIX             ;27 ~SCALE_ISS_IV_FIX
$THETA 0.0733              ;28 ~RESG_PO
;-------------------------------------------------
$OMEGA BLOCK(3) .0887 FIX          ;1  ~IIV_VG_FIX
                -0.192 .73         ;2  ~IIV_Q_FIX
                .0855 -0.12 .165   ;3  ~IIV_VI_FIX

$OMEGA .352 FIX                    ;4  ~IIV_CLG_FIX
$OMEGA BLOCK(2) .227               ;5  ~IIV_CLGI
                .169 .207          ;6  ~IIV_CLGI_PO

$OMEGA .0852 FIX                   ;7  ~IIV_CLI_FIX
$OMEGA .0891 FIX                   ;8  ~IIV_VP_FIX
$OMEGA .0238                       ;9  ~IOV_VP
$OMEGA 0 FIX                       ;10 ~IIV_IFST_FIX
$OMEGA .728 FIX                    ;11 ~IIV_KEOG_FIX
$OMEGA .337 FIX                    ;12 ~IIV_KEOI_FIX 
$OMEGA .124 FIX                    ;13 ~IIV_IPRG_FIX
$OMEGA 0 FIX                       ;14 ~IIV_GPRG_FIX
$OMEGA 0 FIX                       ;15 ~IIV_BIOG_FIX 
$OMEGA .0117                       ;16 ~IIV_MTT
$OMEGA 0 FIX;.02                   ;17 ~IIV_NN_FIX
$OMEGA .295                        ;18 ~IIV_EMAX
$OMEGA 1.27                        ;19 ~IIV_CA50

$OMEGA 1 FIX                    ;20 ~IIV_GSS_IV_FIX
$OMEGA 1 FIX                    ;21 ~IIV_ISS_IV_FIX
$OMEGA 1 FIX                    ;22 ~IIV_GSS_PO_FIX
$OMEGA 1 FIX                    ;23 ~IIV_ISS_PO_FIX

$SIGMA 1 FIX                       ;~RES_FIX

;$SIML (87568767) 
$EST MAXEVAL=0 PRINT=1 POSTHOC METH=1 
;$COVARIANCE PRINT=E

$TABLE
  ID AMT TIME EVID CMT IPRED IWRES NOPRINT ONEHEAD FILE=Executable_Jauslin_2007_SI.tab
