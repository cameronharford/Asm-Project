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
    PRINTT
    
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
    MOVE.L      D4,D0
    AND.L       #64,D0
    BEQ         movemWordSize
    PRINTC      <'L'>
    BRA         instrTypeTwo_2
movemWordSize
    PRINTC      <'W'>
instrTypeTwo_2
    ; get direction bit to determine the print order
    PRINTT
    MOVE.L      D4,D1
    AND.L       #256,D1 
    BEQ         regMem  
    ; Direction 1 -> memory to register
    setFlagS    #$18C
    BSR         getSrcReg
    BSR         getSrcMode
    PRINTC      <','>
    BRA         printM
    
regMem
    ; Direction 0 -> register to memory
    setFlagS    #$194
    BSR         printM  ; Print list of registers
    PRINTC      <','>
    BSR         getSrcReg
    BRA         getSrcMode
    
instrTypeThree
; for ADD, SUB, AND
    ; get direction bit
    MOVE.L      D4,D1
    AND.L       #256,D1
    BNE         dnToEa
    OR.W       #$19D,(sModeFlag)
    BRA         eaToDn
    ; adjust mode restrictions to account for direction
    ; if dir is 1, src mode can't be Dn
dnToEa
    OR.W       #$19C,(sModeFlag)
*    setFlagS    #$19C
eaToDn
    BSR         printOpcodeSize
    PRINTT
    
    ; check direction bit to determine the print order
    CMP.B       #0,D1 
    ; if result isn't 0, we'll print dest before source
    ; otherwise, print as normal
    BEQ         destToSrc
    
    ; TODO: print source then dest args
    BSR         getSrcReg
    BSR         getSrcMode
    
    PRINTC      <','>
    
    BSR         getDestReg
    BSR         printRegD   ; Print register
    
    RTS
destToSrc
    ; TODO:
    ; print dest arg
    BSR         getDestReg
    BSR         getDestMode
    ; check source mode
    ; print source arg (or invalid arg)    
    PRINTC      <','>
    
    BSR         getSrcReg
    BSR         getSrcMode
    RTS


instrTypeFour
; for LSd/ASd (type 1, single arg)
    PRINTT
    ; type 1 doesn't have a size, so no need to print it
    ; TODO:
    setFlagS    #$FFFF
    BSR         getSrcReg
    BSR         getSrcMode
    
    RTS

instrTypeFive
; for LSd/ASd (type 2)
    BSR         printOpcodeSize
    PRINTT
    ; type 2 uses an immediate between 1-8
    ; since it uses only 3 bits for the value, %000 = 8
    isoBitsM    D4,#5,#5
    CMPI.B      #0,D0
    BEQ         immShift    ; Shift amount is in instruction
    BNE         regShift    ; Shift amount is in data register, stored in instruction
    
immShift
    PRINTC      <'#'>
    MOVE.B      D0,D1
    ADDI.B      #$30,D1     ; Convert to ASCII equivalent
    
    MOVE.B      #6,D0       ; Print shift amount
    TRAP        #15
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
    PRINTT
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
    PRINTT
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
    PRINTT
    BSR         getSrcReg
    BSR         getSrcMode
    RTS

instrTypeNine
; for JSR
    PRINTT
    BSR         getSrcReg
    BSR         getSrcMode
    RTS
    
instrTypeTen
; for branching (BRA/BEQ/BGT/BLE)
; TODO: add sanity check for displacement addr
    PRINTT
    PRINTT
    BSR         printDisp
    
    RTS

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

    JMP         badArg  ; Address w/ Displacement, (d16,An,Xn)
    NOP
    JMP         badArg ; Address w/ Index (d8,An,Xn)
    NOP
    ; case 111
    MOVE.B      D3,D0
    LEA         modeJmpTableExtra,A0
    JMP         calcJmpOffset
        
    
modeJmpTableExtra
    JMP         printAbsShort ; Abs Short
    
    JMP         printAbsLong ; Abs Long
    RTS
    NOP
*    JMP         badArg ; PC w/ Displacement
    NOP
    RTS
    NOP
*    JMP         badArg ; PC w/ Index
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
    
    MOVE.B      #6,D0       ; Print register number
    TRAP        #15
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
    BRA         printReg
    
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
    ; we want the result in D3, so save D3 to D1
    MOVE.W      D3,D1
    CLR.L       D3
    MOVE.B      #16,D0
reverseBitsLoop
    ; end loop if WORD result of the shift is 0
    LSL.W       #1,D3
    MOVE.W      D1,D2
    AND.W       #1,D2
    OR.W        D2,D3    
    ; end loop if WORD result of the shift is 0
    LSR.W       #1,D1
    SUB         #1,D0
    BNE         reverseBitsLoop
    RTS
;idea:
; to make this modular (able to handle postinc & predec without redundant code):
; we set a reg to hold a value we iterate by (1 or -1)
; we set a reg to hold a starting bit ptr value (0 or 15)
; we set a reg to hold end bit ptr value (15 or 0)
; better yet, make the method process the list one way
;   then if the list goes in reverse order, reverse the bits

; TODO: print the forward slash in front of every enabled register except the first
; TODO: use two loops of 8, and use a Dn to store a charToPrint (either 'D' or 'A')
printRegList
    ; load the register list
    BSR         readFromFile    
    ; check direction bit so we know the list format
    ; 1 is ea to regList (postinc, so reversed list bit order)
    ; 0 is regList to ea (predec)
    MOVE.L      D4,D1
    AND.L       #256,D1
    BEQ         printRegList_1
    BSR         reverseBits
printRegList_1
    ; load counter
    *MOVE.B      #$16
    ; set the foundReg bool to 0 (we use D1 for this)
    CLR.L       D1
regListLoop
    CMP.W       #0,D1
    BEQ         postIncList
preDecList
    

    BRA         regListLoopTail
postIncList

regListLoopTail
*    CMP.B       

*   Parse the bitmask for a MOVEM instruction, and print the list of registers being moved
*   D1 - Bitmask
*   D4 - Loop counter (current register number)
*   D2 - Bit storage
*   D0 - Sequential register start (0-7)
printM
    PRINT       <'[Reg list]'>
    RTS

*   Print the address destination for a branch/jump instruction
printDisp
    BSR         calcDispAddr
    MOVE.L      A1,D3
    JMP         printReg
    RTS
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
