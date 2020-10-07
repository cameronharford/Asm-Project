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
    MOVE.L      D5,D0
    SUB         #1,D0
    BSR         calcJmpOffset
        
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
    PRINTS      <2>    
    ; check source mode
    BSR         getSrcReg
    BSR         getSrcMode
    ; print source arg (or invalid arg)
    ; comma
    PRINTC      <','>
    
    ; check dest mode
    BSR         getDestReg
    BSR         getDestMode
    ; print dest arg
    RTS

instrTypeTwo
; for MOVEM
    PRINTC      <'.'>
    ; print size first
    ; size is determined by bit 6
    ; it's either 0 (W) or 1 (L)
    MOVE.W      D4,D0
    AND.W       #64,D0
    BEQ         movemWordSize
    PRINTC      <'L'>
    BRA         instrTypeTwo_2
movemWordSize
    PRINTC      <'W'>
instrTypeTwo_2
    PRINTS      <1>
    ; get direction bit to determine the print order
    MOVE.W      D4,D1
    AND.W       #$400,D1 
    BEQ         regMem  
    ; Direction 1 -> memory to register
    setFlagS    #$18C
    BSR         getSrcReg
    BSR         getSrcMode
    PRINTC      <','>
    BRA         printRegList
    
regMem
    ; Direction 0 -> register to memory
    setFlagS    #$194
    BSR         printRegList 
    PRINTC      <','>
    BSR         getSrcReg
    BRA         getSrcMode
    
instrTypeThree
; for ADD, SUB, AND
*{
    BSR         printOpcodeSize
    PRINTS      <3>
    ; check direction bit to determine the print order
    MOVE.L      D4,D1
    AND.L       #256,D1
    ; if result isn't 0, we'll print dest before source
    ; we also must adjust mode restrictions to account for this direction
    ; if result isn't 0, src mode can't be Dn
    BNE         destToSrc
    ; otherwise, print as normal
    setFlagS    #$19F
    
    BSR         getSrcReg
    BSR         getSrcMode
    
    PRINTC      <','>
    
    BSR         getDestReg
    BSR         printRegD   ; Print register
    
    RTS
destToSrc
    setFlagS    #$19C
    
    ; print dest arg
    BSR         getDestReg
    BSR         printRegD   ; Print register
    ; check source mode
    ; print source arg (or invalid arg)    
    PRINTC      <','>
    
    BSR         getSrcReg
    BSR         getSrcMode
    RTS
*}

instrTypeFour
; for LSd/ASd (type 1, single arg)
    PRINTS      <5>
    ; type 1 doesn't have a size, so no need to print it
    setFlagS    #$99F
    BSR         getSrcReg
    BSR         getSrcMode
    
    RTS

instrTypeFive
; for LSd/ASd (type 2)
    BSR         printOpcodeSize
    PRINTS      <3>
    ; type 2 uses an immediate or data reg between 1-8
    ; bit #5 determines the arg type for rotation field
    isoBitsM    D4,#5,#5
    BNE         regShift    ; Shift amount is in data register, stored in instruction
    
immShift
; TODO: optimize Jerahmy's shitty code
    PRINTC      <'#'>
    isoBitsM    D4,#11,#9
    MOVE.B      D0,D1
    BNE         immLessThanEight
    ; if the value is 0, it's actually 8
    ; therefore, we must offset this
    ADDI.B      #8,D1
immLessThanEight
    ADDI.B      #$30,D1     ; Convert to ASCII equivalent
    RUNTRAP     <#6>
    BRA         shiftDest
regShift
    BSR         getDestReg  ; Isolate register value
    BSR         printRegD   ; Print register
shiftDest
    PRINTC      <','>
    BSR         getSrcReg   ; Isolate register being shifted
    BSR         printRegD   ; Print register
    
    RTS

instrTypeSix
; for DIVU/MULS
    PRINTS      <4>
    ;check source mode
    BSR         getSrcReg
    BSR         getSrcMode
    PRINTC      <','>
    
    ;print dest data register
    BSR         getDestReg
    BSR         printRegD
    RTS

instrTypeSeven
; for LEA
    PRINTS      <5>
    ;check source mode
    BSR         getSrcReg
    BSR         getSrcMode
    
    PRINTC      <','>
    
    ; print dest address register
    BSR         getDestReg
    BSR         printRegA
    RTS

