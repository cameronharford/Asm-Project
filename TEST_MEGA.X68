*-----------------------------------------------------------
* Title      : test2
* Written by : Power PC is Better
* Date       : 08/10/2020
* Description: Test file for Disassembler version 2
*-----------------------------------------------------------
  	  ORG    $7000
START:                  ; first instruction of program

        MOVEQ #1,D0
        MOVEQ #$FF,D0
* Test Size (also tests Dn as dest and Dn as src)
        MOVE.B  D7,D0           ;test01 size byte
        MOVE.W  D6,D1           ;test02 size word
        MOVE.L  D5,D2           ;test03 size long 
    
* Test Destination EA
        MOVE.B  D1,(A0)         ;test04 dest (An)
        MOVE.B  D1,(A0)+        ;test05 dest (An)+
        MOVE.B  D1,-(A0)        ;test06 dest -(An)
        MOVE.B  D1,$42A6        ;test07 dest (xxx).W
        MOVE.B  D1,$0000A000    ;test08 dest (xxx).L

* Test Source EA
        MOVE.W  A1,D1           ;test09 src An
        MOVE.B  (A1),D1         ;test10 src (An)
        MOVE.B  (A1)+,D1        ;test11 src (An)+
        MOVE.B  -(A1),D1        ;test12 src -(An)
        MOVE.W  $42A6,D1        ;test13 src (xxx).W
        MOVE.L  $0000A000,D1    ;test14 src (xxx).L
        MOVE.B  #$2A,D1         ;test15 src #<data>
        
* Tricky
        MOVE.W  #$9100,D0       ;test16
        MOVE.L  #$9100,D0       ;test17
        MOVE.W  #$4214,D0       ;test18
        MOVE.L  #$4214,D0       ;test19
        MOVE.B  $00004340,D3    ;test20
        MOVE.B  $A340,D3        ;test21
        MOVE.B  $FFFFA340,D3    ;test22
        MOVE.B  $FFFF4340,D3    ;test23
        MOVE.W  $A340,D3        ;test24

		ADDQ.L	#07,D7		
		ADDA.L	-(SP),A2
		ADDA.W	(A6)+,A3
		ADDA.L	#$3000AAAA,A6
		ADDI.L	#$D50000AA,D5
		ADDI.W	#$5555,D6
		ADDI.B	#$FE,D0
		
* Group is random data

data1		DC.B		$FF,$AA,$45,$0A
data2		DC.B		$00,00,01,00,00,00
data3		DC.W		$AAAA,$5555,0000,$FFFF

* This is an illegal instruction, MOVE.B    #$0F,A6

* illegal		DC.W		$1C7C,$000F

* Move instructions

moves		MOVE.B	D0,D1
		MOVE.W	A6,$F30045BB
		MOVE.L	D0,D0
		MOVE.L	D7,(A6)+
		MOVE.W	#$FFD0,(A3)
		MOVE.L	$C00022AA,$3000A0F8
		MOVE.L	A0,-(A5)
		MOVEA.W	(A6),A0
		MOVEM.W	A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)
		MOVEM.L	(A0)+,D0/D1/D2/A4/A3/A0/A1
*		MOVEA.L	#$AAAA00AA,A2
		
* Divide and multiple optional instructions

ands		AND.B	#$01,$4568
		AND.L	$8000A000,D3
shifts		LSL.B	D0,D0
		LSL.W	#4,D0
		LSL.W	(A2)+
		ASR.B	D6,D7
rolls		ROL.L	D2,D3
		ROR.L	#4,D6

clear		CLR.B	D4
load_addr	LEA	$DC00FF00,A2
		LEA	(A5),A4
		LEA	(ands,PC),A3
		LEA	-$20(A2,D7),A2

* random data	
		DC.W	2949,0411,2848,7869

compares	CMP.B	(A3),D5
		CMP.L	$ABC0FF00,D2
		CMPA.W	D2,A4
* Branches	
		

* Jump and branch instructions

jmplabel	BSR	compares	* BSR long test
		BSR	rolls	        * BSR short test	
		JSR	(A3)		* Address register indirect
		BSR	multiply
		BSR	$2000
		BCC	clear		
		BGT	compares		
		BLE	multiply	

		
		
		
