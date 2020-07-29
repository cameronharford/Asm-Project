*    IFEQ    DEPENDENCY
*DEPENDENCY  SET     1
	    INCLUDE     "print.X68"
        INCLUDE		"isolateBits.X68"
	    INCLUDE		"calcJmpOffset.X68"
	    INCLUDE     "calcDisplacement.X68"
	

* Register usage key:
*   D0 = randomly used; can be freely modified
*   D1 = randomly used; can be freely modified
*   D2 = randomly used; can be freely modified
*   D3 = 
*   D4 = holds 16-bit opcode; ask before modifying
*   D5 = holds first extension for instruction, if it exists;
*        can be modified if necessary
*   D6 = holds other extension for instruction, if it exists;
*        can be modified if necessary
*   D7 = 
*   A0 =  
*   A1 = randomly used, typically holds a jump table address;
*        can be freely modified
*   A2 = 
*   A3 = 
*   A4 = 
*   A5 = 
*   A6 = 
*   A7 = stack pointer; DO NOT MODIFY


**************************************************************
* MISC NOTE:                                                 *
* Unlike registers, when accessing data from memory locations*
* or variables (which are just labels for program-allocated  *
* memory) programs use Big Endian byte order. Example:       *
*                                                            *
* $A000 contains the long $#12345678                         *
* D0, D1, and D2 are initially 0                             *
* after the following MOVE instructions                      *
*    MOVE.L  ($A000),D0                                      *
*    MOVE.W  ($A000),D1                                      *
*    MOVE.B  ($A000),D2                                      *
*                                                            *
* D0 = #$12345678                                            *
* D1 = #$1234     (NOT #$5678)                               *
* D2 = #$12       (NOT #$78)                                 *
*                                                            *
* while this may seem obvious when you're given a constant   *
* for a memory address like with $A000, it's important to    *
* remember this logic applies to your variables as well.     *
* When accessing the opcode extension variables INSTR_EXT_1  *
* and INSTR_EXT_2, keep this fact in mind.                   *
**************************************************************


************************************************************
**        get methods for the instruction pointers        **
************************************************************
getOpcode
    ; clear D0 just in case it has high order bits
    CLR.L           D0
    
    ; load the word and return
    LEA             INSTR_OPCODE_WORD,A1
    MOVE.W          (A1),D0
    RTS
    
getFirstExt
    LEA             INSTR_EXT_1,A1
    BRA             getExtension
    
getSecondExt
    LEA             INSTR_EXT_2,A1
    ; don't even need to branch lol

getExtension
    ; in any case we'll load D0 and return
    MOVE.L          (A1),D0
    
    ; check for null value so we don't waste instructions
    ; this should work as a zero compare
    BEQ             getExtensionReturn
    
    ; check if the extension is a word
    CMP.W           #0,4(A1)
    BNE             getExtensionReturn
    
    ; it is, so we need to account for byte order
    ; it'd be faster to do this by hand but I'm lazy
    isoBitsM        D0,#31,#16    
    ; same as D0 = D0 >> 16
    
getExtensionReturn
    RTS
    
************************************************************
**        set methods for the instruction pointers        **
************************************************************
setOpcode
    ; ensure there's nothing lurking in D0's upper word
    ANDI.L          #$FFFF,D0
    ; set the variable
    MOVE.W          D0,(INSTR_OPCODE_WORD)
    RTS
    
setFirstExt
    MOVE.L          D0,(INSTR_EXT_1)
    RTS
    
setSecondExt
    MOVE.L          D0,(INSTR_EXT_2)
    RTS
    
; TODO: Macro for these setters

************************************************************
**         variable for storing instruction bytes         **
************************************************************
INSTR_BYTES         DS.B    10  
* 10 bytes (80 bits) is the max we need I think.
* 2 for opcode, 4 for long extension, 4 for long extension.
* long extensions are in case we have 2 absolute longs such
* as for:  MOVE.L  ($10001234),($10005678)


************************************************************
**         instruction reference pointers/offsets         **
************************************************************                                
INSTR_OPCODE_WORD   EQU     INSTR_BYTES     
* used for the 16-bit opcode

INSTR_EXT_1         EQU     (INSTR_BYTES)+2 
* used if instruction has an extension.
* space is allocated for a long, but may only have a byte or
* word stored, depending on the instruction we're reading.

INSTR_EXT_2         EQU     (INSTR_BYTES)+6 
* used if instruction has a second extension
* conditions are same as first extension
* if this exists, it's always one of two things:
* 1. a destination address (long)
* 2. a displacement offset (word)


getOpcodeSize
    ; returns bits 7-6 of an opcode, which is usually size
    ; possible returns: 00 - .B
    ;                   01 - .W
    ;                   10 - .L
    ;                   11 - special case
    isoBitsM        D4,#7,#6
    RTS


************************************************************
**              error print-outs for program              **
************************************************************ 
invalidOpcode	
	PRINT           <Error: Invalid opcode! >
	PRINT           <(this instruction is not supported)>,ENDL
*	ILLEGAL
	
	; TODO: return to IO opcode reader func from here
	; to avoid memory leaks with the stack, I need to reset
	; its ptr to what it was when findOpcodeMain was called
	
	; the reason I need this is because if the opcode is
	; invalid, there's no need to read the instruction args
	RTS
*	STOP        #$DEAD
; <instr_name>.<instr_size>(tab)(tab)<arg2(source)>,<arg1(dest)>

; TODO: documentation
RUNTRAP     MACRO
        IFNE NARG-1                       ;if not 1 arguments
            FAIL ERROR, RUNTRAP requires an argument
            MEXIT
        ENDC
        MOVE.B  \1,D0
        TRAP    #15
        ENDM    

; TODO: documentation
; compares an immediate (arg 1) against data pointed to by an address (arg 2)
; arg 3: optional branch instruction name (ex: BEQ)
; arg 4: optional branch location (label name or address)
IMMCMP      MACRO
        IFLT NARG-2                       ;if not 2+ arguments
            FAIL ERROR, IMMCMP requires at least 2 arguments
            MEXIT
        ENDC
        ; macro witchcraft
        CMPI.\0 \1,(\2)
        IFEQ NARG-4
            \3  \4
        ENDC
        ENDM
        

*    ENDC




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
