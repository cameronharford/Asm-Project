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
    MOVE.L  #$2,D2
    
    CMP.B   #1,D0
    BHI     calcDispAddr_end
    BNE     calcDispAddr_w_ext
    ; if we got here, we have a long extension
    BSR     readFromFile
    ADDI.W  #2,D2
    ; shift left 16 bits
    SWAP    D3
calcDispAddr_w_ext
    BSR     readFromFile
    ADDI.W  #2,D2
calcDispAddr_end
; TODO: finish
    EXT.L   D3
    MOVEA.L A6,A1       ; Copy address pointer
    SUBA.L  D2,A1       ; Shift backward by the extension amount we read
    
    ADDA.L  #$2,A1      ; Increment address by 2 bytes to account for PC
    
    ADDA.L  D3,A1       ; Add displacement amount to address
    RTS    









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