instrTypeEight
; for NOT
    BSR         printOpcodeSize
    PRINTS      <3>
    BSR         getSrcReg
    BSR         getSrcMode
    RTS

instrTypeNine
; for JSR
    PRINTS      <5>
    BSR         getSrcReg
    BSR         getSrcMode
    RTS
    
instrTypeTen
; for branching (BRA/BEQ/BGT/BLE)
; TODO: add sanity check for displacement addr
    PRINTS      <5>
    BRA         printDisp

getSrcMode
    isoBitsM    D4,#5,#3
    ; check for illegal modes
    LEA         sModeFlag,A1
    MOVE.L      D0,D5
    BSR         checkMode
    
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    
getDestMode
    isoBitsM    D4,#8,#6
    ; check for illegal modes
    LEA         dModeFlag,A1
    MOVE.L      D0,D5
    BSR         checkMode
    
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    
getSrcReg
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

    ADD         #2,A6 ; Address w/ Displacement, (d16,An)
    RTS
    NOP

    ADD         #2,A6 ; Address w/ Index (d8,An,Xn)
    RTS
    NOP

    ; case 111
    MOVE.B      D3,D0
    LEA         modeJmpTableExtra,A0
    JMP         calcJmpOffset


modeJmpTableExtra
; since these modes use the arg value as well, they always have extensions
    JMP         printAbsShort ; Abs Short
    
    JMP         printAbsLong ; Abs Long
    
    ADD         #2,A6 ; PC w/ Displacement
    RTS
    NOP
    
    ADD         #2,A6 ; PC w/ Index
    RTS
    NOP
    
    JMP         printImmediate ; Immediate
    ; illegal for MOVE (dest), ADD, SUB, AND, 
    ; for MOVE, you can't use an immediate as a destination
    ; for ADD/SUB/AND, they have variants which handle immediates (ADDI/SUBI/ANDI)
    ; check if instr is ADD, SUB, AND b/c that would be illegal
    
    ; there are no valid cases for 101-111 so opcode is universally illegal
    ; 101
    RTS
    NOP
    NOP
    ; 110
    RTS
    NOP
    NOP
    ; 111
    RTS
*    JMP         badArg
    
printRegD
    PRINTC      <'D'>
    BRA         printReg
printRegA
    PRINTC      <'A'>
printReg
    MOVE.B      D3,D1
    ADDI.B      #$30,D1     ; Convert to ASCII equivalent
    RUNTRAP     <#6>
    RTS

printAddress
    PRINTC      <'('>
    BSR         printRegA
    PRINTC      <')'>
    RTS
   
printAddrPostInc
    BSR         printAddress
    PRINTC      <'+'>
    RTS

printAddrPreDec
    PRINTC      <'-'>
    BSR         printAddress  
    RTS

printAbsShort
    PRINTC      <'$'>
    BSR         readFromFile
    PRINTH      D3,#4
    RTS
    
; TODO: simplify into two calls to Abs Short
printAbsLong
    PRINTC      <'$'>
    BSR         readFromFile
    ; Print Address
    PRINTH      D3,#4
    BSR         readFromFile
    ; Print Address
    PRINTH      D3,#4
    RTS
    
printImmediate
    PRINT       <'#$'>
    
    BSR         readFromFile    
    ; Print value
    PRINTH      D3,#4
    
    BSR         getOpcodeSize   ; Puts binary for instruction size in D0 (00 for byte, 01 for word, 10 for long)
    CMP.B       #$2,D0          ; If size bits indicate long, read another word from memory
    BNE         DONE
    
    BSR         readFromFile   
    ; Print value
    PRINTH      D3,#4    
DONE
    RTS


reverseBits
; reverses every bit in a word (D3)
; used for MOVEM's register lists to streamline printing
    ; we want the result in D3, so save D3 to D1
    MOVE.W      D3,D1
    CLR.L       D3
    MOVE.B      #16,D0
reverseBitsLoop
    LSL.W       #1,D3
    MOVE.W      D1,D2
    AND.W       #1,D2
    OR.W        D2,D3
    LSR.W       #1,D1
    SUB         #1,D0
    BNE         reverseBitsLoop
    RTS


