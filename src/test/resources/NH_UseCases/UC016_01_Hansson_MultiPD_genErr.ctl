$PROBLEM BIOMARKER MODELS FOR VEGF, VEGFR2, VEGFR3 AND SKIT
; Model and data obtained from WP1 Oncology BIOMARKERS.ctl example
; Hansson E.K. 2011. Pharmacometric models for Biomarkers, Side Effects and Efficacy in Anticancer Drug Therapy. Acta Universitatis Upsaliensis.

$INPUT
ID           ; Patient identification
CYCL         ; Cycle number
TIME         ; Time in hours units="h"
DVID         ; 1. Dose ; 4. Tumor size (SLD) (ignored) ; 5.VEGF ; 6.VEGFR2 ; 7.VEGFR3 ; 8. SKIT
DVX          ; DV on a linear scale
DV           ; log-transformed DV
DOS          ; Dose in units="mg"
PLA          ; Placebo: 1. untreated, 0. treated
CL           ; units="L/h" posthoc total plasma clearance from a previously developed 2-compartment model
EVID         ; 0.PD assessment ; 2. other event


MDV
$DATA ../data/BIOMARKER_simDATA.csv IGNORE=#

$EST METHOD=COND INTER 
NSIG=3 SIGL=9 PRINT=1
MAXEVAL=0
;$COV

$THETA

;-----INITIAL ESTIMATES------------------------
1 FIX                             ; POP_IMAX
(0,1)                             ; IC50 units="mg/L*h"

;-----VEGF-------------------------------------
(0,59.7)                          ; BM0 units="pg/mL"
(0,91)                            ; MRT units="h"
(0,3.31)                          ; HILL
(-0.06,0.035)                     ; DP_SLOPE units="1/h"
;-----VEGFR2-----------------------------------
(0,8670)                          ; BM02 units="pg/mL"
(0,554)                           ; MRT2 units="h"
(0,1.54)                          ; HILL2
;-----VEGR3------------------------------------
(0,63900)                         ; BM03 units="pg/mL"
(0,401)                           ; MRT3 units="h"
;-----SKIT-------------------------------------
(0,39200)                         ; BM0S units="pg/mL"
(0,2430)                          ; MRTS units="h"
;-----RES--------------------------------------
(0,0.445)                         ; RUV_VEGF_PROP
(0,0.12)                          ; RUV_VEGFR2_PROP 
(0,583)                           ; RUV_VEGFR2_ADD units="pg/mL"
(0,0.22)                          ; RUV_VEGFR3_PROP
(0,0.224)                         ; RUV_SKIT_PROP
;-----BM0-------------------------------------
$OMEGA
0.252                             ; PPV_BM0
0.0369                            ; PPV_BM02
0.186                             ; PPV_BM03
0.254                             ; PPV_BM0S
;-----MRT--------------------------------------
0.0600                            ; PPV_MRT_sVEGFR_2_3
0.0753                            ; PPV_MRT_sKIT

;-----IC50-------------------------------------
$OMEGA BLOCK(4)   
0.253                             ; PPV_IC50
0.198 0.189                       ; PPV_IC502
0.238 0.252 0.398                 ; PPV_IC503
0.218 0.297 0.936 5.77            ; PPV_IC50S

$OMEGA
2.95                              ; PPV_DP_SLOPE_VEGF
3.01                              ; PPV_DP_SLOPE_SKIT

$SIGMA   1 FIX                    ; RUV_EPS1


$SUBROUTINE ADVAN6 TOL=9
$ABBR DERIV2=NOCOMMON

$MODEL
 NCOMPS=4
 COMP=COMP1  ;VEGF
 COMP=COMP2  ;VEGFR2
 COMP=COMP3  ;VEGFR3
 COMP=COMP4  ;SKIT

$PK

GRPIMAX=POP_IMAX

;------VEGF------------------------------------

  BM0    =   BM0*EXP(PPV_BM0)          ; Baseline VEGF
  MRT    =   MRT*EXP(PPV_MRT_SVEGFR_2_3)
  IMAX1  =   GRPIMAX
  IC50   =   IC50*EXP(PPV_IC50)          ; Common IC50 for the four biomarkers which were found to be highly correlated
  HILL   =   HILL                      ; Hill coefficient for VEGF sigmoid Imax model
  TVSLO  =   DP_SLOPE/1000
  DPSLO  =   TVSLO *EXP(PPV_DP_SLOPE_VEGF)           ; Slope for the disease progression model
