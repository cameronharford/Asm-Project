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
; prints a single character from a single arg
    MOVEM.L D0-D1,-(SP)
    MOVE.B  #\1,D1
    MOVE.B  #6,D0
    TRAP    #15
    MOVEM.L (SP)+,D0-D1
    ENDM

PRINTT   MACRO
; macro for printing a tab character
    BSR     printTab
    ENDM
    
printTab
    PRINTC  <9>
    RTS

PRINTS      MACRO
; macro for printing spaces
; because PRINTT always prints 4 spaces, not aligning
    IFC '\1','1'
        BSR     spaceOne
    ENDC
    IFC '\1','2'
        BSR     spaceTwo
    ENDC
    IFC '\1','3'
        BSR     spaceThree
    ENDC
    IFC '\1','4'
        BSR     spaceFour
    ENDC
    IFC '\1','5'
        BSR     spaceOne
        BSR     spaceFour
    ENDC
    IFC '\1','6'
        BSR     spaceTwo
        BSR     spaceFour
    ENDC
    IFC '\1','7'
        BSR     spaceThree
        BSR     spaceFour
    ENDC
    IFC '\1','8'
        BSR     spaceFour
        BSR     spaceFour
    ENDC
    ENDM

; these are so the program doesn't generate several copies of space char strings
; since macros are copy & paste, space char strings would be littered everywhere
spaceOne
    PRINTC  <' '>
    RTS
spaceTwo
    PRINT   <'  '>
    RTS
spaceThree
    PRINT   <'   '>
    RTS
spaceFour
    PRINT   <'    '>
    RTS

HEXBUFFER       DC.B    0,0,0,0,0,0,0,0,0,0 ; 9 bytes: 8 for long addr, 1 for null term

hexPrinter
    LEA     HEXBUFFER,A1
    CLR.L   (A1)            ; clear the buffer so there's no random data
    CLR.L   4(A1)
    SUB     #1,D3           ; fix num of chars for the loop
hexLoopStart
    MOVE.L  D6,D1
    MOVE.L  D3,D2
    MULS    #4,D2
    LSR.L   D2,D1
hexNum 
    AND.L   #$F,D1          ;extract lowest nibble
    CMP.B   #9,D1           ;find out if its 0-9 or a-f
    BGT     hexLetter
    ADD.B   #'0',D1         ;convert to ascii
    MOVE.B  D1,(A1)+        ;save char to string buffer
    JMP     hexTail
hexLetter
    ADD.B   #55,D1          ;'A' - 10
    MOVE.B  D1,(A1)+        ;save char to string buffer
hexTail
    SUB.B   #1,D3
    BGE     hexLoopStart
    ; print string
    LEA     HEXBUFFER,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

PRINTH  MACRO
    MOVE.L  \1,D6           ;value to print
    MOVE.L  \2,D3           ;amount of chars to print    
    IFC     \2,#4
        AND.L   #$FFFF,D6
    ENDC
    BSR     hexPrinter
    ENDM













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
