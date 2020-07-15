; second level of jump tables
; uses bits 11-9 to narrow search down further
; note: not all instructions use one of these jump tables. Some like moveQ only require the first table, while others don't have consistent 11-9 bit values to allow a jump table to differentiate
*    ORG         $2000

; 0000
jmpTable0000
	STOP		#$0000 *JMP			sub_ORI_to_CCR
	STOP		#$0000 *JMP			sub_ORI_to_SR
	STOP		#$0000 *JMP			sub_ORI
	STOP		#$0000 *JMP			sub_ANDI_to_CCR
	STOP		#$0000 *JMP			sub_ANDI_to_SR
	STOP		#$0000 *JMP			sub_ANDI
	STOP		#$0000 *JMP			sub_SUBI
	STOP		#$0000 *JMP			sub_ADDI
	STOP		#$0000 *JMP			sub_EORI_to_CCR
	STOP		#$0000 *JMP			sub_EORI_to_SR
	STOP		#$0000 *JMP			sub_EORI
	STOP		#$0000 *JMP			sub_CMPI
	STOP		#$0000 *JMP			sub_BTST
	STOP		#$0000 *JMP			sub_BCHG
	STOP		#$0000 *JMP			sub_BCLR
	STOP		#$0000 *JMP			sub_BSET
	STOP		#$0000 *JMP			sub_BTST ; somehow different
	STOP		#$0000 *JMP			sub_BCHG ; somehow different
	STOP		#$0000 *JMP			sub_BCLR ; somehow different
	STOP		#$0000 *JMP			sub_BSET ; somehow different
	STOP		#$0000 *JMP			sub_MOVEP
	
; 0100
jmpTable0100
	STOP		#$0100 *JMP			sub_MOVE_from_SR
	STOP		#$0100 *JMP			sub_MOVE_to_CCR
	STOP		#$0100 *JMP			sub_MOVE_to_SR
	STOP		#$0100 *JMP			sub_NEGX
	STOP		#$0100 *JMP			sub_CLR
	STOP		#$0100 *JMP			sub_NEG
	STOP		#$0100 *JMP			sub_NOT
	STOP		#$0100 *JMP			sub_EXT
	STOP		#$0100 *JMP			sub_NBCD
	STOP		#$0100 *JMP			sub_SWAP
	STOP		#$0100 *JMP			sub_PEA
	STOP		#$0100 *JMP			sub_ILLEGAL
	STOP		#$0100 *JMP			sub_TAS
	STOP		#$0100 *JMP			sub_TST
	STOP		#$0100 *JMP			sub_TRAP
	STOP		#$0100 *JMP			sub_LINK
	STOP		#$0100 *JMP			sub_UNLK
	STOP		#$0100 *JMP			sub_MOVE_USP
	STOP		#$0100 *JMP			sub_RESET
	STOP		#$0100 *JMP			sub_NOP
	STOP		#$0100 *JMP			sub_STOP
	STOP		#$0100 *JMP			sub_RTE
	STOP		#$0100 *JMP			sub_RTS
	STOP		#$0100 *JMP			sub_TRAPV
	STOP		#$0100 *JMP			sub_RTR
	STOP		#$0100 *JMP			sub_JSR
	STOP		#$0100 *JMP			sub_JMP
	STOP		#$0100 *JMP			sub_MOVEM
	STOP		#$0100 *JMP			sub_LEA
	STOP		#$0100 *JMP			sub_CHK
	
; 0101
jmpTable0101
	STOP		#$0101 *JMP			sub_ADDQ
	STOP		#$0101 *JMP			sub_SUBQ
	STOP		#$0101 *JMP			sub_Scc
	STOP		#$0101 *JMP			sub_DBcc
	
; 0110
jmpTable0110
	; done
	STOP		#$0110 *JMP			sub_BRA
	STOP		#$0110 *JMP			sub_BSR
	STOP		#$0110 *JMP			sub_BHI
	STOP		#$0110 *JMP			sub_BLS
	STOP		#$0110 *JMP			sub_BCC
	STOP		#$0110 *JMP			sub_BCS
	STOP		#$0110 *JMP			sub_BNE
	STOP		#$0110 *JMP			sub_BEQ
	STOP		#$0110 *JMP			sub_BVC
	STOP		#$0110 *JMP			sub_BVS
	STOP		#$0110 *JMP			sub_BPL
	STOP		#$0110 *JMP			sub_BMI
	STOP		#$0110 *JMP			sub_BGE
	STOP		#$0110 *JMP			sub_BLT
	STOP		#$0110 *JMP			sub_BGT
	STOP		#$0110 *JMP			sub_BLE
	
	
; 1000
jmpTable1000
	STOP		#$1000 *JMP			sub_DIVU
	STOP		#$1000 *JMP			sub_DIVS
	STOP		#$1000 *JMP			sub_SBCD
	STOP		#$1000 *JMP			sub_OR
	
; 1001
jmpTable1001
	STOP		#$1001 *JMP			sub_SUB
	STOP		#$1001 *JMP			sub_SUBX
	STOP		#$1001 *JMP			sub_SUBA
	
; 1011
jmpTable1011
	STOP		#$1011 *JMP			sub_EOR
	STOP		#$1011 *JMP			sub_CMPM
	STOP		#$1011 *JMP			sub_CMP
	STOP		#$1011 *JMP			sub_CMPA
	
; 1100
jmpTable1100
	STOP		#$1100 *JMP			sub_MULU
	STOP		#$1100 *JMP			sub_MULS
	STOP		#$1100 *JMP			sub_ABCD
	STOP		#$1100 *JMP			sub_EXG
	STOP		#$1100 *JMP			sub_AND
	
; 1101
jmpTable1101
	STOP		#$1101 *JMP			sub_ADD
	STOP		#$1101 *JMP			sub_ADDX
	STOP		#$1101 *JMP			sub_ADDA
	
; 1110
jmpTable1110
	STOP		#$1110 *JMP			sub_ASd ; for ASR/ASL
	STOP		#$1110 *JMP			sub_LSd ; for LSR/LSL
	STOP		#$1110 *JMP			sub_ROXd ; for ROXR & ROXL
	STOP		#$1110 *JMP			sub_
	
*	END         jmpTable0000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
