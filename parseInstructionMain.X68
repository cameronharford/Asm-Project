    INCLUDE     "dependencies.X68"
; might want to include branch displacement calc function here if I don't use it in instr identification
parseInstructionMain: 
    ; I think this should parse the instructions by common patterns/formats
    ; For ex, many opcodes use bits 0-2 for their source arg, and bits 3-5 for the arg mode/type
    ; We could use a common method to parse this section
    ; Basically, findOpcodeMain deals with identifying the name. It sets a string or flag somewhere for us
    ; Based on this flag, we know the instruction's format
    
	RTS

; instruction arg archetypes:
; Branches
; No args (NOP, RTS)
; Source arg
; Source and dest args (
	
getSourceMode
    isolateBitsM    D4,#5,#0
    LEA             modeJmpTable,A0
    JMP             calcJmpOffset
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getDestMode
    
    RTS ; TODO: remove if this sub uses JMP, keep for JSR
    
getSourceRegister
    ; typically used for printing, but also used for a jmp table index
    isolateBitsM    D4,#2,#0
    MOVE.B          D0,D3
    RTS
    
getDestRegister
    isolateBitsM    D4,#11,#9
    RTS
    
modeJmpTable
    ; jump table for argument mode
    ; NOP's are for padding so I can reuse calcJmpOffset
    STOP            #000
    NOP
    
    STOP            #001
    NOP
    
    STOP            #010
    NOP
    
    STOP            #011
    NOP
    
    STOP            #100
    NOP
    
    STOP            #101
    NOP
    
    STOP            #110
    NOP
    
    ; case 111
    BSR             getRegister
    LEA             modeJmpTable111,A0
    JMP             calcJmpOffset
        
    
modeJmpTable111
    STOP            #000    ; Abs Short
    NOP
    
    STOP            #001    ; Abs Short
    NOP
    
    STOP            #010    ; PC w/ Displacement
    NOP
    
    STOP            #100    ; Immediate
    NOP
   

printReg
; TODO
    ; idea for logic:
    ;
    CMP.B           #0,D3
    BNE             
   
printRegD

   
printRegA
; TODO
    PRINTN          #$A,#16
    ; PRINTN is cleaner, so use it for numbers like this if possible
    BSR             
   
printAddress
; TODO
    PRINT           <(>
    JSR             printRegA
    PRINT           <(>
   
printPreDec
; TODO
    PRINT           <->
    BSR             printAddress
    

printPostInc
; TODO

printImmediate
; TODO
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
