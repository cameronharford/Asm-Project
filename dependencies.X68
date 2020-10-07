	    INCLUDE     "print.X68"
        INCLUDE		"isolateBits.X68"
	    INCLUDE		"calcJmpOffset.X68"
	    
; I've marked possible error locations with "```"
* misc possible errors:
* printing out address of instruction + 2 by accident
*   -this would be caused by readFromFile incrementing by 2
*    and the printer not accounting for this
* random function calls
*   -caused by mistakes in a jump table structure
*   -may also be caused by my optimized conditional branches

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


readFromFile
; reads a word (2 bytes) from the test file in memory
; A6 points to the current instruction in the test file
    MOVE.W      (A6)+,D3
    RTS
    

sModeFlag       DC.W    0
dModeFlag       DC.W    0

setFlagS        MACRO
    MOVE.W      \1,(sModeFlag)
    ENDM
setFlagD        MACRO
    MOVE.W      \1,(dModeFlag)
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
* 5: Address w/ Displacement (not required)                  *
* 6: Address w/ Index (not required)                         *
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
* MOVE:     %0  0  0  1  1  0  0  1  1  1  0  1 = $19D       *
* MOVEM:    %0  0  0  1  1  0  0  1  0  1  0  0 = $194       *
* ADD:      dest is always data reg                          *
* SUB:      same as add                                      *
* AND:      same as add                                      *
* MULS:     same as add                                      *
* DIVU:     same as add                                      *
* LEA:      dest is always address reg                       *
* NOT:      N/A                                              *
* LSd:      N/A                                              *
* ASd:      N/A                                              *
* JSR:      dest is always (A7)/(SP) (mode 010, An 111)      *
*                                                            *
* Src Mode:  11 10 9  8  7  6  5  4  3  2  1  0              *
* MOVE:     %1  0  0  1  1  0  0  1  1  1  1  1 = $99F       *
* MOVEM:    %0  0  0  1  1  0  0  0  1  1  0  0 = $18C       *
* ADD:      %0  0  0  1  1  0  0  1  1  1  0  1 = $19D       *
* ADD alt:  %0  0  0  1  1  0  0  1  1  1  0  0 = $19C       *
* SUB:      %0  0  0  1  1  0  0  1  1  1  0  1 = $19D       *
* SUB alt:  %0  0  0  1  1  0  0  1  1  1  0  0 = $19C       *
* AND:      %0  0  0  1  1  0  0  1  1  1  0  1 = $19D       *
* AND alt:  %0  0  0  1  1  0  0  1  1  1  0  0 = $19C       *
* MULS:     %1  0  0  1  1  0  0  1  1  1  0  1 = $99D       *
* DIVU:     %1  0  0  1  1  0  0  1  1  1  0  1 = $99D       *
* LEA:      %0  0  0  1  1  0  0  0  0  1  0  0 = $184       *
* NOT:      %0  0  0  1  1  0  0  1  1  1  0  1 = $19D       *
* LSd:      %0  0  0  1  1  0  0  1  1  1  0  0 = $19C       *
* ASd:      %0  0  0  1  1  0  0  1  1  1  0  0 = $19C       *
* JSR:      %0  0  0  1  1  0  0  0  0  1  0  0 = $184       *
*                                                            *
*                                                            *
* Note: we don't have a special case for instructions that   *
* have no args here. These would be NOP and RTS, and are     *
* handled in the identityJmpTable method because it's easier *
* and faster than checking every time here.                  *
**************************************************************


checkMode
; D5 contains the mode we must check
; D3 contains the arg value (Xn)
; A0 contains the address of either S_MODE_FLAGS or D_MOVE_FLAGS
    CMP.B       #%111,D5
    BNE         checkMode_2
    ADD         D3,D5
    ; I add arg value to mode here because 111 has several cases;
    ; the flag variable has those cases following consecutively after mode
    ; ie: 7-11
checkMode_2
    MOVE.W      #1,D2
    LSL.W       D5,D2
    AND.W       D2,(A1)
    BEQ         badArg
    RTS


************************************************************
**         instruction reference pointers/offsets         **
************************************************************
getOpcodeSize
; for some opcodes, like ASd, it's legal
    ; returns bits 7-6 of an opcode, which is usually size
    ; possible returns: 00 - .B
    ;                   01 - .W
    ;                   10 - .L
    ;                   11 - special case
    MOVE.W      D4,D0
    ANDI.W      #$C000,D0
    BEQ         getMoveSize
    isoBitsM    D4,#7,#6
    RTS
getMoveSize
    isoBitsM    D4,#13,#12
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
* When the disassembler encounters an erroneous part of a
* program being disassembled, it prints out an error to
* represent this:
*
* bad instruction = "Error: Invalid opcode!"
* 
* bad opcode size = ".?"
*
* bad argument = "[invalid arg]"

invalidOpcode	
	PRINT       <'DATA    #$'>
	PRINTH      D4,#4
	PRINT       <''>,ENDL
	
    ; to avoid memory leaks with the stack, I need to reset
	; its ptr to what it was when findOpcodeMain was called
	MOVEA       A2,SP
	; the reason I need this is because if the opcode is
	; invalid, there's no need to read the instruction args
	; this also allows me to use RTS, since SP now points at 
	; the return address
	RTS
; <instr_name>.<instr_size>(tab)(tab)<arg2(source)>,<arg1(dest)>

badArg
    PRINT       <'[illegal arg]'>
skipArgPrint
; skips over the arg value printer since we already printed [invalid arg]
; forces RTS to use previous branch call return address by changing SP
    ADD         #4,SP
    RTS

; Macro for conveniently running a Text I/O Trap 15 function
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
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
