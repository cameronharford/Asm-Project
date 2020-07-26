*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    INCLUDE     "findOpcodeMain.X68"
START:
    ; D0 should have the 16 bit opcode (may change this later)
*    MOVE.W  #$4E71,D0 * NOP, working
*    MOVE.W  #$6000,D0 * BRA, working
*    MOVE.W  #$9378,D0 * SUB, working
*    MOVE.W  #$4E74,D0 * RTS, working
*    MOVE.W  #$4EB9,D0 * JSR, working
*    MOVE.W  #$C491,D0 * AND, working
    MOVE.W  #$C701,D0 * ABCD, working
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$6000,D0 * 
*    MOVE.W  #$9BF8,D0 * SUBA, working
*    MOVE.W  #$92C1,D0 * SUBA, 
    BSR     findOpcodeMain
    PRINT   <end of test>,ENDL
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
