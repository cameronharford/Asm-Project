    INCLUDE		"dependencies.X68"

; jump table for bits 15-12 of an instruction opcode
; NOPs are used for padding because jumps to invalidOpcode
; only have a word extension rather than a long
firstJmpTable
    JMP         invalidOpcode       ; 0000 are all invalid
    NOP
    JMP         moveByte
    
    JMP         moveLong
    
    JMP         moveWord
    
    JMP         code0100            ; NOT,NOP,RTS,JSR,MOVEM,LEA
    
    JMP         invalidOpcode       ; 0101 are all invalid
    NOP
    JMP         branchIdentify      ; BRA,BEQ,BGT,BLE. rest are invalid
    
    JMP         invalidOpcode       ; MOVEQ is invalid
    NOP
    JMP         code1000            ; DIVU, rest are invalid
    
    JMP         subIdentify         ; SUB, rest are invalid
    
    JMP         invalidOpcode       ; no opcodes have 1010
    NOP
    JMP         invalidOpcode       ; 1011 are all invalid
    NOP
    JMP         code1100            ; MULS,AND good. rest are invalid
    
    JMP         addIdentify         ; ADD, rest are invalid
    
    JMP         shiftIdentify       ; ASd and LSd, rest are invalid
    
    JMP         invalidOpcode       ; 1111 are all invalid


************************************************************
**                     MOVE instruction                   **
************************************************************
; to distinguish between MOVE and MOVEA, check bits 8-6
; if 8-6 is 001 (indicating mode is addr reg) then it's MOVEA
moveByte     
	; Move Byte
    BSR         moveBitCheck
    PRINTC      <'B'>
	MOVEQ       #1,D5
    RTS

moveLong  
	; Move Long
    BSR         moveBitCheck
    PRINTC      <'L'>
	MOVEQ       #1,D5
    RTS
    
moveWord  
	; Move Word
    BSR         moveBitCheck
    PRINTC      <'W'>
	MOVEQ       #1,D5
    RTS

moveBitCheck
    isoBitsM    D4,#8,#6
    CMP.B       #%001,D0
    BEQ         invalidOpcode
    PRINT       <'MOVE.'>
    setFlagS    #$99F
    setFlagD    #$19D
    RTS
************************************************************
**             NOT, NOP, RTS, JSR, MOVEM, LEA             **
************************************************************
code0100  
	; NOT: bits 11-8 always 0110 and bits 7-6 never 11
	; only other opcode in this section with 11-8 0110 is MOVE to SR (7-6 always 11)
    ; NOP: always 4E71
    ; RTS: always 4E74
    ; JSR: bits 11-6 always 111010
    ; MOVEM: 
    ; LEA: bits 8-6 always 111
    
    ; because NOP and RTS are constant, check for them first
    CMP.W       #$4E71,D4
    BEQ         sub_nop
    CMP.W       #$4E74,D4
    BEQ         sub_rts
    
    ; JSR has 6 constant bits so it's easy to check
    isoBitsM    D4,#11,#6
    MOVE.B      D0,D1
    CMP.B       #%111010,D0
    BEQ         sub_jsr
    
    ; LEA and CHK are wildcards because their 11-8's aren't constant
    ; since we already have bits 11-6 in D0 we don't need to call isoBitsM again
    ANDI.B      #%111,D0
    CMP.B       #%110,D0
    BEQ         invalidOpcode       ; CHK 8-6 is 110 or 6
    BGT         sub_lea             ; LEA is only 0100 opcode with 8-6 > 110 (111)
    

    ; now check for MOVEM
    isoBitsM    D4,#11,#7
    ; null bit 10 since it's not constant for MOVEM
    ANDI.B      #%10111,D0
    CMP.B       #%10001,D0
    BEQ         sub_movem
    
    ; check NOT
    ; we saved bits 11-6 into D1 earlier so we can check directly
    EORI.B      #%100111,D1
    CMP.B       #%111100,D1
