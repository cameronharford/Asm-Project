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
    MOVE.W  #$6000,D0
    BSR     findOpcodeMain
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
