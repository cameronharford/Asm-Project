; this is a helper method I made to simplify the jump table address calculation
calcJmpOffset
    ; this method assumes A0 points to a jump table and D0 contains some number of bits of an instruction   
    ; each jmp table entry is 6 bytes (2 for word opcode, 4 for jump address)
    MULU        #6,D0       *Form offset     
    JMP         0(A0,D0)   *Jump indirect with index



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
