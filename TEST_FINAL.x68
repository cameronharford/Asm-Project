  	  ORG    $7000
START:                  ; first instruction of program

NOP     NOP

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
LEA     LEA     $1234,A1
        LEA     (A1),A2
		
AND     AND.B       #$01,$1234
        AND.W       #$01,$1234
        AND.L       #$01,$1234

        AND.B       D5,D6
        AND.W       D5,(A6)
        AND.L       #$0000FFFF,D5

NOT     NOT.B       D1
        NOT.W       D1
        NOT.L       D1
        
        NOT.B       (A1)
        NOT.W       (A1)
        NOT.L       (A1)

LSL     LSL         $00001234
        LSL         $FFFF0123  
        
        LSL.B       D1,D2
        LSL.W       D1,D2
        LSL.L       D1,D2
        
        LSL.B       #$08,D3
        LSL.W       #$04,D3
        LSL.L       #$01,D3

ASL     ASL         $00001234
        ASL         $FFFF0123   
        
        ASL.B       D1,D2
        ASL.W       D1,D2
        ASL.L       D1,D2
        
        ASL.B       #$08,D2
        ASL.W       #$04,D2
        ASL.L       #$01,D2
TEST        
		JSR         TEST
		BRA         TEST
		RTS
		RTS
		RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