;``` ble might make NOT read as invalid
    BLE         invalidOpcode
    ; NOT bits 11-6 XOR'd by 100111 is largest value within 0100 section
    ; possible values for NOT: 111111, 111110, 111101
    ; so by this point, any instruction less than this is invalid
    
    ; since sub_not is next there's no need to branch

; Instruction-specific subroutines
sub_not
    PRINT       <'NOT'>,ENDL
	MOVEQ       #8,D5
    setFlagS    #$19D
    RTS
sub_nop
	PRINT       <'NOP'>,ENDL
	; return early
	MOVEA       A2,SP
	RTS
sub_rts
    PRINT       <'RTS'>,ENDL
    ; return early
	MOVEA       A2,SP
	RTS
sub_jsr
    PRINT       <'JSR'>
	MOVEQ       #9,D5
	setFlagS    #$184
    RTS    
sub_movem
    PRINT       <'MOVEM'>
	MOVEQ       #2,D5
	setFlagS    #$18C
	setFlagD    #$194
    RTS
sub_lea
    PRINT       <'LEA'>
	MOVEQ       #7,D5
	setFlagS    #$184
    RTS




************************************************************
**               Branch (BRA, BEQ, BGT, BLE)              **
************************************************************
branchIdentify
    ; set the instruction type
	MOVEQ       #10,D5
	
	; load branch table addr and jump
	isoBitsM    D4,#11,#8
	LEA         branchJmpTable,A0	
	BRA			calcJmpOffset

; 0110
branchJmpTable
	JMP			sub_bra
	
	JMP			invalidOpcode       * BSR not required
	NOP
	JMP			invalidOpcode       * BHI not required
	NOP
	JMP			invalidOpcode       * BLS not required
	NOP
	JMP			invalidOpcode       * BCC not required
	NOP
	JMP			invalidOpcode       * BCS not required
	NOP
	JMP			invalidOpcode       * BNE not required
	NOP	
	JMP			sub_beq
	
	JMP			invalidOpcode       * BVC not required
	NOP
	JMP			invalidOpcode       * BVS not required
	NOP
	JMP			invalidOpcode       * BPL not required
	NOP
	JMP			invalidOpcode       * BMI not required
	NOP
	JMP			invalidOpcode       * BGE not required
	NOP
	JMP			invalidOpcode       * BLT not required
	NOP	
	JMP			sub_bgt
	
	JMP			sub_ble

sub_bra
    PRINT       <'BRA'>
    RTS
sub_beq
    PRINT       <'BEQ'>
    RTS
sub_bgt
    PRINT       <'BGT'>
    RTS
sub_ble
    PRINT       <'BLE'>
    RTS

************************************************************
**                     DIVU instruction                   **
************************************************************
code1000   
	; DIVU is the only opcode we care about here 
	; DIVU: bits 8-6 are always 011
	; no other 1000 opcode can have 8-6 as 011 so this is the only check we need
	isoBitsM    D4,#8,#6
	CMP.W       #%011,D0
	BNE         invalidOpcode
    PRINT       <'DIVU'>
	MOVEQ       #6,D5
	setFlagS    #$99D
    RTS


************************************************************
**                      SUB instruction                   **
************************************************************
subIdentify 
    ; since SUB is the only valid opcode here, just compare.
    ; if bits 7-6 are 11, opcode is SUBA
    ; if dest is a data reg, the opcode is sub
    ; otherwise, invalid opcode
    ; SUBI has different 15-12 bits so we don't worry about it  
    
    BSR         addSubHelper
    PRINT       <'SUB'>
    RTS
    
    
************************************************************
**                         MULS/AND                       **
************************************************************
code1100
    ; TODO: optimize this
    
	; ABCD: bits 8-4 are always 10000
	; EXG: bits 8-4 are always 1__00
	isoBitsM    D4,#8,#4
	ANDI.B      #%10011,D0
	CMP.B       #%10000,D0
	; this check and branch takes care of ABCD and EXG
	; TODO: test for false positives here
	BEQ         invalidOpcode
		
	; MULS: bit 8 is always 1 vs MULU where it's always 0
	isoBitsM    D4,#8,#6
	CMP.B       #%011,D0
	BEQ         invalidOpcode
;```
    BGT         sub_muls
*	CMP.B       #%111,D0
*	BEQ         sub_muls
	; ANDI has different 15-12 bits than AND
	; AND has every bit after 12 non-constant
	; so AND is determined by ruling out other opcodes
	
sub_and
    PRINT       <'AND'>
	MOVEQ       #3,D5
	setFlagS    #$19D
    RTS

sub_muls
    PRINT       <'MULS'>
	MOVEQ       #6,D5
	setFlagS    #$99D
    RTS

************************************************************
**                      ADD instruction                   **
************************************************************
addIdentify 
    ; same format as SUB apart from bits 15-12
    BSR         addSubHelper
    PRINT       <'ADD'>
    RTS

; helper function for sub and add to reduce duplicate code
; branches to invalidOpcode for ADDX/SUBX and ADDA/SUBA
; returns back otherwise
addSubHelper
*    The following should work but is probably inefficient    
    ; ADDA/SUBA check
    isoBitsM    D4,#7,#6
    CMP.B       #%11,D0
    BEQ         invalidOpcode
    
    ; ADDX/SUBX check
    ; trying out a bitmask of 304 - 0x130 (1 0011 0000), checking if result == 256 - 0x100
    MOVE.W      D4,D0
    ANDI.W      #304,D0
    CMP.W       #256,D0
    BEQ         invalidOpcode
    ; if we got here, the opcode is a valid sub/add
	MOVEQ       #3,D5
    setFlagS    #$19D
    RTS

************************************************************
**             bitshift instructions (ASd/LSd)            **
************************************************************
shiftIdentify  
	; there are two variants of ASd and LSd
	; check bits 7-6 to determine which kind
	; bit 8 always tells the direction (ASR vs ASL)
    BSR     	getOpcodeSize
    LEA         shiftJmpTable,A0  
    CMP.B       #%11,D0
    BNE         typeTwo
    setFlagS    #$19C
typeOne
    ; for type one, we need to check bits 10-9
    isoBitsM    D4,#10,#9
	MOVEQ       #4,D5
    BRA         calcJmpOffset
typeTwo
    ; type two checks bits 4-3
    isoBitsM    D4,#4,#3
	MOVEQ       #5,D5
    BRA         calcJmpOffset
	
shiftJmpTable
    JMP			sub_asd ; for ASR/ASL
    
    JMP			sub_lsd ; for LSR/LSL
    
	JMP			invalidOpcode       * ROXd * not required
	NOP
	JMP			invalidOpcode		* ROd * not required
	
sub_asd
    PRINT       <'AS'>
    BRA         printShiftDirection
    
sub_lsd
    PRINT       <'LS'>
    BRA         printShiftDirection

    
printShiftDirection
    ; first check the direction bit
    MOVE        D4,D0
    ANDI.L      #256,D0
    ; if result is 0, it's right
    BEQ         shiftR
    PRINTC      <'L'>
    RTS
shiftR
    PRINTC      <'R'>
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
