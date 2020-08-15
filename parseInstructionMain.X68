    INCLUDE     "findOpcodeMain.X68"

; might want to include branch displacement calc function here if I don't use it in instr identification
parseInstructionMain: 
    ; save SP so if opcode is invalid, we can return immediately
    MOVEA   SP,A2
    
    BSR     findOpcodeMain
*    ; I think this should parse the instructions by common patterns/formats
*    ; For ex, many opcodes use bits 0-2 for their source arg, and bits 3-5 for the arg mode/type
*    ; We could use a common method to parse this section
*    ; Basically, findOpcodeMain deals with identifying the name. It sets a string or flag somewhere for us
*    ; Based on this flag, we know the instruction's format
*    LEA     instrTypeTable,A0
*    ; D5 currently contains the index for the jump table
*    MOVE.B  D5,D0
*    BSR     calcJmpOffset
    
    ; print instr size
    
    ; print source arg
    BSR     getSrcReg
    BSR     getSrcMode
    
    ; comma separating args
    PRINT   <','>
    
    ; print dest arg
    BSR     getDestReg
    BSR     getDestMode
    
    ; endl
    PRINT   <''>,ENDL
    
	RTS



instrTypeTable
    JMP     instrTypeOne
    JMP     instrTypeTwo
    JMP     instrTypeThree
    JMP     instrTypeFour
    JMP     instrTypeFive
    JMP     instrTypeSix
    JMP     instrTypeSeven
    JMP     instrTypeEight
    JMP     instrTypeNine
    JMP     instrTypeTen
    

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

; source arg format is almost universal, exceptions being BRA/BEQ/BGT/BLE, RTS, NOP

instrTypeOne

    ; print size first

    RTS

instrTypeTwo
; for 

    RTS
    
instrTypeThree
; for ADD, SUB, AND
; source mode is standard, dest arg is data reg, dest mode is direction and size

    RTS

instrTypeFour

    RTS

instrTypeFive

    RTS

instrTypeSix

    RTS

instrTypeSeven

    RTS

instrTypeEight

    RTS

instrTypeNine

    RTS
    
instrTypeTen
; for branching (BRA/BEQ/BGT/BLE)
; TODO: add sanity check for displacement addr

    RTS

getSrcMode
    isoBitsM    D4,#5,#3
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getDestMode
    isoBitsM    D4,#8,#6
    LEA         modeJmpTable,A0
    BRA         calcJmpOffset
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
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
    ; NOP's are for padding so I can reuse calcJmpOffset
    JMP         printRegD ; #000    ; Data Reg, D0-D7
    
    JMP         printRegA ; #001    ; Addr Reg, A0-A7
    ; illegal for MOVE, MOVEM, ADD, SUB, AND, NOT, LSd, ASd, JSR
    
    JMP         printAddress ; #010    ; Address, (A0)-(A7)
    
    JMP         printAddrPostInc ; #011    ; Address w/ Postinc, (An)+
    ; illegal for 
    
    JMP         printAddrPreDec ; #100    ; Address w/ Predec, -(An)

; NOT NEEDED    
    JMP         printAddrDisp ; Address w/ Displacement, (d16,An,Xn)
    ; illegal for
    
; NOT NEEDED    
    JMP         printAddrIndex ; Address w/ Index (d8,An,Xn)
    ; illegal for 
    
    ; case 111
    MOVE.B  D3,D0
    LEA     modeJmpTable111,A0
    JMP     calcJmpOffset
        
    
modeJmpTable111
; do all of these modes require an extension?
; these cases do: 0,1,100
    JMP     printAbsShort ; Abs Short
    
    JMP     printAbsLong ; Abs Long
    ; illegal for MULS, DIVU
    
    JMP     printCounterDisp ; PC w/ Displacement
    ; illegal for MOVE, 
    
    JMP     printCounterIndex ; PC w/ Index
    ; illegal for MOVE, 
    
    JMP     printImmediate ; Immediate
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
    ; TODO: change to illegalArgs and make said function
    ; JMP     invalidOpcode ; should I instead print out illegal args?

    RTS


printRegD
; TODO
    PRINTN  #$D,#16
    PRINTN  D3
    RTS
*    PRINTN  

printRegA
; TODO
    PRINTN  #$A,#16
    ; PRINTN is cleaner, so use it for numbers like this if possible
    PRINTN  D3
    RTS             
   
printAddress
; TODO
*    PRINT   <'addr'>

    PRINT   <'('>
    BSR     printRegA
    PRINT   <')'>
    RTS
   
printAddrPostInc
; TODO
*    PRINT   <'addr w/ postinc'>

    BSR     printAddress
    PRINT   <'+'>
    RTS

printAddrPreDec
; TODO
*    PRINT   <'addr w/ predec'>

    PRINT   <'-'>
    BSR     printAddress  
    RTS  

; NOT NEEDED
printAddrDisp
*    PRINT   <'addr w/ displacement'>
    RTS

; NOT NEEDED
printAddrIndex
*    PRINT   <'addr w/ index'>
    RTS

printAbsShort
*    PRINT   <'absolute short'>
    PRINT   <'$'>
    
    BSR readFromFile
    printReg
    
    RTS

printAbsLong
*    PRINT   <'absolute long'>
    PRINT   <'$'>
    
    BSR readFromFile
    ; Print Address
    printReg
    BSR readFromFile
    ; Print Address
    printReg
    
    RTS

; NOT NEEDED
printCounterDisp
*    PRINT   <'counter w/ displacement'>
    RTS

; NOT NEEDED
printCounterIndex
*    PRINT   <'counter w/ index'>
    RTS
 
printImmediate
*    PRINT   <'immediate'>
    PRINT   <'#'>
    
    BSR     getOpcodeSize   ; Puts binary for instruction size in D0 (00 for byte, 01 for word, 10 for long)
    BSR     readFromFile    
    ; Print value
    printReg
    
    CMP.B   #$2,D0          ; If size bits indicate long, read another word from memory
    BNE     DONE
    
    BSR     readFromFile   
    ; Print value
    printReg
    
DONE    RTS

*   Prints the contents of a register in hex (Slightly modified from function in IO)
*   For comments on what each line does, see IO's function
*   D3 - Register being printed
*   D5 - Loop index
*   D2 - shift loop index
*   D1 - Char storage

printReg
    MOVE.L  #8,D5
LOOP
    MOVE.L  D3,D1
    CLR     D2
SHIFTLOOP
    ADD.L   #1,D2
    CMP.B   D5,D2
    BEQ     NUM
    LSR.L   #4,D1
    JMP     SHIFTLOOP
NUM
    AND.L   #$F,D1
    CMP.B   #9,D1
    BGT     LETTER
    ADD.B   #'0',D1
    RUNTRAP <#6>
    JMP     LOOP_TAIL
LETTER
    ADD.B   #55,D1
    RUNTRAP <#6>
LOOP_TAIL
    SUB.B   #1,D5
    CMP.B   #0,D5
    BNE     LOOP
    PRINT   <' '>
    RTS


; TODO
; should I print as decimal or hex?



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
