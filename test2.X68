*-----------------------------------------------------------
* Title      : test2
* Written by : Power PC is Better
* Date       : 08/10/2020
* Description: Test file for Disassembler version 2
*-----------------------------------------------------------
  	  ORG    $7000
START:                  ; first instruction of program

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