*These are not required instructions
multiply	MULS	D0,D3		*Optional instruction
		MULS	(A6),D0		*Optional instruction
		MULS	#$4567,D1	*Optional instruction
		DIVU	(A3)+,D5	*Optional instruction
		NOP
		NOP
		SUB.L	#$00000055,D4
		SUB.L	#$FFFFFFEE,D7
		* Test Size (also immediate mode and tests Dn as dest)
        ASL.B   #1,D0           ;test01 - E300
        ASR.W   #1,D1           ;test02 - E241
        LSL.L   #1,D2           ;test03 - E38A
        LSR.B   #1,D3           ;test04 - E20B
        ROL.W   #1,D4           ;test05 - E35C
        ROR.L   #1,D5           ;test06 - E29D
    
* Test Register to Register Shift Mode
        ASR.B   D7,D0           ;test07 - EE20
        LSL.B   D6,D1           ;test08 - ED29
        ROL.B   D5,D2           ;test09 - EB3A

* Test Immediate Shift Mode
        ASR.B   #6,D0           ;test10 - EC00
        LSL.B   #7,D0           ;test11 - EF08
        ROL.B   #8,D0           ;test12 - E118

* Test Register Shift Mode
        ASR.W   (A0)            ;test13 - E0D0
        LSL.W   (A0)+           ;test14 - E3D8
        ROL.W   -(A0)           ;test15 - E7E0
        ASR.W   $42A6           ;test16 - E0F8 42A6
        LSL.W   $9100           ;test17 - E3F9 00009100
        ROL.W   $0000A000       ;test18 - E7F9 0000A000
        ADD.B  D7,D0           ;test01 size byte
        ADD.W  D6,D1           ;test02 size word
        ADD.L  D5,D2           ;test03 size long 
    
* Test Destination EA
        ADD.B  D1,(A0)         ;test04 dest (An)
        ADD.B  D1,(A0)+        ;test05 dest (An)+
        ADD.B  D1,-(A0)        ;test06 dest -(An)
        ADD.B  D1,$42A6        ;test07 dest (xxx).W
        ADD.B  D1,$0000A000    ;test08 dest (xxx).L

* Test Source EA
        ADD.W  A1,D1           ;test09 src An
        ADD.B  (A1),D1         ;test10 src (An)
        ADD.B  (A1)+,D1        ;test11 src (An)+
        ADD.B  -(A1),D1        ;test12 src -(An)
        ADD.W  $42A6,D1        ;test13 src (xxx).W
        ADD.L  $0000A000,D1    ;test14 src (xxx).L
        
* Tricky
        ADD.B  $4340,D3        ;test15
        ADD.B  $0000A340,D3    ;test16
        ADD.B  $0000A340,D3    ;test17
        ADD.B  $FFFF4340,D3    ;test18
        ADD.W  $0000A340,D3    ;test19 - failed memory address

