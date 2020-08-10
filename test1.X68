*-----------------------------------------------------------
* Title      : test1
* Written by : Power PC is Better
* Date       : 07/08/2020
* Description: Test file for Disassembler version 1
*-----------------------------------------------------------
  	  ORG    $1000
START:                  ; first instruction of program

NOP     NOP

BRS     BSR         TEST1
        JMP         CONTINUE    ; doesn't test BRA, etc
        
        BRA         TEST2
        BPL         TEST1
        BGE         TEST1    
        BHI         TEST1
        BVC         TEST1
        BLT         TEST1
        BCS         TEST1
        
CONTINUE

LEA     LEA         $00001234, A5
        LEA         (A4),A5

CMPI    CMPI.L      #2, D0
        CMPI.L      #012345, $00001234
        CMPI.B      #1,D1
        CMPI.W      #2, $FFFF1234
        CMPI        #3,(A1)
        
CMP     CMP         $FFFF1234,D0
        CMP         D0,D1
        CMP         A1,D4
        CMP.B       $FFFF1234,D5
        CMP.B       $00001234,D6
        CMP.W       $1234,D7
        CMP.L       $1234,D1
        
NEG     NEG.L       $00001234       
        NEG.B       D0
        NEG.W       D1
        NEG.W       (A1)
        NEG         -(A1)
        NEG         (A1)+   
        
ADD     ADD.B       D0,D1
        ADD.W       D1,D0
        ADD.L       $00001234,D1
        ADD         D1,$00001234
        ADD.L       $FFFF1234,D1
        ADD.B       D2, $FFFF1234
        ADD.B       #1,D5
        ADD.W       #10,D6

ADDQ    ADDQ.B      #5,D5
        ADDQ.L      #5,D7 
        
ADDA    ADDA        #5,A1
        ADDA.W      $0001234,A2
        ADDA.L      $FFFF1234,A0
        
SUB     SUB.B       D5,D4
        SUB.W       D5,D4
        SUB.L       D5,D4
        SUB.L       D1,$00001234
        SUB.L       $00001234,D1
        SUB.L       D1, $FFFF1234
        SUB.L       $FFFF1234,D1
        SUB         (A0),D3
        SUB         D1,(A1)
        SUB         -(A1),D3

SUBQ    SUBQ        #1, D3
        SUBQ.B      #8, $11112345
        SUBQ.L      #1, $00001234

SUBA    SUBA        #12,A1              
        SUBA.L      $00001234,A2
        SUBA.W      $FFF12345, A4

MULU    MULU        #3,D0
        MULU        $00001234,D5
        MULU.W      $FFFF1100, D6
    
MULS    MULS        #45,D1
        MULS        $00001234,D7
        MULS        $FFFF1000, D2
    
DIV     DIVS.W      $00001234,D0
        DIVS.W      $1200, D5
        DIVS.W      $FFFF3658,D2  

AND     AND.L       #$0000FFFF,D5
        AND.B       D5,D6
        AND.W       D7,(A5)

OR      OR          D1,D2
        OR          D1,$00001234
        OR          D2,(A1)
        OR          (A1),D3
        OR          D1,(A2)+
        OR          -(A2),D3

NOT     NOT.L       (A1)
        NOT.W       D7
        
RO      ROL         $00001234
        ROL         $FFFF0123
        
        ROR         $00001234
        ROR         $FFFF0123
        ROR         (A1)+
        ROR         -(A2)    
        
        ROL.B       D1,D2
        ROL.W       D1,D2
        ROL.L       D3,D4
        
        ROL.B       #$08,D5
        ROL.W       #$04,D6
        ROL.L       #$01,D1
       
LS      LSL         $00001234
        LSL         $FFFF0123
        
        LSR         $00001234
        LSR         $FFFF0123
        LSR         (A1)+
        LSR         -(A2)    
        
        LSL.B       D1,D2
        LSL.W       D1,D2
        LSL.L       D3,D4
        
        LSL.B       #$08,D5
        LSL.W       #$04,D6
        LSL.L       #$01,D1
  
AS      ASL         $00001234
        ASL         $FFFF0123
        
        ASR         $00001234
        ASR         $FFFF0123
        ASR         (A1)+
        ASR         -(A2)     
        
        ASL.B       D1,D2
        ASL.W       D1,D2
        ASL.L       D3,D4
        
        ASL.B       #$08,D5
        ASL.W       #$04,D6
        ASL.L       #$01,D1

MOVE    MOVE        D1,$00001234
        MOVE.B      $1234,D0       
        MOVE.B      #$10,D2
      
        MOVE.B      (A1),D5
        MOVE.W      -(A2),$00001234
        MOVE.L      (A1)+,$00001234 
 
        MOVE.W      A2,D3
        MOVE.W      #123, D5
        MOVE.B      #12,D6
        MOVE.L      #14,D5
        MOVE.L      #20, D7
 
MOVEQ   MOVEQ       #$23,D6
        MOVEQ       #123,D7         

MOVEA   MOVEA.W     $00001234,A1
        MOVEA.L     $FFFF1234,A2
        MOVEA.W     (A2),A1
        MOVEA.L     (A2)+,A3
        MOVEA.W     -(A3),A3 
        MOVEA.W     -(SP),A3
        MOVEA.W     -(A7),A4

MOVEM   MOVEM.L     A0-A6,-(SP)
        MOVEM.L     (SP)+,D0-D7
        MOVEM.W     D0/D5/A2-A6,-(A1)
        MOVEM.W     (A2),D4/D6-D7/A5
        
  	  SIMHALT             ; halt simulator

* Put variables and constants here
TEST1   MOVE.B   #$10,D2   
        RTS

TEST2   MOVE.W   #$20,D1   
        RTS
        
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
