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












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
