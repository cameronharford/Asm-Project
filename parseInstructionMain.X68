    INCLUDE     "findOpcodeMain.X68"

; might want to include branch displacement calc function here if I don't use it in instr identification
parseInstructionMain: 
    ; save SP so if opcode is invalid, we can return immediately
    MOVEA       SP,A2
    
    BSR         findOpcodeMain
    ; I think this should parse the instructions by common patterns/formats
    ; For ex, many opcodes use bits 0-2 for their source arg, and bits 3-5 for the arg mode/type
    ; We could use a common method to parse this section
    ; Basically, findOpcodeMain deals with identifying the name. It sets a string or flag somewhere for us
    ; Based on this flag, we know the instruction's format
    LEA         instrTypeTable,A0
    ; D5 currently contains the index for the jump table
    MOVE.B      D5,D0
    BSR         calcJmpOffset
    
    ; TODO: move this logic to each of the instruction type subs
*    ; print instr size
*    
*    ; print source arg
*    BSR         getSrcReg
*    BSR         getSrcMode
*    
*    ; comma separating args
*    PRINTC      <','>
*    
*    ; print dest arg
*    BSR         getDestReg
*    BSR         getDestMode
    
    ; endl
    PRINT       <''>,ENDL
    
	RTS



instrTypeTable
    JMP         instrTypeOne
    JMP         instrTypeTwo
    JMP         instrTypeThree
    JMP         instrTypeFour
    JMP         instrTypeFive
    JMP         instrTypeSix
    JMP         instrTypeSeven
    JMP         instrTypeEight
    JMP         instrTypeNine
    JMP         instrTypeTen
    

; instruction arg archetypes:
; Branches
; No args (NOP, RTS)
;   -handled within opcode identifier
; Source arg
;   -arg value within opcode
;   -arg value appended as word/long extension
; Source and dest args
;   -arg values within opcode
;   -arg values appended as word/long extensions
; TYPE VALUES: 
; 1 - MOVE
; 2 - MOVEM
; 3 - ADD/SUB/AND
; 4 - LSd/ASd (type 1)
; 5 - LSd/ASd (type 2)
; 6 - DIVU/MULS
; 7 - LEA
; 8 - NOT
; 9 - JSR
; 10 - BRA/BEQ/BGT/BLE


instrTypeOne
; for MOVE
    ; print size first
    BSR         printOpcodeSize
    
    ; check source mode
    ; print source arg (or invalid arg)
    ; comma
    
    ; check dest mode
    ; print dest arg
    RTS

instrTypeTwo
; for MOVEM
    ; print size first
    ; size is determined by bit 6
    ; it's either 0 (W) or 1 (L)
    
    ; get direction bit to determine the print order
    isoBitsM    D4,#10,#10
    
    
    RTS
    
instrTypeThree
; for ADD, SUB, AND
    ; get direction bit
    isoBitsM    D4,#10,#10
    MOVE        D0,D1
    
    ; adjust mode restrictions to account for direction
    ; if dir is 1, src mode can't be Dn
    EOR.W       D0,(sModeFlag)
    
    BSR         printOpcodeSize
    
    ; check direction bit to determine the print order
    CMP.B       #0,D1 
    ; if result isn't 0, we'll print dest before source
    ; otherwise, print as normal
    BEQ         destToSrc
    
    ; TODO: print source then dest args
    
    RTS
destToSrc
    ; TODO:
    ; print dest arg

    ; check source mode
    ; print source arg (or invalid arg)    
    RTS


instrTypeFour
; for LSd/ASd (type 1)
    ; type 1 doesn't have a size, so no need to print it
    
    RTS

instrTypeFive
; for LSd/ASd (type 2)
    BSR         printOpcodeSize
    ; type 2 uses an immediate between 1-8
    ; since it uses only 3 bits for the value, %000 = 8
    
    ; type 2 doesn't have a mode for src or dest, so we don't check
    ; TODO: print dest, then src arg (Dn)
    RTS

instrTypeSix
; for DIVU/MULS
    ;check source mode
    ;print source arg
    
    ;print dest data register
    RTS

instrTypeSeven
; for LEA
    ;check source mode
    ;print source arg
    
    ; print dest address register
    RTS

instrTypeEight
; for NOT
    BSR         printOpcodeSize
    ;check source mode
    
    ;print source arg
    RTS

instrTypeNine
; for JSR
    ; check source mode
    ; print source arg
    RTS
    
instrTypeTen
; for branching (BRA/BEQ/BGT/BLE)
; TODO: add sanity check for displacement addr

    RTS

getSrcMode
    isoBitsM    D4,#5,#3
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    
getDestMode
    isoBitsM    D4,#8,#6
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    
getSrcReg
    ; typically used for printing, but also used for a jmp table index
    isoBitsM    D4,#2,#0
    MOVE.B      D0,D3
    RTS
    
getDestReg
    isoBitsM    D4,#11,#9
    MOVE.B      D0,D3
    RTS
    
