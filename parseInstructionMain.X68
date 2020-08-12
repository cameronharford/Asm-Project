    INCLUDE     "dependencies.X68"
; might want to include branch displacement calc function here if I don't use it in instr identification
parseInstructionMain: 
    ; save SP so if opcode is invalid, we can return immediately
    MOVEA   SP,A2
    
    ; I think this should parse the instructions by common patterns/formats
    ; For ex, many opcodes use bits 0-2 for their source arg, and bits 3-5 for the arg mode/type
    ; We could use a common method to parse this section
    ; Basically, findOpcodeMain deals with identifying the name. It sets a string or flag somewhere for us
    ; Based on this flag, we know the instruction's format
    LEA     instrTypeTable,A0
    ; D5 currently contains the index for the jump table
    MOVE.B  D5,D0
    BSR     calcJmpOffset
    
    ; print instr size
    
    ; print source arg
    
    ; comma separating args
    PRINT   <,>
    
    ; print dest arg
    
	RTS



instrTypeTable
    JMP     instrTypeOne
    JMP     instrTypeTwo
    JMP     instrTypeThree
    JMP     instrTypeFour
    

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

; source arg format is almost universal, exceptions being BRA/BEQ/BGT/BLE, RTS, NOP

instrTypeOne
; for ADD, SUB, AND
; source mode is standard, dest arg is data reg, dest mode is direction and size

    ; print size first


instrTypeTwo
; for 
	
instrTypeThree
; for 


instrTypeFour
; for branching (BRA/BEQ/BGT/BLE)



getSrcMode
    isoBitsM    D4,#5,#3
    LEA         modeJmpTable,A0
    JMP         calcJmpOffset
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getDestMode
    
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getSrcReg
    ; typically used for printing, but also used for a jmp table index
    isoBitsM    D4,#2,#0
    MOVE.B      D0,D3
    RTS
    
getDestRegister
    isoBitsM    D4,#11,#9
    MOVE.B      D0,D3
    RTS
    
modeJmpTable
    ; jump table for argument mode
    ; NOP's are for padding so I can reuse calcJmpOffset
    JMP     printRegD ; #000    ; Data Reg, D0-D7
    ; illegal for
    NOP
    
    JMP     printRegA ; #001    ; Addr Reg, A0-A7
    ; illegal for MOVE, MOVEM, ADD, SUB, AND, NOT, LSd, ASd, JSR
    
    JMP     printAddress ; #010    ; Address, (A0)-(A7)
    
    JMP     printPostInc ; #011    ; Address w/ Postinc, (An)+
    ; illegal for 
    
    JMP     printPreDec ; #100    ; Address w/ Predec, -(An)
    ; illegal for 
    NOP
    
    STOP    #101    ; Address w/ Displacement, (d16,An,Xn)
    ; illegal for 
    NOP
    
    STOP    #110    ; Address w/ Index (d8,An,Xn)
    ; illegal for 
    NOP
    
    ; case 111
    BSR     getRegister
    LEA     modeJmpTable111,A0
    JMP     calcJmpOffset
        
    
modeJmpTable111
; do all of these modes require an extension?
; these cases do: 0,1,100
    STOP    #000    ; Abs Short
    NOP
    
    STOP    #001    ; Abs Long
    ; illegal for MULS, DIVU
    NOP
    
    STOP    #010    ; PC w/ Displacement
    ; illegal for MOVE, 
    NOP
    
    STOP    #011    ; PC w/ Index
    ; illegal for MOVE, 
    NOP
    
    STOP    #100    ; Immediate
    ; illegal for MOVE (dest), ADD, SUB, AND, 
    ; for MOVE, you can't use an immediate as a destination
    ; for ADD/SUB/AND, they have variants which handle immediates (ADDI/SUBI/ANDI)
    ; check if instr is ADD, SUB, AND b/c that would be illegal
    NOP
    
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
    JMP         invalidOpcode ; should I instead print out illegal args?
   

printReg
; TODO
    ; idea for logic:
    ;
    CMP.B   #0,D3
    BNE     

printRegD
    PRINTN  #$D,#16
    PRINTN  

printRegA
; TODO
    PRINTN  #$A,#16
    ; PRINTN is cleaner, so use it for numbers like this if possible
    PRINTN  D3
    RTS             
   
printAddress
; TODO
    PRINT   <(>
    BSR     printRegA
    PRINT   <)>
    RTS
   
printPreDec
; TODO
    PRINT   <->
    BSR     printAddress  
    RTS  

printPostInc
; TODO
    BSR     printAddress
    PRINT   <+>
    RTS
    
printImmediate

; TODO
; should I print as decimal or hex?







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
