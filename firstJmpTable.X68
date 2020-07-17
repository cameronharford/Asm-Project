	INCLUDE		"dependencies.X68"
    INCLUDE		"secondJmpTable.X68"
*    ORG         $1800
; jump table for bits 15-12 of an instruction opcode
firstJmpTable
    JMP         invalidOpcode       ; 0000 are all invalid
    JMP         moveByte
    JMP         moveLong
    JMP         moveWord
    JMP         code0100            ; NOT,NOP,RTS,JSR,MOVEM,LEA
    JMP         invalidOpcode       ; 0101 are all invalid
    JMP         branchJmpTable      ; BRA,BEQ,BGT,BLE. rest are invalid
    JMP         invalidOpcode       ; MOVEQ is invalid
    JMP         code1000            ; DIVU, rest are invalid
    JMP         subOpcodeIdentify   ; SUB, rest are invalid
    JMP         invalidOpcode       ; no opcodes have 1010    
    JMP         invalidOpcode       ; 1011 are all invalid
    JMP         code1100            ; MULS,AND good. rest are invalid
                                    ; TODO: distinguish MULS or AND in code1100
    JMP         addJmpTable
    JMP         shiftJmpTable
    JMP         invalidOpcode       ; 1111 are all invalid	
	
; these methods set A0 to their specific jump table in secondJmpTable.X68
; exceptions to this pattern are moveByte, moveLong, moveWord, and moveQ
moveByte     
	; Move Byte
	
    STOP        #$2700

moveLong  
	; Move Long     
    STOP        #$2700

moveWord  
	; Move Word     
    STOP        #$2700

code0100  
	; NOT: bits 11-8 always 0110 and bits 7-6 never 11
	; only other opcode in this section with 11-8 0110 is MOVE to SR (7-6 always 11)
    ; NOP: always 4E71    
    ; RTS: always 4E74
    ; JSR: bits 11-6 always 111010
    ; MOVEM: 
    ; LEA: bits 8-6 always 111
    
    ; LEA and CHK are wildcards because their 11-8's are variables
    ; let's check for them specifically before the other instructions
    ; I should also check for MOVEM if possible due to variable bit 10
    isolateBitsM    D4,#8,#6
    CMP.B           #6,D0
    BEQ             invalidOpcode       ; CHK 8-6 is 110 or 6
    ;BGT             sub_lea             ; LEA is only 0100 opcode with 8-6 > 110 (111)
    

    ; now check for MOVEM
    isolateBitsM    D4,#11,#7
    ; null bit 10 since it's not constant for MOVEM
    ANDI.B      #23,D0
    CMP.B       #17,D0
    ;BEQ         sub_movem
	LEA         jmpTable0100, A0
    STOP        #$2700

branchJmpTable 
	ILLEGAL		; as a test breakpoint
	MOVE.W 		D4, D0
	MOVE.B		#11, D1
	MOVE.B		#8, D2
	BSR			isolateBits
	LEA         jmpTable0110, A0  
	
	; BSR so we can return here to calc displacement
	BSR			calcJmpOffset
	
	; TODO: displacement shit. Might need to generate a label (which would be aids)
	; complete this code later
    STOP        #$2700

code1000   
	; DIVU is the only opcode we care about here 
	; DIVU: bits 8-6 are always 011
	isolateBitsM    D4,#8,#6
	CMP.W           #3,D0
	BNE             invalidOpcode
	; we know the input is DIVU, so do something now....
  
    STOP        #$2700

subOpcodeIdentify 
    ; if bits 7-6 are 11, opcode is SUBA
	; table for SUB
    ; since SUB is the only valid opcode here, just compare.
    ; if dest is a data reg, the opcode is sub
    ; otherwise, invalid opcode
    ; SUBI has different 15-12 bits so we don't worry about it

    ; AND with a bitmask of 0x1F0 to check for both SUBA and SUBX
    MOVE.W  D4,D0
    ANDI.W  #$1F0,D0
    
    ; if result is 0xC0, it's SUBA
    ; if result is 0x140, it's SUBX
    ; anything else is SUB
    CMP.W   #$C0,D0
    BEQ     invalidOpcode
    CMP.W   #$140,D0
    BEQ     invalidOpcode

* The following should work but is inefficient    
*    ; SUBA check
*    isolateBitsM    D4,#7,#6
*    CMP.B           #3,D0
*    BEQ             invalidOpcode
*    
*    ; TODO: distinguish between SUB & SUBX  
*    ; trying out a bitmask of 304 - 0x130 (1 0011 0000), checking if result == 256 - 0x100
*    MOVE.W          D4,D0
*    ANDI.W          #304,D0
*    CMP.W           #256,D0
*    BEQ             invalidOpcode   
 
	; do stuff
   
    STOP        #$2700

code1011
	; 
    BRA        code1011

code1100
	; ABCD: bits 8-4 are always 10000
	; MULS: bit 8 is always 1 vs MULU where it's always 0
	; ANDI has different 15-12 bits than AND
    STOP        #$2700

addJmpTable  
	;     
    STOP        #$2700

shiftJmpTable  
	; table for 
    STOP        #$2700
	

*	END         firstJmpTable




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
