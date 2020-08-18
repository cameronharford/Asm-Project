  	  ORG    $7000
START:                  ; first instruction of program
        MOVEM       D0-D7,(A7)
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
		END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
