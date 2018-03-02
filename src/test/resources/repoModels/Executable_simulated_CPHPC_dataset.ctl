$PROB    BASE MODEL

;; Based on: 244
;; 2. Description:
;;    Original model
;; 3. Label:
;;    EONLY1
;;    STUD in 1:2 only
;; 4. Structural model:
;;    2 comp PK + indirect PK with Bound compartment
;; 5. Covariate model:
;;    No covariates
;; 6. Inter-individual variability:
;;    CL, V, Q, V2, SAP10
;; 7. Inter-occasion variability:
;; 8. Residual variability:
;;    Proportional
;; 9. Estimation:
;;    IMP

$INPUT      ID LABL=DROP AMT CHRT DV CRCL DURATION PERD RATE
            REGM=DROP TIME TRLD EVID MDV CMT STUD
            AMLOAD SEX AMLIVER ORD
$DATA       INPUTforEVAL.csv IGNORE=@
$SUBROUTINE ADVAN13 TOL9

$MODEL
COMP=(PERIH1)
COMP=(EFFECT)
COMP=(PERIPH2)
COMP=(PERIPH3)
COMP=(SC)
COMP=(COMP)

$PK

;CPHPC

MOLSAP  =   5*25000*1000                          ;; mg/mol (=Da*1000)
MOLCPH  =   340.37*1000                           ;; mg/mol (=Da*1000)

THRESH=80
IF(CRCL.GT.THRESH) THEN
CRCL2 = THRESH
ELSE
CRCL2 = CRCL
ENDIF

CRCLEFF = ( 1 + THETA(15)*(CRCL2 - THRESH))
TVCL = CRCLEFF*EXP(THETA(2))
MU_2 = LOG(TVCL)
CL = EXP(MU_2+ETA(2))


;LTVV = THETA(3)
TVV = EXP(THETA(3))
MU_3 = LOG(TVV)
V = EXP(MU_3+ETA(3))

TVQ = EXP(THETA(4))
MU_4 = LOG(TVQ)
Q = EXP(MU_4+ETA(4))

;IF(CL.LT.Q) EXIT 1 101

TVV2 = EXP(THETA(5))
MU_5 = LOG(TVV2)
V2 = EXP(MU_5+ETA(5))

TVK12 = Q/V
K12 = TVK12

TVK21 = Q/V2
K21 = TVK21

K10=CL/V

;SAP
TVV3 = V;EXP(THETA(16)) ; TVV
V3 = TVV3

;VP = 3

;V3 = VP
TVV4 = EXP(THETA(16))
MU_10 = LOG(TVV4)
V4 = EXP(MU_10+ ETA(10)) ; 12

TVSAP10 = EXP(THETA(6))
MU_6 = LOG(TVSAP10)
SAP10= EXP(MU_6+ETA(6))

TVKOUT = EXP(THETA(1))
MU_1 = LOG(TVKOUT)
KOUT = EXP(MU_1+ETA(1))

TVKON = EXP(THETA(7))
MU_7 = LOG(TVKON)
KON = EXP(MU_7+ETA(7)) ;;0.540      ;; L/h

KD = 10*10**(-9)

TVKOFF = TVKON*KD
KOFF = TVKOFF

TVKINT = THETA(8)
MU_8 = LOG(TVKINT)
KINT = EXP(MU_8+ETA(8))

TVQ4 = EXP(THETA(17))
MU_9 = LOG(TVQ4)
Q4 = EXP(MU_9+ETA(9))

TVK34 = Q4/V3
K34 = TVK34

TVK43 = Q4/V4
K43 = TVK43

KIN = KOUT*(SAP10*V3)

AM3 = SAP10/MOLSAP
AM4 = SAP10/MOLSAP

A_0(3)=AM3
A_0(4)=AM4

F1 = 1
F5 = THETA(13)

TVKSC = EXP(THETA(14))
MU_11 = LOG(TVKSC)
KSC = EXP(MU_11+ETA(11))

S1=V/(1000)
S3=1/(1000*MOLSAP)

$DES

