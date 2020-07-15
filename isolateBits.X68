isolateBits
    ; D0 contains the number you'd like to isolate bits on
    ; D1 contains the starting bit number, ranging from 31-0
    ; D2 contains the stopping bit number, ranging from 30-0
    
    ; Save D3 before we overwrite it
    MOVE.L      D3,-(SP)
    
    ; D3 = 31 - D1 
    MOVE.L      #31, D3
    SUB.B       D1, D3 

    ; D0 = D0 << D3
    LSL.L       D3, D0

    ; D3 = D3 + D2 
    ADD.B       D2, D3

    ; D0 = D0 >> D3
    LSR.L       D3, D0
    
    ; Restore D3 then return
    MOVE.L      (SP)+,D3
    RTS

; example call:
;	MOVE.L 		#$1234, D0
;	MOVE.B		#11, D1
;	MOVE.B		#8, D2
;	BSR			isolateBits
;
; return from this call:
; 	D0 = 0x2

	
*	OPT         MEX
isolateBitsM    MACRO
    ; args same as above, except they're immediates or different regs
    IFNE NARG-3                       ;if not 3 arguments
        FAIL ERROR, isolateBits requires 3 arguments
        MEXIT
    ENDC
    MOVE.L      \1,D0
    MOVE.B      \2,D1
    MOVE.B      \3,D2
    BSR         isolateBits
    ENDM
    
; example call:
;   isolateBitsM    #$1234,#11,#8
;
; same as the above example
; returns D0 = 0x2
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
