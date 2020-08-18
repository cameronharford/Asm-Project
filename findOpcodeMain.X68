	INCLUDE		"identityJmpTable.X68"

findOpcodeMain:    
    ; read the opcode from memory
    MOVE.W      (A6)+,D4
	
	; trim down bits so only 15-12 remain and are shifted to 3-0
	isoBitsM    D4,#15,#12

	; load first jump table address into A0
    LEA         firstJmpTable,A0
	
	; get an offset of the first jump table to branch to, then jump there
    BRA 		calcJmpOffset


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
