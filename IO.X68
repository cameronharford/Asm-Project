    ORG $1000
DEPENDENCY  SET     0
    INCLUDE  "dependencies.x68"
    INCLUDE  "parseInstructionMain.x68"
START 
************************************************************
**                 main program entry                     **
************************************************************
*A7 - the console window current line
*A6 - our current memory location to read for the opcode requester

    PRINT   <Welcome to the PowerPC is Better 68k Disassembler>,ENDL
    PRINT   <Bla bla bla bla bla bla bla...>,ENDL
    
;get starting address
    PRINT   <Enter a valid and even 8-char hexadecimal starting address: >
    LEA     asciiToHexBuffer,A1
    RUNTRAP <#2>
    MOVE.B  #8,D0                   ;we want to parse 8 chars to hex
    JSR     SUB_loadHexString
    MOVE.L  D1,(startAddress)
    
;get ending address
    PRINT   <Enter a valid and even 8-char hexadecimal ending address: >
    LEA     asciiToHexBuffer,A1
    RUNTRAP <#2>
    MOVE.B  #8,D0                   ;we want to parse 8 chars to hex
    JSR     SUB_loadHexString
    MOVE.L  D1,(endAddress)
    JSR     SUB_printer
************************************************************
**                convert ascii to hex                    **
************************************************************
*A6 - address of ascii string to parse
*D0 - length of string (I am not utilizing null terminators)

*D1 - completed hex value (return register)
*D2 - temporary counter
SUB_loadHexString
    CLR     D1                      ;safety first <3
    MOVE.L  #1,D2                   ;D3 is our counter, and we are working with base 1 so char_count looks pretty
    JMP     PARSE               
REPARSE                             ;REPARSE lets us smoothly run a dowhile loop (because we need to shift our number properly to load it)
    LSL.L   #4,D1                   ;D2 is where we are storing our final number
    ADD.B   #1,D2                   ;D3 is our current char index
PARSE                               ;initial parse
    CMP.B   #'a',(A1)           
    BGE     LOWERCASE_LETTER        ;all this shit is self explanatory
    CMP.B   #'A',(A1)           
    BGE     UPPERCASE_LETTER    
PLAIN_NUMBER                    
    SUB.B   #'0',(A1)           
    ADD.B   (A1),D1             
    JMP     LOOP_TAIL           
UPPERCASE_LETTER                
    SUB.B   #55,(A1)                ;A holds a value of 10 in hex. 'A' - 10 = 55
    ADD.B   (A1),D2             
    JMP     LOOP_TAIL           
LOWERCASE_LETTER                
    SUB.B   #87,(A1)            
    ADD.B   (A1),D1             
    JMP     LOOP_TAIL           
LOOP_TAIL                       
    ADD.L   #1,A1                   ;Iterate the string address by one byte to move on to the next char
    CMP.B   D0,D2       
    BLT     REPARSE             
    RTS         
************************************************************
**                    INSTRUCTION PRINTER                 **
************************************************************
*A5 - line counter
*A6 - address pointer
SUB_printer
    MOVE.L  #4,A5                   ;load the number of lines we have printed so far into A5. this means all the intro garbage.
    LEA     startAddress,A6         ;load our starting address into our address pointer. so we can start at the beginning of where the file is loaded
    MOVEA.L (A6),A6
    JMP     P_CONTINUE
P_CLEARSCREEN
    MOVE.L  #0,A5
    PRINT   <Please press enter to continue.>,ENDL
    RUNTRAP <#2>
P_CONTINUE   
;checking if we are at the end of our file
    LEA     endAddress,A0
;```
    CMP.L   (A0),A6                 ;check if we are done reading the file
    BGT     P_DONE                  ;jump to the ask-to-read-another-file printout and termination
;printing an instruction and updating our instruction pointer
    BSR     parseInstructionMain
    ADD.L   #2,A6
;reading how full our screen is
    ADD.L   #1,A5                   ;update how many lines we have printed to the screen
    CMP.L   #31,A5                  ;if our screen is full we need to ask the user to press ender
    BEQ     P_CLEARSCREEN
    JMP     P_CONTINUE              ;otherwise just continue reading
P_DONE
    PRINT   <Load another datafile and hit enter to continue. Otherwise exit the program externally.>
    RUNTRAP <#2>
    MOVE.L  #$FF00,D1
    RUNTRAP <#11>
    JMP     START
    
    END START





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
