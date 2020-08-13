; calculates displacement from branch instruction opcodes (hex)
calcDispAddr
	; D4 holds 16-bit opcode
	; we only need the 8 LSB's for displacement
    MOVE.B  D4,D0
    NEG.B   D0
    ANDI.L  #$FF,D0             ; clear just in case
    ; If D0 is 0 here, that means the branch uses a word extension
    ; If it's 1, it uses a long extension
    ; two's complement of 0xFF is 0x01
    ; In either case, the actual displacement is in the extension
    ; This check covers both extension cases
    CMP.B   #1,D0
    BHI     calcDispAddr_end
    BNE     calcDispAddr_w_ext
    ; if we got here, we have a long extension
    BSR     readFromFile
    ; shift left 16 bits
    SWAP    D3
calcDispAddr_w_ext
    BSR     readFromFile
calcDispAddr_end
; TODO: finish
    MOVEA.L A5,A1
    ;SUBA.L  D3,A1
    ;SUB.W   D0,PROGRAM_COUNTER  ; this could be an EQU for an addr reg
    RTS    







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