printRegList
    MOVEM.L     D1-D3,-(SP)    
    ; load the register list
    BSR         readFromFile
    ; check dest mode so we know the list format
    ; if mode is predec, list is normal order
    ; if mode is anything else, we need to reverse the list first
    MOVE.W      D4,D1
    AND.W       #%011000,D1
    BNE         printRegList_init
    ; the only mode that equals 0 is predec, because 100XX & 011000 = 0
    ; every other mode evaluates to !0
    BSR         reverseBits
printRegList_init
    ; set counter
    CLR         D0
    ; set the foundReg to -1 (we use D1 for this)
    MOVE.B      #-1,D1
    ; set forwardSlash = false
    CLR.L       D5
mLoopStart    
    MOVE.W      D3,D2
    LSR.W       #1,D3
    AND.W       #1,D2
    BEQ         bitIsZero       
bitIsOne
    CMP.B       #-1,D1
    BNE         mLoopEnd
    MOVE.B      D0,D1
	BRA         mLoopEnd
bitIsZero
    CMP.B       #-1,D1
    BEQ         mLoopEnd
    CMP.B       #0,D5
    BEQ         noForwardSlash_2
    PRINTC      <'/'>
noForwardSlash_2
    ; set forwardSlash = true (so we print it next time)
    MOVE.B      #1,D5
    ; if this was a series of registers, D0 - 1 is greater than D1
	; we also need to print the end of the series
	; if it wasn't a series, D0 - 1 is equal to D1 (meaning D1 is the last register used by the register list)
	; we don't need to print the series end, since we already printed the 1 register
    MOVE.B      D0,D2
    SUB.B       #1,D2
    CMP.B       D1,D2
    BLE         printLastReg
    BSR         printMovemRegister
    ; print the dash to separate the series start and end
    PRINTC      <'-'>
    ; print the series end
    MOVE.B      D2,D1
printLastReg
    BSR         printMovemRegister
    ; reset last_reg to -1
    MOVE.B      #-1,D1
mLoopEnd
    ADD.B       #1,D0
    CMP.B       #16,D0
    BLE         mLoopStart    
    MOVEM.L     (SP)+,D1-D3
    RTS    
    

printMovemRegister
    CMP.B       #7,D1
    BGT         printMovemAn
    ; Data reg
    PRINTC      <'D'>
    JMP         printMovemRegVal
printMovemAn
    ; Addr reg
    PRINTC      <'A'>
    SUB.B       #8,D1
printMovemRegVal
    PRINTN      D1
    MOVE.B      #1,D5
    RTS


*   Print the address destination for a branch/jump instruction
printDisp
    BSR         calcDispAddr
    PRINTC      <'$'>
    PRINTH      A1,#8
    RTS

; calculates displacement from branch instruction opcodes (hex)
calcDispAddr
	; D4 holds 16-bit opcode
	; we only need the 8 LSB's for displacement
    MOVE.L  D4,D0
    NEG.L   D0
    ANDI.L  #$FF,D0             ; clear
    ; If D0 is 0 here, that means the branch uses a word extension
    ; If it's 1, it uses a long extension
    ; two's complement of 0xFF is 0x01
    ; In either case, the actual displacement is in the extension
    ; This check covers both extension cases
    MOVE.L  #$2,D2
    
    CMP.B   #1,D0
    BHI     calcDispAddr_1
    BNE     calcDispAddr_w_ext
    ; if we got here, we have a long extension
    BSR     readFromFile
    ADDI.W  #2,D2
    ; shift left 16 bits
    SWAP    D3
calcDispAddr_w_ext
    BSR     readFromFile
    ADDI.W  #2,D2
    BRA     calcDispAddr_2 
calcDispAddr_1
; TODO: finish
    NEG     D0
    EXT.W   D0
    ADD.W   D0,D3
calcDispAddr_2    
    MOVEA.L A6,A1       ; Copy address pointer
    SUBA.L  D2,A1       ; Shift backward by the extension amount we read
    
    ADDA.W  #$2,A1      ; Increment address by 2 bytes to account for PC
    
    ADDA.W  D3,A1       ; Add displacement amount to address
    RTS  
















































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
