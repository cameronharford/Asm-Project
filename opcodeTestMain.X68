*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
DEPENDENCY  SET 0
    INCLUDE     "parseInstructionMain.X68"
START:
    ; D0 should have the 16 bit opcode (may change this later)
    PRINT   <'"SPACE TEST            "'>
    PRINT   <'Start of test'>,ENDL
    
*    MOVE.W  #$4E71,D0 * NOP, working
*    MOVE.W  #$6000,D0 * BRA, working
*    MOVE.W  #$9378,D0 * SUB, working
*    MOVE.W  #$4E74,D0 * RTS, working
*    MOVE.W  #$4EB9,D0 * JSR, working
*    MOVE.W  #$C491,D0 * AND, working
*    MOVE.W  #$C701,D0 * ABCD, working
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
*    BSR     parseInstructionMain
    
*    MOVE.W  #$4E71,D0 * NOP, working
*    BSR     parseInstructionMain

*    MOVE.W  #$D202,D0 * ADD.B       D2,D1
*    BSR     parseInstructionMain
    
    LEA     ADDBYTES,A4
loopstart
    MOVE.W  (A4)+,D6
    CMP.W   #$FFFF,D6
    BEQ     loopend
    CLR     D0
    MOVE.W  D6,D0
    MOVEM   A4/D6,-(SP)
    BSR     parseInstructionMain
    MOVEM   (SP)+,A4/D6
    BRA     loopstart
loopend
    PRINT   <'end of test'>,ENDL
    SIMHALT             ; halt simulator

* Put variables and constants here
ADDBYTES    DC.W    $D202 ; ADD.B
            DC.W    $4E71 ; NOP
*            DC.W    $92C1 ; ADDA
*            DC.W    $B240 ; CMP
*            DC.W    $4440 ; NEG
*            DC.W    $3652 ; MOVEA
            DC.W    $48A7 ; MOVEM
*            DC.W    $8451 ; OR
*            DC.W    $E6D9 ; ROR
            DC.W    $E2D9 ; LSR
            DC.W    $E32A ; LSL
*            DC.W    $ ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
            DC.W    $FFFF ; END
    END    START        ; last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
