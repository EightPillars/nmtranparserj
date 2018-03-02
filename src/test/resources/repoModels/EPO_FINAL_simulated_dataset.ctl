$PROB ETAS WERE ADDED TO ALL THE PK PR AND RET0, RBC0, KSAI, KD, MCH ERR2 FIXED TO 0
; Yan X (University of NY (Buffalo)), Lowe P (Novartis 
; Pharma A G) , Fink  M (Novartis Pharma AG), Berghout A 
; (Sandoz Biopharmaceuticals), Balser S  (Sandoz 
; Biopharmaceuticals), Krzyzanski W (University of NY (Buffalo))
; The journal of clinical pharmacology, 11/2011, Volume 52, Issue 11, pages: 1624-44

$INPUT      ID 
AMT ; units="UI/kg"
TIME ; units="h"
CMT 
DV 
DRUG 
ROUT 
RATE 

$DATA EPO_FINAL_simulated_dataset.csv IGNORE=I 

$SUBROUTINES  ADVAN6 TOL=6 
$EST  MAXEVALS=9999 SIGDIGITS=2 PRINT=1 METHOD=1 INTERACTION NOABORT MSFO=EPO_FINAL_simulated_dataset.msf
$COV PRINT=E

;*** PK PARAMETERS THETAS ***
$THETA (0,2.4,10)   ; POP_D1 units="h"
$THETA (0,0.045,5)  ; POP_KA units="1/h"
$THETA (0,4.9,10)   ; POP_VC units="L"
$THETA (0,0.3,0.6)  ; POP_CL units="UI.h/L"
$THETA (0,0.33,1)   ; POP_F1
$THETA 0 FIXED      ; POP_ALAG1 units="h"
$THETA (0,8.2,20)   ; POP_C0 units="mUI/mL"
$THETA (0,0.06,1)   ; POP_K23 units="1/h"
$THETA (0,0.1,1)    ; POP_K32 units="1/h"

;*** PD PARAMETERS ***
$THETA (0,54,100) ; POP_RET0  units="10^3 cells/uL"
$THETA (0,45,200) ; POP_TP1   units="h"
$THETA 0 FIXED    ; POP_TP2  units="h"
$THETA (0,3,40)   ; POP_SC50  units="10^3 cells/uL"
$THETA (0,0.04,1) ; POP_SMAX  units=""
$THETA (50,700,2000) ; POP_KD units="mUI/mL"
$THETA (0,0.8)    ; POP_KSAI units=""
$THETA (0,4,20)   ; POP_RBO units="10^6 cells/uL"
$THETA (0,34,100) ; POP_MCH units="pg/cell"

$OMEGA 0.5  ; PPV_D1
$OMEGA 0.1  ; PPV_KA
$OMEGA 0.09 ; PPV_VC
$OMEGA 0.5  ; PPV_CL
$OMEGA 0.1  ; PPV_C0
$OMEGA 0.05 ; PPV_RET0
$OMEGA 0 FIXED ; PPV_TP1
$OMEGA 0 FIXED ; PPV_SC50
$OMEGA 0.8  ; PPV_SMAX
$OMEGA 0 FIXED ; PPV_KD
$OMEGA 0.2  ; PPV_KSAI
$OMEGA 0.01 ;PPV_RBC0    
$OMEGA 0.01 ;PPV_MCH 

$SIGMA 0.04; RUV_PROP 
$SIGMA 0 FIXED; RUV_ADD units="mUI/mL" 
$SIGMA 0.04; RUV_PROP  
$SIGMA 0.01; RUV_PROP 


$MODEL  NCOMP=9
COM  = (A1)              ;COMPARTMENT #1 EPO SC
COM  = (A2)              ;COMPARTMENT #2 EPO SERUM
COM  = (A3)              ;COMPARTMENT #3 EPO TISSUE
COM  = (A4)              ;COMPARTMENT #4 PRECURSOR 1
COM  = (A5)              ;COMPARTMENT #5 PRECURSOR 2
COM  = (A6)              ;COMPARTMENT #6 PRECURSOR 3
COM  = (A7)              ;COMPARTMENT #7 RET       
COM = (A8)               ;COMPARTMENT #8 RBC
COM = (A9)               ;COMPARTMENT #9 HGB
$PK
;*** PK PARAMETERS ***  
D1 = THETA(1)*EXP(ETA(1))     
KA = THETA(2)*EXP(ETA(2))         
VC = THETA(3)*EXP(ETA(3))
CL = THETA(4)*EXP(ETA(4))         
F1 = THETA(5)                     
ALAG1 = THETA(6)                  
C0 = THETA(7)*EXP(ETA(5))         
K23 = THETA(8)                    
K32 = THETA(9)                    
   