first   ADD.B   D0,D1       ; D200 - ADD
        ADDA.W  D0,A0       ; D0C0 - ADDA
        ADDI.B  #$FF,D0     ; 0600 00FF - ADDI
        ADDI.B  #1,D0       ; 5200 - ADDQ (need to add)
        AND.B   D0,D1       ; C200 - AND
        ANDI.B  #1,D0       ; 0200 0001 - ANDI
        ASL.B   #1,D0       ; E300 - SHIFT_ROT
        ASR.B   #1,D0       ; E200 - SHIFT_ROT
        BCC     test1       ; 64E6 - BCC (00006FFC)

        BCC.W   test1       ; 6400 FFE2 - BCC (00006FFC)
        BGT     test2       ; 6E00 0058 - BCC (00007076)

        BGT.W   test2       ; 6E00 0052 - BCC (00007076)
        BLE     $702E       ; 6F06 - BCC (0000702E)

        BLE.W   $702E       ; 6F00 0002 - BCC (0000702E)
        CLR.B   D0          ; 4200 - CLR
        CMP.B   D0,D1       ; B200 - CMP
        CMPI.B  #1,D0       ; 0C00 0001 - CMPI
        DIVS.W  #1,D1       ; 83FC 0001 - DIVS
        DIVU.W  #1,D1       ; 82FC 0001 - DIVU


        LSR.B   #1,D0       ; E208 - SHIFT_ROT
        MOVE.B  D0,D1       ; 1200 - MOVEB
        MOVE.L  D0,D1       ; 2200 - MOVEL
        MOVE.W  D0,D1       ; 3200 - MOVEW
        MOVEM.W D0,-(SP)    ; 48A7 8000 - MOVEM_TO_EA
        MOVEQ.L #1,D0       ; 7001 - MOVEQ
        MULS.W  D0,D1       ; C3C0 - MULS
        NOP                 ; 4E71 - NOP
        NOT.W   D1          ; 4641 - NOT (Triggers OP_INVALID)
        ROL.B   #1,D0       ; E318 - SHIFT_ROT
        ROR.B   #1,D0       ; E218 - SHIFT_ROT
        SUB.B   #1,D0       ; 5300 - SUBQ (need to add)
        SUB.B   #$FF,D0     ; 0040 00FF - SUBI
        SUB.B   D0,D1       ; 9200 - SUB
        SUBA.W  #1,A0       ; 5348 - SUBQ
        SUBA.W  #$FF,A0     ; 90FC 00FF - SUBA


        ADDA.L	#$3000AAAA,A6
		ADDI.L	#$D50000AA,D5
		ADDI.W	#$5555,D6
        
        MOVE.W	#$FFD0,(A3)
        MOVEA.W	(A6),A0
		;MOVEM.W	A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test 8 failed
		;MOVEM.L	(A0)+,D0/D1/D2/A4/A3/A0/A1      ;test 9 failed
        
        LSL.W	(A2)+
		ASR.B	D6,D7
		
		LEA	$DC00FF00,A2
		LEA	(A5),A4
		LEA	-$20(A2,D7),A2
		
		MULS	#$4567,D1
		
		SUB.L	#$00000055,D4
		SUB.L	#$FFFFFFEE,D7
		        MOVEM       D0-D7,-(A7)                     ;test1
        MOVEM       (A7)+,D0-D7                     ;test2

        MOVEM       A0-A6,-(A7)                     ;test3
        MOVEM       (A7)+,A0-A6                     ;test4
  
        MOVEM       A0-A6/D0-D7,-(A7)               ;test5
        MOVEM       (A7)+,A0-A6/D0-D7               ;test6
 
        MOVEM       D0-D7/A0-A6,$2468               ;test7
        MOVEM       D0-D7/A0-A6,$2468               ;test8

*   test different sizes        
        MOVEM       (A1)+,D0-D7                     ;test9
        MOVEM.W     (A1)+,D0-D7                     ;test10
        MOVEM.L     (A1)+,D0-D7                     ;test11
        MOVEM.L     D0-D7/A0-A6,$1234               ;test12

        MOVEM.L     (A5),D0-D2/D5-D7/A0-A3/A6       ;test13
        MOVEM.W     D0-D5/D7/A0-A6,-(A7)            ;test14
        MOVEM.W     (A7)+,D0-D5/D7/A0-A6            ;test15

        MOVEM.L     A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test16
        MOVEM.L     (A0)+,D0/D1/D2/A4/A3/A0/A1      ;test17

NOP     NOP

BRS     BSR         TEST1
        
        BRA         TEST2
        
        BPL         TEST1
        BGE         TEST1    
        BHI         TEST1
        BVC         TEST1
        BLT         TEST1
        BCS         TEST1
        
JMP     JMP         CONTINUE 
        
CONTINUE

LEA     LEA     $1234,A1
        LEA     (A1),A2
    
CLR     CLR    D2 

CMPI    CMPI        #1,(A1)
        CMPI        #1,(A2)
        
        CMPI.B      #1,D0
        CMPI.B      #1,D1
        
        CMPI.W      #1,D0
        CMPI.L      #1,D0
        
        CMPI.B      #1,$00001234
        CMPI.W      #012345,$00001234
        CMPI.L      #000012345,$00001234

        CMPI.W      #2,$FFFF1234
        
CMP     CMP         $FFFF1234,D0
        CMP         D0,D1
        CMP         A1,D4
        CMP         D4,A1
        CMP         (A1),D4
        
        CMP.B       $FFFF1234,D5
        CMP.B       $00001234,D5
        CMP.W       $1234,D5
        CMP.L       $1234,D5
        
NEG     NEG.B       D0
        NEG.W       D0
        NEG.L       D0
        
        NEG.B       (A1)
        NEG.W       (A1)
        NEG.L       (A1)      

        NEG         -(A1)
        NEG         (A1)+
        
        NEG.B       $FFFF1234  
        NEG.W       $FFFF1234  
        NEG.L       $FFFF1234   
        