A1=A(1)
A3=A(3)
A2=A(2)
A4=A(4)
A5=A(5)
A6=A(6)


C1 = A1/(V*MOLCPH)
C3 = A3
C3C1 = A6

C3C1_STD = C3C1*MOLCPH*V3
A1F = A1-C3C1_STD
C3F = C3-C3C1

C1F = A1F/(V*MOLCPH)

DADT1= -K10*A1F   + KSC*A5 - K12*A1F  + K21*A2 -KINT*(V*MOLCPH)*C3C1               ;; CPHPC (PLASMA) (mg)
DADT2=           K12*A1F      - K21*A2                                           ;; CPHPC (PERIPH) (mg)

DADT3=  KIN/(V3*MOLSAP)-KOUT*C3F -KINT*C3C1 + K43*A4*V4/V3  - K34*C3F               ;;  SAP PLASMA conc (mol/L)
DADT4= -K43*A4  + K34*C3F*V3/V4                                                        ;;  SAP PLASMA conc (mol/L)
DADT5=-KSC*A5
DADT6= KON*C3F*C1F - (KINT)*C3C1


 
DADT(1) = DADT1
DADT(2) = DADT2
DADT(3) = DADT3
DADT(4) = DADT4
DADT(5) = DADT5
DADT(6) = DADT6


$ERROR

ER1=ERR(1)
ER2=ERR(2)

IPRED = F

IF (CMT.EQ.1) THEN
W = THETA(9)
W2 = THETA(10)
Y1 = IPRED*(1+W*ER1) + W2*ER2
ELSE
W=THETA(11)
W2 = THETA(12)
Y1 = IPRED*(1+W*ER1) + W2*ER2
ENDIF


IF(IPRED.EQ.0) IPRED = 0.01
Y = Y1

IRES=DV-IPRED
IWRES = IRES/(IPRED*W)

$THETA  -3.07 ; 1. KOUT
 1.92 ; 2. CL
 2.76 ; 3. V
 0.595 ; 4. Q
 2.84 ; 5. V2
 3.37 ; 6. SAP10
 14.6 ; 7. KON
 5.71 ; 8. KINT
 (0,0.286) ; 9. PROPPK
 0 FIX ; 10. ADDPK
 (0,0.268) ; 11. PROPSAP
 0 FIX ; 12. ADDSAP
 (0,1) FIX ; 13. FSC
 0.4055 FIX ; 14. KASC
 (-1,0.0152,0.6) ; 15. CRCLCOV
 3.47 ; 16. V4
 (-20,1.49,20) ; 17. Q4
$OMEGA  0.125  ;   1. OMKOUT
 0.0474  ;    2. OMCL
 0.0836  ;     3. OMV
 0.0225  FIX  ;     4. OMQ
 0.0225  FIX  ;    5. OMV2
 0.0625  ; 6. OMSAP10
 0.0225  FIX  ;   7. OMKON
 0.0225  FIX  ;  8. OMKINT
 1.11  ;    9. OMQ4
 2.05  ;   10. OMV4
 0.0225  FIX  ;  11. OMKSC
$SIGMA  1  FIX
 1  FIX

;$EST METHOD=ITS INTER NITER=10 PRINT=1 CTYPE=1 CITER=10 GRD=DDDDDDDDSSSSDDDDD
;$EST METHOD=IMP INTER ISAMPLE=600 NITER=130 PRINT=1 CTYPE=1 CITER=10 CALPHA=0.01 GRD=DDDDDDDDSSSSDDDDD

;$EST  MAXEVAL=9999  PRINT=5 POSTHOC METHOD=0 INTERACTION MSFO=msf NOABORT SIGL=9 NSIG=3

$EST METHOD=IMP INTER ISAMPLE=10000 NITER=5 EONLY=1

$COV UNCONDITIONAL PRINT=E SIGL=12


$TABLE ID CL V Q V2 KSC SAP10 KIN KOUT Q4 V4 KON KINT
NOAPPEND NOPRINT ONEHEADER FILE=OUTPUTforEVAL.csv FORMAT=,1PE11.4f