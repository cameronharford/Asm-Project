isolateBits
    ; D0 contains the number you'd like to isolate bits on
    ; D1 contains the starting bit number, ranging from 31-0
    ; D2 contains the stopping bit number, ranging from 30-0
        
    ; D3 = 31 - D1 
    MOVE.L      #31,D3
    SUB.B       D1,D3 

    ; D0 = D0 << D3
    LSL.L       D3,D0

    ; D3 = D3 + D2 
    ADD.B       D2,D3

    ; D0 = D0 >> D3
    LSR.L       D3,D0
    
    ; return
    RTS

; example call:
;	MOVE.L 		#$1234,D0
;	MOVE.B		#11,D1
;	MOVE.B		#8,D2
;	BSR			isolateBits
;
; return from this call:
; 	D0 = 0x2

	
*	OPT         MEX
isoBitsM        MACRO
    ; args same as above, except they're immediates or different regs
    IFNE NARG-3                       ;if not 3 arguments
        FAIL ERROR, isolateBits requires 3 arguments
        MEXIT
    ENDC
    MOVEM.L     D1-D3,-(SP)
    IFNC '\1','D0'
        ; if arg1 isn't D0, move it to D0
        MOVE.L      \1,D0
    ENDC
    IFNC '\2','D1'
        ; same thing with arg2/D1
        MOVE.B      \2,D1
    ENDC
    IFNC '\3','D2'
        ; same thing with arg3/D2
        MOVE.B      \3,D2
    ENDC
    BSR         isolateBits
    MOVEM.L     (SP)+,D1-D3
    ENDM
    
; example call:
;   isoBitsM    #$1234,#11,#8
;
; same as the above example
; returns D0 = 0x2




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