modeJmpTable
    ; jump table for argument mode
    JMP         printRegD ; #000    ; Data Reg, D0-D7
    
    JMP         printRegA ; #001    ; Addr Reg, A0-A7
    
    JMP         printAddress ; #010    ; Address, (A0)-(A7)
    
    JMP         printAddrPostInc ; #011    ; Address w/ Postinc, (An)+

    JMP         printAddrPreDec ; #100    ; Address w/ Predec, -(An)

    JMP         badArg  ; Address w/ Displacement, (d16,An,Xn)
    NOP
    JMP         badArg ; Address w/ Index (d8,An,Xn)
    NOP
    ; case 111
    MOVE.B      D3,D0
    LEA         modeJmpTable111,A0
    JMP         calcJmpOffset
        
    
modeJmpTable111
; do all of these modes require an extension?
; these cases do: 0,1,100
    JMP         printAbsShort ; Abs Short
    
    JMP         printAbsLong ; Abs Long
    
    JMP         badArg ; PC w/ Displacement
    NOP
    JMP         badArg ; PC w/ Index
    NOP
    JMP         printImmediate ; Immediate
    ; illegal for MOVE (dest), ADD, SUB, AND, 
    ; for MOVE, you can't use an immediate as a destination
    ; for ADD/SUB/AND, they have variants which handle immediates (ADDI/SUBI/ANDI)
    ; check if instr is ADD, SUB, AND b/c that would be illegal
    
    ; there are no valid cases for 101-111 so opcode is universally illegal
    ; 101
    NOP
    NOP
    NOP
    ; 110
    NOP
    NOP
    NOP
    ; 111
    JMP         badArg
    
printRegD
    
printRegA
    PRINTC      <'A'>
    

printAddress
; TODO
*    PRINT   <'addr'>
    PRINTC      <'('>
    BSR         printRegA
    PRINTC      <')'>
    RTS
   
printAddrPostInc
; TODO
*    PRINT   <'addr w/ postinc'>
    BSR         printAddress
    PRINTC      <'+'>
    RTS

printAddrPreDec
; TODO
*    PRINT   <'addr w/ predec'>
    PRINTC      <'-'>
    BSR         printAddress  
    RTS

printAbsShort
*    PRINT   <'absolute short'>
    PRINTC      <'$'>
    BSR         readFromFile
    BRA         printReg
    
printAbsLong
*    PRINT   <'absolute long'>
    PRINTC      <'$'>
    
    BSR         readFromFile
    ; Print Address
    BSR         printReg
    BSR         readFromFile
    ; Print Address
    BRA         printReg ;```
    
printImmediate
*    PRINT   <'immediate'>
    PRINTC      <'#'>
    
    BSR         getOpcodeSize   ; Puts binary for instruction size in D0 (00 for byte, 01 for word, 10 for long)
    BSR         readFromFile    
    ; Print value
    BSR         printReg
    
    CMP.B       #$2,D0          ; If size bits indicate long, read another word from memory
    BNE         DONE
    
    BSR         readFromFile   
    ; Print value
    BSR         printReg    
DONE
    RTS

*   Prints the contents of a register in hex (Slightly modified from function in IO)
*   For comments on what each line does, see IO's function
*   D3 - Register being printed
*   D5 - Loop index
*   D2 - shift loop index
*   D1 - Char storage

printReg
    MOVE.L      #8,D5
LOOP
    MOVE.L      D3,D1
    CLR         D2
SHIFTLOOP
    ADD.L       #1,D2
    CMP.B       D5,D2
    BEQ         NUM
    LSR.L       #4,D1
    JMP         SHIFTLOOP
NUM
    AND.L       #$F,D1
    CMP.B       #9,D1
    BGT         LETTER
    ADD.B       #'0',D1
    RUNTRAP     <#6>
    JMP         REG_TAIL
LETTER
    ADD.B       #55,D1
    RUNTRAP     <#6>
REG_TAIL
    SUB.B       #1,D5
    CMP.B       #0,D5
    BNE         LOOP
    PRINTC      <' '>
    RTS


*   Parse the bitmask for a MOVEM instruction, and print the list of registers being moved
*   D1 - Bitmask
*   D3 - Loop counter
*   D2 - Bit storage
printM
    BSR         readFromFile
    MOVE.W      D3,D1
    CLR         D3
D_LOOP
    MOVE.W      D1,D2   ; Copy mask
    LSR.W       D3,D2   ; Shift to the first non-processed bit
    ANDI.W      #1,D2   ; Isolate bit we care about
    CMPI.W      #1,D2   ; If bit=1, that register is moved
    BNE         D_TAIL  ; If bit=0, move to next bit in mask
    
    JMP         printRegD   ; Bit=1, print register
    PRINTC      <' '>
    
D_TAIL
    ADDI.W      #1,D3
    CMPI.W      #8,D3   
    BLT         D_LOOP  ; Gone through bits representing Dn, move to An
    
    PRINTC      <'/'>
    
    CLR         D3
    LSR.W       #8,D1   ; Shift mask to access address bits
A_LOOP
    MOVE.W      D1,D2   ; Copy mask
    LSR.W       D3,D2   ; Shift mask to new bit
    ANDI.W      #1,D2   ; Isolate first bit
    CMPI.W      #1,D2   ; If bit=1, register was moved
    BNE         A_TAIL  ; Bit=0, move to next bit
    
    JMP         printRegA
    PRINTC      <' '>
    
A_TAIL
    ADDI.W      #1,D3   ; Increment loop count
    CMPI.W      #8,D3   ; Check if done
    BLT         A_LOOP
    
    RTS

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