ADD     ADD         D0,D1
        ADD.B       D0,D1
        ADD.W       D0,D1
        ADD.L       D0,D1
        
        ADD.B       D2,D1
        ADD.W       D2,D1
        ADD.L       D2,D1
        
        ADD         $00001234,D1
        ADD.B       $00001234,D1
        ADD.W       $00001234,D1
        ADD.L       $00001234,D1

        ADD.L       $FFFF1234,D1
        ADD.L       D1,$FFFF1234
        
        ADD         #100,D5
        ADD.B       #100,D5
        ADD.W       #100,D5
        ADD.L       #100,D5
        
        ADD         -(A0),D0
        ADD         D0,(A0)
        ADD         D0,(A0)+
        ADD         A0,D0
        
        ADD.L       $40(A0),D0

ADDQ    ADDQ.B      #5,D2
        ADDQ.W      #5,D3
        ADDQ.L      #5,D4
        
        ADDQ.B      #5,$11112345
        ADDQ.W      #5,$11112345
        ADDQ.L      #5,$11112345
        
ADDA    ADDA        #5,A1

        ADDA.W      #5,A1
        ADDA.L      #5,A1

        ADDA.W      $0001234,A1
        ADDA.L      $FFFF1234,A1
        

SUB     SUB         D0,D1
        SUB.B       D0,D1
        SUB.W       D0,D1
        SUB.L       D0,D1
        
        SUB.B       D2,D1
        SUB.W       D2,D1
        SUB.L       D2,D1
        
        SUB         $00001234,D1
        SUB.B       $00001234,D1
        SUB.W       $00001234,D1
        SUB.L       $00001234,D1

        SUB.L       $FFFF1234,D1
        SUB.L       D1,$FFFF1234
        
        SUB         #100,D5
        SUB.B       #100,D5
        SUB.W       #100,D5
        SUB.L       #100,D5
        
        SUB         -(A0),D0
        SUB         D0,(A0)
        SUB         D0,(A0)+
        SUB         A0,D0
        
        SUB.L       $40(A0),D0

SUBQ    SUBQ.B      #5,D2
        SUBQ.W      #5,D3
        SUBQ.L      #5,D4
        
        SUBQ.B      #5,$11112345
        SUBQ.W      #5,$11112345
        SUBQ.L      #5,$11112345
        
SUBA    SUBA        #5,A1

        SUBA.W      #5,A1
        SUBA.L      #5,A1

        SUBA.W      $0001234,A1
        SUBA.L      $FFFF1234,A1
        
MULU    MULU        D0,D1
        MULU        (A1),D1
        MULU        #3,D0
        MULU        $00001234,D0
        MULU.W      $FFFF1234,D0
    
MULS    MULS        #45,D1
        MULS        $00001234,D1
        MULS        $FFFF1234,D1
    
DIVU    DIVU        D0,D1
        DIVU        (A1),D1
        DIVU        #$00001234,D2
        DIVU        #$1200,D2
        
        DIVU.W      $00001234,D2
        DIVU.W      $1200,D2
        DIVU.W      $FFFF1234,D2  

AND     AND.B       #$01,$1234
        AND.W       #$01,$1234
        AND.L       #$01,$1234

        AND.B       D5,D6
        AND.W       D5,(A6)
        AND.L       #$0000FFFF,D5

OR      OR          D1,D2
        OR          D1,$00001234
        
        OR          D2,(A1)
        OR          (A1),D2
        OR          D2,(A1)+
        OR          -(A2),D2

NOT     NOT.B       D1
        NOT.W       D1
        NOT.L       D1
        
        NOT.B       (A1)
        NOT.W       (A1)
        NOT.L       (A1)      
        
RO      ROL         $00001234
        ROL         $FFFF0123
        
        ROR         $00001234
        ROR         $FFFF0123
        ROR         (A1)+
        ROR         -(A2)    
        
        ROL.B       D1,D2
        ROL.W       D1,D2
        ROL.L       D1,D2
        
        ROL.B       #$08,D3
        ROL.W       #$04,D3
        ROL.L       #$01,D3
       
LS      LSL         $00001234
        LSL         $FFFF0123
        
        LSR         $00001234
        LSR         $FFFF0123
        LSR         (A1)+
        LSR         -(A2)    
        
        LSL.B       D1,D2
        LSL.W       D1,D2
        LSL.L       D1,D2
        
        LSL.B       #$08,D3
        LSL.W       #$04,D3
        LSL.L       #$01,D3
  
