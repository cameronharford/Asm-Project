    ORG $1000
    INCLUDE  "parseInstructionMain.x68" 
    
    
START
************************************************************
**                 main program entry                     **
************************************************************
*A5 - the console window current line
*A6 - our current memory location to read for the opcode requester
WELCOME
    MOVE.L  #$FF00,D1              ;clear the screen in case the program is being re-run
    RUNTRAP <#11>
    PRINT   <'               @...@ .(../%  %..*(  %...( .#..*/  #..*.                        '>,ENDL
    PRINT   <'               &...*. &...&  @...&  %...@  %...&  @...#                        '>,ENDL
    PRINT   <'                &...@ .*../*  *...* ./....  *..*.  *..**                       '>,ENDL
    PRINT   <'              (&***********************.**********************%#               '>,ENDL
    PRINT   <'            #&%***************@@@@@@@@@@@@@@@@@*****************#              '>,ENDL
    PRINT   <'           @**@*********&@%%&%&%%%%%&&&&&&&&%&%%&%%%%%&@@/*******&             '>,ENDL
    PRINT   <'#%..........%/&/*******&@@(((((((((((((((((((((((((((((((&&******%.......#*    '>,ENDL
    PRINT   <' @&&&&&&&&&&@*(%*******#@@#((((PowerPC is Better((((((((((@***&&(%(.....*&.    '>,ENDL
    PRINT   <'       ....@*.*@*******/@@&(((((((68k Disassembler((((((((@(**#&**&            '>,ENDL
    PRINT   <' #@........../%&@@@@@@@@@@@(((((((((((((((((((((((((((((((%@***@**&.......*#   '>,ENDL
    PRINT   <'   ...      (**/%*******%@@((((((((((((((((((((((((((((((((@***&#*(@%(((((/    '>,ENDL
    PRINT   <'   .(#%%%%%%@&%*@********@@%((((((Cameron Harford((((((((((@/**/&**%           '>,ENDL
    PRINT   <'  #&..........(*&/*****%&@@@((((((((Isaac Jones((((((((((((%@@@@@/*@........&  '>,ENDL
    PRINT   <'             #**(%*****###@@((((((((((Kelly Pratama(((((((((@******((.....     '>,ENDL
    PRINT   <'    &&&&&&&&&&&@*@*****/&*@@%((((((((((Jerahmy Bindon(((((((@/******@&@@@@@@(  '>,ENDL
    PRINT   <'   .#..........&/&******@*&@@(((((((((((((((((((((((((((((((%%***(@#&.......*( '>,ENDL
    PRINT   <'              #**/#*****&((@@#(((((((((((((((((((((((((((((((@@@@@@*&#         '>,ENDL
    PRINT   <'    @(..........@*@&&&&&&&*@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/*****/@/*.....% '>,ENDL
    PRINT   <'    (&###%%%%%#%@*&********#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*******&........%'>,ENDL
    PRINT   <'               &**/#********@*****************************************/        '>,ENDL
    PRINT   <'     %(..........&*@&&&&&&&&&/****************************************@.......@'>,ENDL
    PRINT   <'      ..*......*#**&**************************************************@&((((#%%'>,ENDL
    PRINT   <'               .%***.@&*********************************************#@         '>,ENDL
    PRINT   <'                .&*******@@@%**&@@@***%@@@***#@@@***(@@@***&@@@****/@          '>,ENDL
    PRINT   <'                   .%&&%&/..*##@...&/%@...@*(@...@((@...@*/@...@#(.            '>,ENDL
    PRINT   <'                         &...% #....* (..... (....* *....# /....#              '>,ENDL
    PRINT   <'                         .*...& @...(  &...%  &...(  #...%  &...%              '>,ENDL
    PRINT   <'                          .&&@@  #@@@#  #@@@/  #@@@/  %@@@*  *@@@.             '>,ENDL
    PRINT   <'                                                                               '>,ENDL
    
