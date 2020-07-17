; second level of jump tables
; uses bits 11-9 to narrow search down further
; note: not all instructions use one of these jump tables. Some like moveQ only require the first table, while others don't have consistent 11-9 bit values to allow a jump table to differentiate
*    ORG         $2000

; STOP #$DEAD means we don't need to interpret this instruction for the project
; TODO: simplify unrequired jump tables
	
; 0100
jmpTable0100
	STOP		#$0100 *JMP			sub_MOVE_from_SR * not required
	STOP		#$0100 *JMP			sub_MOVE_to_CCR * not required
	STOP		#$0100 *JMP			sub_MOVE_to_SR * not required
	STOP		#$DEAD *JMP			sub_NEGX * not required
	STOP		#$DEAD *JMP			sub_CLR * not required
	STOP		#$DEAD *JMP			sub_NEG * not required
	
	STOP		#$0100 *JMP			sub_NOT
	
	STOP		#$DEAD *JMP			sub_EXT * not required
	STOP		#$DEAD *JMP			sub_NBCD * not required
	STOP		#$DEAD *JMP			sub_SWAP * not required
	STOP		#$DEAD *JMP			sub_PEA * not required
	STOP		#$DEAD *JMP			sub_ILLEGAL * not required
	STOP		#$DEAD *JMP			sub_TAS * not required
	STOP		#$DEAD *JMP			sub_TST * not required
	STOP		#$DEAD *JMP			sub_TRAP * not required
	STOP		#$DEAD *JMP			sub_LINK * not required
	STOP		#$DEAD *JMP			sub_UNLK * not required
	STOP		#$DEAD *JMP			sub_MOVE_USP * not required
	STOP		#$DEAD *JMP			sub_RESET * not required
	
	STOP		#$0100 *JMP			sub_NOP
	
	STOP		#$DEAD *JMP			sub_STOP * not required
	STOP		#$DEAD *JMP			sub_RTE * not required
	
	STOP		#$0100 *JMP			sub_RTS
	
	STOP		#$DEAD *JMP			sub_TRAPV * not required
	STOP		#$DEAD *JMP			sub_RTR * not required
	
	STOP		#$0100 *JMP			sub_JSR
	
	STOP		#$DEAD *JMP			sub_JMP * not required
	
	STOP		#$0100 *JMP			sub_MOVEM
	STOP		#$0100 *JMP			sub_LEA
	
	STOP		#$DEAD *JMP			sub_CHK * not required
	
; 0110
jmpTable0110
	STOP		#$0110 *JMP			sub_BRA
	
	JMP			invalidOpcode       * BSR not required
	JMP			invalidOpcode       * BHI not required
	JMP			invalidOpcode       * BLS not required
	JMP			invalidOpcode       * BCC not required
	JMP			invalidOpcode       * BCS not required
	JMP			invalidOpcode       * BNE not required
	
	STOP		#$0110 *JMP			sub_BEQ
	
	JMP			invalidOpcode       * BVC not required
	JMP			invalidOpcode       * BVS not required
	JMP			invalidOpcode       * BPL not required
	JMP			invalidOpcode       * BMI not required
	JMP			invalidOpcode       * BGE not required
	JMP			invalidOpcode       * BLT not required
	
	STOP		#$0110 *JMP			sub_BGT
	STOP		#$0110 *JMP			sub_BLE
	
	
; 1000
jmpTable1000
	STOP		#$1000 *JMP			sub_DIVU
	
	STOP		#$DEAD *JMP			sub_DIVS * not required
	STOP		#$DEAD *JMP			sub_SBCD * not required
	STOP		#$DEAD *JMP			sub_OR * not required
	
; 1100
jmpTable1100
	STOP		#$DEAD *JMP			sub_MULU * not required
	
	STOP		#$1100 *JMP			sub_MULS
	
	STOP		#$DEAD *JMP			sub_ABCD * not required
	STOP		#$DEAD *JMP			sub_EXG * not required
	
	STOP		#$1100 *JMP			sub_AND
	
; 1101
jmpTable1101
	STOP		#$1101 *JMP			sub_ADD
	STOP		#$DEAD *JMP			sub_ADDX * not required
	STOP		#$DEAD *JMP			sub_ADDA * not required
	
; 1110
jmpTable1110
	STOP		#$1110 *JMP			sub_ASd ; for ASR/ASL
	STOP		#$1110 *JMP			sub_LSd ; for LSR/LSL
	STOP		#$DEAD *JMP			sub_ROXd * not required
	STOP		#$1110 *JMP			sub_
	
*	END         jmpTable0000

sub0100_000
; required: LEA
; invalid: MOVE from SR, NEGX, (possibly) CHK

sub0100_001
; required: 
; invalid: 

sub0100_010
; required: 
; invalid: 

sub0100_100
; required: 
; invalid: 

sub0100_101
; required: 
; invalid: 

sub0100_110
; required: 
; invalid: 

sub0100_111
; required: RTS,JSR,LEA (if dest is A7)
; invalid: 

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