;*** PD PARAMETERS ***
RR0   =  THETA(10)*EXP(ETA(6))   
TP1   =  THETA(11)*EXP(ETA(7))   
TD2   =  THETA(12)               
SC50  =  THETA(13)*EXP(ETA(8))   
SMAX  =  THETA(14)*EXP(ETA(9))   
KD    = THETA(15)*EXP(ETA(10))   
KSAI  = THETA(16)*EXP(ETA(11))   
RB0 =   THETA(17)*EXP(ETA(12))   
MCH =   THETA(18)*EXP(ETA(13))   
TR =TP1
TP3=TP1
TP2=TP1
TB=(RB0-RR0/1000)*TR*1000/RR0     ;RBC LIFESPAN
;*** INITIAL CONDITION FOR PK ***
A_0(1) = 0                        ;INITIAL CONDITION FOR SC COMPARTMENT 
A_0(2) = C0*VC                    ;INITIAL CONDITION FOR SERUM COMPARTMENT
A_0(3) = C0*VC*K23/K32            ;INITIAL CONDITION FOR TISSUE COMPARTMET
   
;*** INITIAL CONDITION FOR PD ***
RTOT0 = RR0*TP2/TR
RC0 = RTOT0*C0/(KD+C0)
SC0 = SMAX*RC0/(SC50+RC0)
A_0(4) = RR0*TP1/(TR*SC0)*(1/2**5)
A_0(5) = RR0*TP2/TR
A_0(6) = RR0*TP3/TR
A_0(7) = RR0
A_0(8) = RB0-RR0/1000
 
$DES
;*** EQUATIONS FOR PK ***
RTOT = A(5)
KEPO = CL*C0+RTOT0*KSAI*VC*C0/(KD+C0)  ; ZERO ORDER PRODUCTION OF ENDOGENOUS EPO    
 
DADT(1) =     -KA*A(1)                                                                           ;EPO SC
DADT(2) = KEPO+KA*A(1)-CL*A(2)/VC-K23*A(2)+K32*A(3)-RTOT*KSAI*VC*(A(2)/VC)/(KD+A(2)/VC)          ;EPO SERUM
DADT(3) =                         K23*A(2)-K32*A(3)                                              ;EPO TISSUE

;*** EQUATIONS FOR PD ***
C2 = A(2)/VC
RC = RTOT*C2/(KD+C2)
SC = SMAX*RC/(SC50+RC)
KIN0  =  RR0/TR*(1/2**5)
DADT(4) =  KIN0-1/TP1*SC*A(4)
DADT(5) = 2**5*(1/TP1)*SC*A(4)-(1/TP2)*A(5)
DADT(6) =                      (1/TP2)*A(5)-(1/TP3)*A(6)
DADT(7) =                                   (1/TP3)*A(6)-A(7)/TR
DADT(8) =                                                A(7)/(TR*1000)-A(8)/TB
 
$ERROR  
IF (CMT.EQ.2) THEN
IPRED=A(2)/VC
Y = IPRED*(1 + EPS(1))+EPS(2)
ELSE
ENDIF
      
IF (CMT.EQ.7) THEN
IPRED=A(7)
Y = IPRED*(1+EPS(3))
ELSE
ENDIF

IF (CMT.EQ.8) THEN                   
IPRED=A(8)+A(7)/1000
Y = IPRED*(1+EPS(4)) 
ELSE
ENDIF
      
IF (CMT.EQ.9) THEN                   
IPRED=MCH*(A(8)+A(7)/1000)/10
Y = IPRED*(1+EPS(4)) 
ELSE
ENDIF
