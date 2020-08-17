	    INCLUDE     "print.X68"
        INCLUDE		"isolateBits.X68"
	    INCLUDE		"calcJmpOffset.X68"
	    INCLUDE     "calcDisplacement.X68"

; I've marked possible error locations with "```"
* misc possible errors:
* printing out address of instruction + 2 by accident
*   -this would be caused by readFromFile incrementing by 2
*    and the printer not accounting for this
* random function calls
*   -caused by mistakes in a jump table structure

* Register usage key:
*   D0 = randomly used; can be freely modified
*   D1 = randomly used; can be freely modified
*   D2 = randomly used; can be freely modified
*   D3 = 
*   D4 = holds 16-bit opcode; ask before modifying
*   D5 = 
*   D6 = 
*   D7 = 
*   A0 = 
*   A1 = randomly used, typically holds a jump table address;
*        can be freely modified
*   A2 = holds a SP address used to return to IO directly;
*        ask before modifying
*   A3 = 
*   A4 = 
*   A5 = line counter; ask before modifying
*   A6 = address pointer for line; ask before modifying
*   A7 = stack pointer; DO NOT MODIFY


**************************************************************
* MISC NOTE:                                                 *
* Unlike registers, when accessing data from either memory   *
* locations or variables (which are just labels for          *
* program-allocated memory), programs use Big Endian byte    *
* order. Example:                                            *
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
**************************************************************


asciiToHexBuffer        DC.B    0,0,0,0,0,0,0,0,0
startAddress            DC.L    0
endAddress              DC.L    0
sline_address           DC.L    0
sline_count             DC.L    0


readFromFile
; reads a word (2 bytes) from the test file in memory
; A6 points to the current instruction in the test file
    MOVE.W      (A6)+,D3
    RTS
    

S_MODE_FLAGS            DS.W    1
D_MODE_FLAGS            DS.W    1

setFlagS        MACRO
    MOVE.L      \1,(S_M0DE_FLAGS)
    ENDM
setFlagD        MACRO
    MOVE.L      \1,(D_M0DE_FLAGS)
    ENDM
**************************************************************
* FLAG Documentation:                                        *
* -When we identify an instruction name, such as MOVE, a     *
* variable is set that indicates what argument modes are     *
* legal and illegal                                          *
* -Legal argument modes have their bits set to 1, while      *
* illegal modes are set to 0                                 *
* Order goes right-to-left, starting at mode 000 (Data reg). *
* -If the bit corresponding to the mode number is 0, we then *
* print "<invalid arg>"                                      *
* -Because we check if the entire word is 0 before specific  *
* bits, there are no false positives (0 & <bit> is always 0) *
*                                                            *
* Flag bits:                                                 *
* 0: Data Reg                                                *
* 1: Address Reg                                             *
* 2: Address                                                 *
* 3: Address w/ Postinc                                      *
* 4: Address w/ Predec                                       *
* 5: Address w/ Displacement                                 *
* 6: Address w/ Index                                        *
* 7: Absolute Short                                          *
* 8: Absolute Long                                           *
* 9: Program Counter w/ Displacement (not required)          *
* 10: Program Counter w/ Index       (not required)          *
* 11: Immediate                                              *
* 12: unused                                                 *
* 13: unused                                                 *
* 14: unused                                                 *
* 15: unused                                                 *
* 16: unused                                                 *
*                                                            *
* Dest Mode: 11 10 9  8  7  6  5  4  3  2  1  0              *
* MOVE:     %0  0  0  1  1  1  1  1  1  1  1  1              *done
* MOVEM:    %0  0  0  1  1  1  1  1  1  1  1  0              *
* ADD:      %0  0  0  1  1  1  1  1  1  1  1  1              *
* ADD alt:  %0  0  0  1  1  1  1  1  1  1  1  1              *
* SUB:      same as add                                      *
* SUB alt:  same as add alt                                  *
* AND:      %0  0  0  1  1  1  1  1  1  1  1  1              *
* AND alt:  %0  0  0  1  1  1  1  1  1  1  1  1              *
* MULS:     %0  0  0  1  1  1  1  1  1  1  1  1              *
* DIVU:     %0  0  0  1  1  1  1  1  1  1  1  1              *
* LEA:      never has a destination mode other than 111      *
* NOT:      %0  0  0  1  1  1  1  1  1  1  1  1              *
*   -technically, NOT doesn't have a dest mode, but since    *
*    size is variable, I use this method to check
* LSd:      %0  0  0  1  1  1  1  1  1  1  1  1              *
* ASd:      %0  0  0  1  1  1  1  1  1  1  1  1              *
* JSR:      dest is always A7/SP (mode 010, An 111)          *
*                                                            *
* Src Mode:  11 10 9  8  7  6  5  4  3  2  1  0              *
* MOVE:     %1  0  0  1  1  1  1  1  1  1  1  1              *
* MOVEM:    %1  0  0  1  1  1  1  1  1  1  1  1              *
* ADD:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* SUB:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* AND:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* MULS:     %1  0  0  1  1  1  1  1  1  1  1  1              *
* DIVU:     %1  0  0  1  1  1  1  1  1  1  1  1              *
* LEA:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* NOT:      no source used                                   *
* LSd:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* ASd:      %1  0  0  1  1  1  1  1  1  1  1  1              *
* JSR:      %0  0  0  1  1  1  1  1  0  0  0  0              *done 
*                                                            *
*                                                            *
* Note: we don't have a special case for instructions that   *
* have no args here. These would be NOP and RTS, and are     *
* handled in the identityJmpTable method because it's easier *
* and faster than checking every time here.                  *
**************************************************************


