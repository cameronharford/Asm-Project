	INCLUDE		"identityJmpTable.X68"

findOpcodeMain: 
    ; save return addr to A5 so invalidOpcode can directly return
    MOVEA       SP,A5
    
    ; D0 contains the first 16 bits of an instruction already
	
	; save instruction to D4
	MOVE		D0, D4
	
	; trim down bits so only 15-12 remain and are shifted to 3-0
	isoBitsM    D0,#15,#12

	; load first jump table address into A0
    LEA         firstJmpTable,A0
	
	; get an offset of the first jump table to branch to, then jump there
	BSR 		calcJmpOffset
	
	; TODO: we've found out what the opcode does, so do shit with this knowledge
	RTS
	
; Instruction "class"
INSTR_NAME_PTR		DS.L	1	; This could also just be the name string itself, for which 16 bytes should be sufficient space
INSTR_SIZE_STR		DC.B	'.B',0	; I should change the default value here to whatever size appears most often

INSTR_ARG_1_TYPE	DC.B	1	; 1 = immediate, 2 = data register, 3 = address register, 4 = effective address
INSTR_ARG_1_DATA	DC.L	0	; 1 = some number, 2/3 = ptr to data/address string, 4 = calculated destination address

INSTR_ARG_2_TYPE	DC.B	1	;
INSTR_ARG_2_DATA	DC.L	0	;






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
