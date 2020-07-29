    INCLUDE     "dependencies.X68"
; might want to include branch displacement calc function here if I don't use it in instr identification
parseInstructionMain: 
    ; I think this should parse the instructions by common patterns/formats
    ; For ex, many opcodes use bits 0-2 for their source arg, and bits 3-5 for the arg mode/type
    ; We could use a common method to parse this section
    ; Basically, findOpcodeMain deals with identifying the name. It sets a string or flag somewhere for us
    ; Based on this flag, we know the instruction's format
    ; Because args could be illegal, we print instruction name in this method after confirming legal args
    
	RTS

; instruction arg archetypes:
; Branches
; No args (NOP, RTS)
; Source arg
;   -arg value within opcode
;   -arg value appended as word/long extension
; Source and dest args
;   -arg values within opcode
;   -arg values appended as word/long extensions

; source arg format is almost universal, exceptions being branching, RTS, NOP

instrTypeOne
; for ADD, SUB, AND
    


instrTypeTwo
	
instrTypeThree

instrTypeFour



getSourceMode
    isoBitsM    D4,#5,#3
    LEA         modeJmpTable,A0
    JMP         calcJmpOffset
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getDestMode
    
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getSourceRegister
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
    STOP    #000    ; Data Reg, D0-D7
    NOP
    
    STOP    #001    ; Addr Reg, A0-A7
    NOP
    
    STOP    #010    ; Address, (A0)-(A7)
    NOP
    
    STOP    #011    ; Address w/ Postinc, (An)+
    NOP
    
    STOP    #100    ; Address w/ Predec, -(An)
    NOP
    
    STOP    #101    ; Address w/ Displacement, (d16,An,Xn)
    NOP
    
    STOP    #110    ; Address w/ Index (d8,An,Xn)
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
    
    STOP    #010    ; PC w/ Index
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
    BSR             
   
printAddress
; TODO
    PRINT   <(>
    BSR     printRegA
    PRINT   <)>
   
printPreDec
; TODO
    PRINT   <->
    BSR     printAddress    

printPostInc
; TODO
    BSR     printAddress
    PRINT   <+>

printImmediate
; TODO
; should I print as decimal or hex?


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
