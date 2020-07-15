	INCLUDE		"dependencies.X68"
    INCLUDE		"secondJmpTable.X68"
*    ORG         $1800
; jump table for bits 15-12 of an instruction opcode
firstJmpTable
    JMP         code0000
    JMP         moveByte
    JMP         moveLong
    JMP         moveWord
    JMP         code0100
    JMP         code0101
    JMP         branchJmpTable
    JMP         moveQ
    JMP         code1000
    JMP         subtractJmpTable
    JMP         code1010
    JMP         code1011
    JMP         code1100
    JMP         addJmpTable
    JMP         shiftJmpTable
    JMP         code1111
	
	
; these methods set A0 to their specific jump table in secondJmpTable.X68
; exceptions to this pattern are moveByte, moveLong, moveWord, and moveQ
code0000	
	; table for ORI to CCR,
	;
	LEA         jmpTable0000, A0
	; shave down bits then jump to jmpTable0000
    STOP        #$2700

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
	;     
	LEA         jmpTable0100, A0
    STOP        #$2700

code0101   
	;    
	LEA         jmpTable0101, A0  
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
	
	; displacement shit. Might need to generate a label (which would be aids)
	; complete this code later
    STOP        #$2700

moveQ      
	; 
    STOP        #$2700

code1000   
	;  
	LEA         jmpTable1000, A0  
    STOP        #$2700

subtractJmpTable 
	; table for SUB/SUBX    
	LEA         jmpTable1001, A0   
    STOP        #$2700
   
code1010  
	;      
    STOP        #$2700

code1011
	; 
    BRA        code1011

code1100
	;
    STOP        #$2700

addJmpTable  
	;     
    STOP        #$2700

shiftJmpTable  
	; table for 
    STOP        #$2700

code1111    
	; Special/Reserved   
    STOP        #$2700
	
	
subroutine
	; copy instruction code from D4 to D0 (so we can isolate bits again)
	MOVE		D4, D0
	MOVE.B      #11, D1
	MOVE.B      #3, D2
	BRA			isolateBits
	
*	END         firstJmpTable


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