checkMode
; D3 contains the mode we must check
; D5 contains the arg value (Xn)
; A3 contains the address of either S_MODE_FLAGS or D_MOVE_FLAGS
    CMP.W       #0,(A3)
    ; if the flag is 0, the instruction doesn't use the arg
    ; note: this indicates whether an instruction that CAN use an arg doesn't do so;
    ; we aren't checking instructions that never have an arg type
    ; ex: NOT never has a source arg, so it won't call this function
    BNE         checkMode_1
    ; therefore, we can just return
    RTS
checkMode_1
    CMP.B       #%111,D3
    BNE         checkMode_2
    ADD         D5,D3
    ; I add arg value to mode here because 111 has several cases
    ; the flag variable has these cases following consecutively after mode
    ; ie: 7-11
checkMode_2
;``` I forget if args should be D3 and D3 rather than D3 and D3 - 1
    isoBitsM    (A3),D3,D3
    CMP         #0,D0
    BEQ         badArg
    RTS
*    ; if the macro doesn't work:
*    MOVE.L      #1,D0
*    MOVE.L      (A3),D2
*    LSL.L       D3,D0
*    AND.L       D0,D2
*    BEQ         badArg


************************************************************
**         instruction reference pointers/offsets         **
************************************************************
getOpcodeSize
; TODO: check for 11, which is invalid in most cases
; for some opcodes, like ASd, it's legal
    ; returns bits 7-6 of an opcode, which is usually size
    ; possible returns: 00 - .B
    ;                   01 - .W
    ;                   10 - .L
    ;                   11 - special case
    isoBitsM    D4,#7,#6
    RTS

printOpcodeSize
    PRINTC      <'.'>
    BSR         getOpcodeSize
    CMP.B       #%10,D0
    BGT         invalidSize
    BEQ         printSizeLong
    CMP.B       #%01,D0
    BEQ         printSizeWord
    PRINTC      <'B'>
    RTS
printSizeWord
    PRINTC      <'W'>
    RTS
printSizeLong
    PRINTC      <'L'>
    RTS
invalidSize
    PRINTC      <'?'>
    RTS

************************************************************
**              error print-outs for program              **
************************************************************ 
invalidOpcode	
	PRINT       <'Error: Invalid opcode! '>
	PRINT       <'(this instruction is not supported)'>,ENDL

    ; to avoid memory leaks with the stack, I need to reset
	; its ptr to what it was when findOpcodeMain was called
	MOVEA       A2,SP
	; the reason I need this is because if the opcode is
	; invalid, there's no need to read the instruction args
	; this also allows me to use RTS, since SP now points at 
	; the return address
;```
	RTS
; <instr_name>.<instr_size>(tab)(tab)<arg2(source)>,<arg1(dest)>

badArg
    PRINT       <'[illegal arg]'>
    RTS
    
    


; TODO: documentation
RUNTRAP     MACRO
    IFNE NARG-1                       ;if not 1 arguments
        IFNE NARG-2
            FAIL ERROR, RUNTRAP requires 1-2 arguments
            MEXIT
        ENDC
        MOVE.L  \2,D1
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


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