AS      ASL         $00001234
        ASL         $FFFF0123
        
        ASR         $00001234
        ASR         $FFFF0123
        ASR         (A1)+
        ASR         -(A1)     
        
        ASL.B       D1,D2
        ASL.W       D1,D2
        ASL.L       D1,D2
        
        ASL.B       #$08,D2
        ASL.W       #$04,D2
        ASL.L       #$01,D2

MOVE    MOVE.B      D0,D1
        MOVE.W      D0,D1
        MOVE.L      D0,D1

        MOVE.B      D2,D1
        MOVE.W      D2,D1
        MOVE.L      D2,D1 

        MOVE.B      D1,(A0)
        MOVE.B      D1,(A0)+ 
        MOVE.B      D1,-(A0)
        
        MOVE.B      D1,$42A6
        MOVE.B      D1,$0000A000

        MOVE.W      A1,D1 
             
        MOVE.B      (A1),D1         
        MOVE.B      (A1)+,D1
        MOVE.B      -(A1),D1
        
        MOVE.B      (A1),$00001234
        MOVE.W      -(A1),$00001234
        MOVE.L      (A1)+,$00001234 
 
        MOVE.B      #$2B,D1 
        MOVE.W      $1234,D1 
        MOVE.L      $0000A000,D1

        MOVE.W      #$1234,D0             
        MOVE.L      #$1234,D0
        
        MOVE.W      #$4567,D0
        MOVE.L      #$4567,D0   
    
        MOVE.B      $00004340,D3   
        MOVE.B      $A340,D3        
        MOVE.B      $FFFFA340,D3   
        MOVE.B      $FFFF4340,D3   
        MOVE.W      $A340,D3  

        MOVE.W      #12,D5
        MOVE.B      #12,D5
        MOVE.L      #12,D5      
 
MOVEQ   MOVEQ       #1,D5
        MOVEQ       #$12,D5
        MOVEQ       #$FF,D5         

MOVEA   MOVEA.W     $00001234,A1
        MOVEA.L     $FFFF1234,A1
        
        MOVEA.W     (A2),A3
        MOVEA.L     (A2)+,A3
        
        MOVEA.W     -(A2),A3 
        MOVEA.W     -(SP),A3
        MOVEA.W     -(A7),A4

MOVEM   MOVEM       D0-D7,(A7)
        MOVEM       D0-D7,-(A7)
        MOVEM       (A7)+,D0-D7
        
        MOVEM       A0-A6,(A7)
        MOVEM       A0-A6,-(A7)
        MOVEM       (A7)+,A0-A6
        
        MOVEM       A0-A6/D0-D7,(A7)
        MOVEM       A0-A6/D0-D7,-(A7)
        MOVEM       (A7)+,A0-A6/D0-D7
        
        MOVEM       D0-D7/A0-A6,$1234
        MOVEM.L     D0-D7/A0-A6,$1234
         
        MOVEM       (A1)+,D0-D7
        MOVEM.W     (A1)+,D0-D7
        MOVEM.L     (A1)+,D0-D7
                    
        MOVEM.L     A0-A6,-(SP)
        MOVEM.L     (SP)+,A0-A6
        MOVEM.L     D0-D7,-(SP)
        MOVEM.L     (SP)+,D0-D7             

        MOVEM.W     (A5),D0-D2/D4-D6/A0-A2/A4 
        MOVEM.W     (A5)+,D0-D2/D4-D6/A0-A2/A4       
        MOVEM.W     D0-D2/D4-D6/A0-A2/A4,-(A5)
 
        MOVEM.L     (A5),D0-D2/D4-D6/A0-A2/A4 
        MOVEM.L     (A5)+,D0-D2/D4-D6/A0-A2/A4       
        MOVEM.L     D0-D2/D4-D6/A0-A2/A4,-(A5)            

        MOVEM.L     A0/A1/A2/D4/D5/D6,$2B(A3,D3.L)  
        MOVEM.L     (A0)+,A0/A1/A2/D4/D5/D6 
        
  	  SIMHALT             ; halt simulator

* Put variables and constants here
TEST1   MOVE.B   #$10,D1   
        RTS

TEST2   MOVE.B   #$20,D2
        RTS
        
    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