;------VEGFR2----------------------------------
  BM02   =   BM02*EXP(PPV_BM02)          ; Baseline VEGFR2
  MRT2   =   MRT2*EXP(PPV_MRT_SVEGFR_2_3)
  IMAX2  =   GRPIMAX
  IC502  =   IC50*EXP(PPV_IC502)
  HILL2  =   HILL2                      ; Hill coefficient for VEGFR2 sigmoid IMAX model

;------VEGFR3----------------------------------
  BM03   =   BM03*EXP(PPV_BM03)         ; Baseline VEGFR3
  MRT3   =   MRT3*EXP(PPV_MRT_SVEGFR_2_3)
  IMAX3  =   GRPIMAX
  IC503  =   IC50*EXP(PPV_IC503)

;------SKIT------------------------------------

  BM0S   =   BM0S*EXP(PPV_BM0S)         ; Baseline SKIT
  MRTS   =   MRTS*EXP(PPV_MRT_SKIT)
  IMAXS  =   GRPIMAX
  IC50S  =   IC50*EXP(PPV_IC50S)
  TVSLOS =   DP_SLOPE/1000
  DPSLOS =   TVSLOS *EXP(PPV_DP_SLOPE_SKIT)          ; Slope for the disease progression model

;------Compartment initialization--------------
  A_0(1) =   BM0                           ; VEGF
  A_0(2) =   BM02                          ; sVEGFR-2
  A_0(3) =   BM03                          ; sVEGFR-3
  A_0(4) =   BM0S                          ; sKIT



  KOUT   =   1/MRT
  KOUT2  =   1/MRT2
  KOUT3  =   1/MRT3
  KOUTS  =   1/MRTS

  KIN2   =   BM02*KOUT2
  KIN3   =   BM03*KOUT3

  AUC    =   DOS/CL
  DP1     =  BM0*(1+DPSLO*TIME)            ; Linear disease progression model for VEGF
  DPS    =   BM0S*(1+DPSLOS*TIME)          ; Linear disease progression model for SKIT

$DES

 ;-----PD: Sunitinib effect--------------------

 KIN     =   DP1*KOUT
 KINS    =   DPS*KOUTS

 EFF     =   IMAX1*AUC**HILL /(IC50**HILL+AUC**HILL)    ; VEGF  : sigmoid Imax drug effect relationship
 EFF2    =   IMAX2*AUC**HILL2/(IC502**HILL2+AUC**HILL2) ; VEGFR2: sigmoid Imax drug effect relationship
 EFF3    =   IMAX3*AUC/(IC503+AUC)                      ; VEGFR3: Imax drug effect relationship
 EFFS    =   IMAXS*AUC/(IC50S+AUC)                      ; SKIT  : Imax drug effect relationship


 DADT(1) =   KIN-KOUT*(1-EFF)*A(1)                      ; VEGF  : Inhibition of Kout
 DADT(2) =   KIN2*(1-EFF2)-KOUT2*A(2)                   ; VEGFR2: Inhibition of Kin
 DADT(3) =   KIN3*(1-EFF3)-KOUT3*A(3)                   ; VEGFR3: Inhibition of Kin
 DADT(4) =   KINS*(1-EFFS)-KOUTS*A(4)                   ; SKIT  : Inhibition of Kin


$ERROR
  ; Biomarker predictions
  VEGF     = A(1)
  VEGFR2   = A(2)
  VEGFR3   = A(3)
  SKIT     = A(4)
  ; Residual error modelling performed on log transformed VEGF
  LNVEGF   = LOG(VEGF)
  LNVEGFR2 = LOG(VEGFR2)
  LNVEGFR3 = LOG(VEGFR3)
  LNSKIT   = LOG(SKIT)

  IF(DVID.EQ.5) THEN                                    ; VEGF
  Y=LNVEGF + RUV_VEGF_PROP*RUV_EPS1
  ENDIF

  IF(DVID.EQ.6) THEN                                    ; VEGFR2
  Y=LNVEGFR2 + SQRT(RUV_VEGFR2_PROP**2+(RUV_VEGFR2_ADD/VEGFR2)**2)*RUV_EPS1
  END IF

  IF(DVID.EQ.7) THEN                                    ; VEGFR3
  Y=LNVEGFR3 + RUV_VEGFR3_PROP*RUV_EPS1
  ENDIF

  IF(DVID.EQ.8) THEN                                    ; SKIT
  Y=LNSKIT + RUV_SKIT_PROP*RUV_EPS1
  ENDIF

$TABLE ID TIME  ; covariates
IC50 IC502 IC503 ; EBE estimates
VEGF VEGFR2 VEGFR3 SKIT DVID MDV Y ; predictions
ONEHEADER NOAPPEND NOPRINT FILE=usecase.fit
