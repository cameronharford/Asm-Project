	INCLUDE		"identityJmpTable.X68"

findOpcodeMain:    
    ; D0 contains the first 16 bits of an instruction already
	
	; save instruction to D4
	MOVE		D0, D4
	
	; trim down bits so only 15-12 remain and are shifted to 3-0
	isoBitsM    D0,#15,#12

	; load first jump table address into A0
    LEA         firstJmpTable,A0
	
	; get an offset of the first jump table to branch to, then jump there
    BRA 		calcJmpOffset
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
