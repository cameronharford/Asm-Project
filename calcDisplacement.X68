; calculates displacement from branch instruction opcodes (hex)
calcDisplacementAddress
	; D4 holds 16-bit opcode
    MOVE.B  D4,D0
    NEG.B   D0
    ANDI.L  #$FF,D0             ; clear just in case
    ; If D0 is 0 here, that means the branch goes to a lower addr
    ; This means the instruction uses an extension with the actual displacement
    
    ;SUB.W   D0,PROGRAM_COUNTER  ; this could be an EQU for an addr reg
    RTS    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
