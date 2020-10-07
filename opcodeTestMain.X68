*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000

    INCLUDE     "parseInstructionMain.X68"
START:
    PRINTC  <'0'>
    PRINTC  <'1'>
    PRINTC  <'2'>
    PRINTC  <'3'>




    ; D0 should have the 16 bit opcode (may change this later)
    PRINT   <'Start of test'>,ENDL
    
    PRINTH  #$12AB,#4
    PRINT   <''>,ENDL
    PRINTH  #$82DA,#4
    PRINT   <''>,ENDL
    PRINTH  #$34,#2
    PRINT   <''>,ENDL
    PRINTH  #$4321,#8
    PRINT   <''>,ENDL
    
    
    PRINT   <' Tab test:'>
    PRINTT
    PRINTT
    PRINTC  <'0'>
    PRINTT
    PRINTC  <'C'>
    PRINT   <''>,ENDL

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

    LEA     ADDBYTES,A6
*    LEA     BRANCHBYTES,A6
loopstart
    MOVE.W  (A6),D6
    CMP.W   #$FFFF,D6
    BEQ     loopend
    CLR     D0
    MOVE.W  D6,D0
    MOVE    D6,-(SP)
    BSR     parseInstructionMain
    MOVE    (SP)+,D6
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
            DC.W    $48A7,$00FE ; MOVEM       A0-A6,-(A7)
            DC.W    $4C9F,$7F00 ; MOVEM       (A7)+,A0-A6
            DC.W    $4C9F,$00FF ; MOVEM       (A7)+,D0-D7
            DC.W    $48E5,$EEE8 ; MOVEM       D0-D2/D4-D6/A0-A2/A4,-(A5)
            DC.W    $4CA7,$7F00 ; MOVEM       -(A7),D1-D7 (illegal)

*            DC.W    $8451 ; OR
*            DC.W    $E6D9 ; ROR
            DC.W    $E2F8,$1234,$E2D9,$E2E2 ; LSR
            DC.W    $E38B ; LSL
            DC.W    $E32A,$E36A,$E3AA ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
*            DC.W    $ ; 
            DC.W    $FFFF ; END
            
            
BRANCHBYTES DC.W    $6000,$003E
            DC.W    $6100,$003C
            DC.W    $6200,$003A
            DC.W    $6300,$0038
            DC.W    $6400,$0036
            DC.W    $6500,$0034
            DC.W    $6600,$0032
            DC.W    $6700,$0030
            DC.W    $6800,$002E
            DC.W    $6900,$002C
            DC.W    $6A00,$002A
            DC.W    $6B00,$0028
            DC.W    $6C00,$0026
            DC.W    $6D00,$0024
            DC.W    $6E00,$0022
            DC.W    $6F00,$0020
            DC.W    $FFFF
            
    END    START        ; last line of source























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
