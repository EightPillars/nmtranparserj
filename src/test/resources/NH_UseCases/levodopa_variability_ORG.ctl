$SIZES LVR=70 LNP4=9000 ;  LNP4=4000 default
$PROB TWO COMPARTMENT ZERO ORDER INFUSION
$DATA 522_sim_2014.csv
$INPUT ID MONTH TRIAL OCC WTKG PREV TIME AMT RATE SS II CMT DV MDV

$ESTIM METHOD=CONDITIONAL INTERACTION
MAXEVAL=0 NSIG=3 SIGL=9 NOABORT PRINT=1 
;$SIM (20130510) ONLYSIM NSUB=1

; Population PK parameters
$THETA 
(0.02,11.4,100)  ; V1        1      ;Central compartment volume
(0.02,30.9,500)  ; CL        2      ;Elimination clearance
(0.02,27.3,100)  ; V2        3      ;Tissue compartment volume
(0.02,34.6,100)  ; Q         4      ;Intercompartmental clearance
2 FIX            ; TTK0      5      ;Duration of infusion
(0,3.42,10)      ; RSYN      6      ;Endogenous ldopa input
(0,0.075,1)      ; CSSOP     7      ;Css from previous dosing

; Between Subject Variability
$OMEGA BLOCK (4)
0.015                          ; BSVV1 1
0.00377 0.0158                 ; BSVCL 2
0.0156 0.0127 0.0218           ; BSVV2 3
0.0273 0.0282 0.0411 0.0804    ; BSVQ  4

; Within Study Variability
$OMEGA BLOCK(4)
0.0254                      ; BOVV11   5;Occasion 1 0 month visit 1st infusion
0.0152 0.016                ; BOVCL1   6
0.011  0.0102 0.00667       ; BOVV21   7
0.0275 0.0137 0.0105 0.0313 ; BOVQ1    8

$OMEGA BLOCK(4) SAME
;; BOVV12   9 ;Occasion 2 0 month visit 2nd infusion
;; BOVCL2   10
;; BOVV22   11
;; BOVQ2    12

$OMEGA BLOCK(4) SAME
;; BOVV13   13 ;Occasion 3 6 months visit 1st infusion
;; BOVCL3   14
;; BOVV23   15
;; BOVQ3    16

$OMEGA BLOCK(4) SAME
;; BOVV14   17 ;Occasion 4 6 months visit 2nd infusion
;; BOVCL4   18
;; BOVV24   19
;; BOVQ4    20
$OMEGA BLOCK(4) SAME
;; BOVV15   21 ;Occasion 5 12 months visit 1st infusion
;; BOVCL5   22
;; BOVV25   23
;; BOVQ5    24

$OMEGA BLOCK(4) SAME
;; BOVV16   25 ;Occasion 6 12 months visit 2nd infusion
;; BOVCL6   26
;; BOVV26   27
;; BOVQ6    28

$OMEGA BLOCK(4) SAME
;; BOVV17   29 ;Occasion 7 24 month visit 1st infusion
;; BOVCL7   30 
;; BOVV27   31
;; BOVQ7    32

$OMEGA BLOCK(4) SAME
;; BOVV18   33 ;Occasion 8 24 month visit 2nd infusion
;; BOVCL8   34
;; BOVV28   35 
;; BOVQ8    36

$OMEGA BLOCK(4) SAME
;; BOVV19   37 ;Occasion 9 48 month visit 1st infusion
;; BOVCL9   38 
;; BOVV29   39
;; BOVQ9    40

$OMEGA BLOCK(4) SAME
;; BOVV110  41 ;Occasion 10 48 month visit 2nd infusion
;; BOVCL10  42
;; BOVV210  43 
;; BOVQ10   44

$OMEGA 0 FIX          ; CVTTK0   45
$OMEGA 0.513          ; CVRSYN   46
$OMEGA 1.53           ; CVCSSOP  47

; Between Trial Variability (BTV) for 1st study
$OMEGA BLOCK (4)
0.156                       ; BTVV11   48
0.0407 0.0292               ; BTVCL1   49
0.018 0.0273 0.043          ; BTVV21   50
-0.059 0.0203 0.0545 0.115  ; BTVQ1    51

; Between Trial Variability (BTV) for 2nd study
$OMEGA BLOCK (4) SAME
;; BTVV12   52
;; BTVCL2   53
;; BTVV22   54
;; BTVQ2    55

; Between Trial Variability (BTV) for 3rd study
$OMEGA BLOCK (4) SAME
;; BTVV13   56
;; BTVCL3   57
;; BTVV23   58
;; BTVQ3    59

; Between Trial Variability (BTV) for 4th study
$OMEGA BLOCK (4) SAME
;; BTVV14   60 
;; BTVCL4   61
;; BTVV24   62
;; BTVQ4    63

; Between Trial Variability (BTV) for 5th study
$OMEGA BLOCK (4) SAME
;; BTVV15   64
;; BTVCL5   65
;; BTVV25   66
;; BTVQ5    67