GET_ADDRESSES
;get starting address
    PRINT   <'Enter a valid and even 8-char hexadecimal starting address: '>
    LEA     asciiToHexBuffer,A1
    RUNTRAP <#2>
    MOVE.B  #8,D0                   ;we want to parse 8 chars to hex
    JSR     SUB_loadHexString
    MOVE.L  D1,(startAddress)
    
;get ending address
    PRINT   <'Enter a valid and even 8-char hexadecimal ending address: '>
    LEA     asciiToHexBuffer,A1
    RUNTRAP <#2>
    MOVE.B  #8,D0                   ;we want to parse 8 chars to hex
    JSR     SUB_loadHexString
    MOVE.L  D1,(endAddress)
    CMP.L   (startAddress),D1
    BGE     SUB_printer             ;if starting address is less than or equal to ending address then begin the program
    PRINT   <'Starting address must be less than or equal to ending address. '>,ENDL
    PRINT   <'Press Enter to try again.'>
    RUNTRAP <#5>
    JMP     WELCOME 
    
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
    BGE     LOWERCASE_LETTER        ;all this is self explanatory
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
**                  print register value                  **
************************************************************
*A6 - the register we are printing out

*D3 - loop index
*D2 - shift loop index
*D1 - char storage
SUB_printRegister
    MOVE.L  #8,D3           ;amount of chars to print
PR_LOOP
    MOVE.L  A6,D1
    CLR     D2
PR_SHIFTLOOP
    ADD.L   #1,D2
    CMP.B   D3,D2
    BEQ     PR_NUM          ;move on when we've shifted enough
    LSR.L   #4,D1           ;shift the char we want down to the lowest nibble position
    JMP     PR_SHIFTLOOP
PR_NUM    
    AND.L   #$F,D1          ;extract lowest nibble
    CMP.B   #9,D1           ;find out if its 0-9 or a-f
    BGT     PR_LETTER
    ADD.B   #'0',D1         ;convert to ascii
    RUNTRAP <#6>            ;print the char
    JMP     PR_LOOP_TAIL
PR_LETTER    
    ADD.B   #55,D1    ;'A' - 10
    RUNTRAP <#6>
PR_LOOP_TAIL
    SUB.B   #1,D3
    CMP.B   #0,D3
    BNE     PR_LOOP
    PRINTT
    RTS

************************************************************
**                    INSTRUCTION PRINTER                 **
************************************************************
*A5 - line counter
*A6 - address pointer
SUB_printer
    LEA     startAddress,A6         ;load our starting address into our address pointer. so we can start at the beginning of where the file is loaded
    MOVEA.L (A6),A6
    JMP     P_CONTINUE
P_CLEARSCREEN
    MOVE.L  #0,A5
    PRINT   <'Please press enter to continue.'>
    RUNTRAP <#5>
P_CONTINUE   
;checking if we are at the end of our file
    LEA     endAddress,A0
    CMP.L   (A0),A6                 ;check if we are done reading the file
    BGT     P_DONE                  ;jump to the ask-to-read-another-file printout and termination
;printing an instruction and updating our instruction pointer
    BSR     SUB_printRegister       ;print the value of A6 out to console 
    BSR     parseInstructionMain
    ADD     #1,A5                   ;update how many lines we have printed out
    
;reading how full our screen is
    CMP.L   #31,A5                  ;if our screen is full we need to ask the user to press ender
    BEQ     P_CLEARSCREEN
    JMP     P_CONTINUE              ;otherwise just continue reading
P_DONE
    PRINT   <'Press y to restart program.'>,ENDL
    PRINT   <'Press any other key to exit.'>,ENDL
    RUNTRAP <#5>
    CMP.B   #'y',D1
    BEQ     START
    CMP.B   #'Y',D1
    BEQ     START
    PRINT   <'Program halted.'>,ENDL
    RUNTRAP <#9>
    END     START








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
