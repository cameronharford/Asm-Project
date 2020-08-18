*-----------------------------------------------------------
* Title        :  print
* Written by   :  Chuck Kelly, edited by Cameron Harford
* Date Created :  Jan-6-2006
* Description  :  Taken from macro demo in EASy68k folder
* Macro definitions should be placed at the top of the source file.
* Dec-25-2012 by CK, Uses SIMHALT
*-----------------------------------------------------------
CODE_LOC

        OPT     MEX
CODE    EQU     0
TEXT    EQU     1

    SECTION     TEXT
    ORG         $3000
    SECTION     CODE
    ORG         CODE_LOC
*    ORG         $2000

* print the text string
* use ENDL as second argument to add return and linefeed
PRINT   MACRO
    SECTION     TEXT
MSG\@    DC.B    \1
    IFARG    2
        IFC      \2,ENDL
            DC.B    $D,$A
        ENDC
    ENDC
    DC.B    0
    SECTION     CODE
    MOVEM.L     D0/A1,-(SP)
    LEA         MSG\@,A1
    MOVE.B      #14,D0
    TRAP        #15
    MOVEM.L     (SP)+,D0/A1
    ENDM


* print the number
PRINTN    MACRO
    SECTION     CODE
    MOVEM.L     D0-D1,-(SP)
    IFNC '\1','D1'          if some register other than D1
        MOVE.L    \1,D1       put number to display in D1
    ENDC
    MOVE.B  #3,D0
    TRAP    #15             display number in D1
    MOVEM.L (SP)+,D0-D1
    ENDM

PRINTC      MACRO
    MOVE.B  #\1,D1
    MOVE.B  #6,D0
    TRAP    #15
    ENDM

PRINTT   MACRO
    PRINTC  <9>
    ENDM

hexPrinter
    MOVE.L  D6,D1
    CLR     D2
hexShiftLoop
    ADD.L   #1,D2
    CMP.B   D3,D2
    BEQ     hexNum          ;move on when we've shifted enough
    LSR.L   #4,D1           ;shift the char we want down to the lowest nibble position
    JMP     hexShiftLoop
hexNum 
    AND.L   #$F,D1          ;extract lowest nibble
    CMP.B   #9,D1           ;find out if its 0-9 or a-f
    BGT     hexLetter
    ADD.B   #'0',D1         ;convert to ascii
    MOVE.B  #6,D0
    TRAP    #15             ;print the char
    JMP     hexTail
hexLetter    
    ADD.B   #55,D1    ;'A' - 10
    MOVE.B  #6,D0
    TRAP    #15
hexTail
    SUB.B   #1,D3
    BNE     hexPrinter
    RTS

PRINTH  MACRO
    MOVE.L  \1,D6           ;value to print
    MOVE.L  \2,D3           ;amount of chars to print
    BSR     hexPrinter
    ENDM
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