; Residual Unidentified Variability
$SIGMA 
0.0118          ; CVCP 1
0.0249          ; SDCP 2

; ADVAN3: Zero order input two compartment first-order elimination PK model
$SUBR ADVAN3 TRANS4

$PK
   FWV=WTKG/70
   FWCL=FWV**0.75

   TVV1=THETA(1)*FWV
   TVCL=THETA(2)*FWCL
   TVV2=THETA(3)*FWV
   TVQ =THETA(4)*FWCL
   TVTTK0=THETA(5)

   IF (OCC.EQ.1) THEN
      BOVV1=ETA(5)
      BOVCL=ETA(6)
      BOVV2=ETA(7)
      BOVQ =ETA(8)
   ENDIF

   IF (OCC.EQ.2) THEN
      BOVV1=ETA(9)
      BOVCL=ETA(10)
      BOVV2=ETA(11)
      BOVQ =ETA(12)
   ENDIF

   IF (OCC.EQ.3) THEN
      BOVV1=ETA(13)
      BOVCL=ETA(14)
      BOVV2=ETA(15)
      BOVQ =ETA(16)
   ENDIF

   IF (OCC.EQ.4) THEN
      BOVV1=ETA(17)
      BOVCL=ETA(18)
      BOVV2=ETA(19)
      BOVQ =ETA(20)
   ENDIF

   IF (OCC.EQ.5) THEN
      BOVV1=ETA(21)
      BOVCL=ETA(22)
      BOVV2=ETA(23)
      BOVQ =ETA(24)
   ENDIF

   IF (OCC.EQ.6) THEN
      BOVV1=ETA(25)
      BOVCL=ETA(26)
      BOVV2=ETA(27)
      BOVQ =ETA(28)
   ENDIF

   IF (OCC.EQ.7) THEN
      BOVV1=ETA(29)
      BOVCL=ETA(30)
      BOVV2=ETA(31)
      BOVQ =ETA(32)
   ENDIF

   IF (OCC.EQ.8) THEN
      BOVV1=ETA(33)
      BOVCL=ETA(34)
      BOVV2=ETA(35)
      BOVQ =ETA(36)
   ENDIF

   IF (OCC.EQ.9) THEN
      BOVV1=ETA(37)
      BOVCL=ETA(38)
      BOVV2=ETA(39)
      BOVQ =ETA(40)
   ENDIF

   IF (OCC.EQ.10) THEN
      BOVV1=ETA(41)
      BOVCL=ETA(42)
      BOVV2=ETA(43)
      BOVQ =ETA(44)
   ENDIF

   IF (TRIAL.EQ.1) THEN
      BTVV1=ETA(48)
      BTVCL=ETA(49)
      BTVV2=ETA(50)
      BTVQ =ETA(51)
   ENDIF

   IF (TRIAL.EQ.2) THEN
      BTVV1=ETA(52)
      BTVCL=ETA(53)
      BTVV2=ETA(54)
      BTVQ =ETA(55)
   ENDIF

   IF (TRIAL.EQ.3) THEN
      BTVV1=ETA(56)
      BTVCL=ETA(57)
      BTVV2=ETA(58)
      BTVQ =ETA(59)
   ENDIF

   IF (TRIAL.EQ.4) THEN
      BTVV1=ETA(60)
      BTVCL=ETA(61)
      BTVV2=ETA(62)
      BTVQ =ETA(63)
   ENDIF

   IF (TRIAL.EQ.5) THEN
      BTVV1=ETA(64)
      BTVCL=ETA(65)
      BTVV2=ETA(66)
      BTVQ =ETA(67)
   ENDIF

   PPV1=ETA(1)+BOVV1+BTVV1
   PPCL=ETA(2)+BOVCL+BTVCL
   PPV2=ETA(3)+BOVV2+BTVV2
   PPQ =ETA(4)+BOVQ+BTVQ

   V1=TVV1*EXP(PPV1)
   CL=TVCL*EXP(PPCL)
   V2=TVV2*EXP(PPV2)
   Q =TVQ *EXP(PPQ)
   TTK0=TVTTK0*EXP(ETA(45))

   TVRSYN=THETA(6)
   TVCSS=THETA(7)
   RSYN=TVRSYN*EXP(ETA(46))
   CSS=TVCSS*EXP(ETA(47))

   D1=TTK0
   R1=CL*CSS
 
   S1=V1
   S2=V2

$ERROR
   CSYN=RSYN/CL     ; compute endogenous steady state concentration using RSYN
   C=F+CSYN         ; add endogenous steady state concentration
   Y=C*(1+ERR(1))+ERR(2)

$TABLE ID MONTH TRIAL OCC WTKG PREV TIME AMT RATE SS II CMT Y MDV
NOAPPEND NOPRINT ONEHEADER FILE=levodopa.fit
