; -----------------------------------------------------------
; Microcontroller Based Systems homework example

; -------------------------------------------------------------------
; Task description:
;   Convert a decimal number given by a variable-length ASCII character string
;   in the internal memory (0..65535) to binary format.
;   If an invalid ASCII character is detected in the input, indicate by CY=1.
;   Input: Start address of the string (pointer)
;   Outputs: Converted binary number in 2 registers, CY flag
;   Hint: Create an auxiliary subroutine for multiplication by 10.
; -------------------------------------------------------------------

; Definitions
; -------------------------------------------------------------------

; Address symbols for creating pointers

STR_ADDR_IRAM  EQU 0x40
STR_CHAR1 EQU '1'
STR_CHAR2 EQU '2'
STR_CHAR3 EQU '8'
STR_CHAR4 EQU '9'
STR_CHAR5 EQU '9'
STR_CHAR6 EQU 0

; Test data for input parameters
; (Try also other values while testing your code.)

; Interrupt jump table
ORG 0x0000;
    SJMP  MAIN                  ; Reset vector

; Beginning of the user program
ORG 0x0033

; -------------------------------------------------------------------
; MAIN program
; -------------------------------------------------------------------
; Purpose: Prepare the inputs and call the subroutines
; -------------------------------------------------------------------

MAIN:

    ; Prepare input parameters for the subroutine
	MOV R0,#STR_ADDR_IRAM
	MOV @R0, #STR_CHAR1
	INC R0
	MOV @R0, #STR_CHAR2
	INC R0
	MOV @R0, #STR_CHAR3
	INC R0
	MOV @R0, #STR_CHAR4
	INC R0
	MOV @R0, #STR_CHAR5
	INC R0
	MOV @R0, #STR_CHAR6

	MOV R7, #STR_ADDR_IRAM

; Infinite loop: Call the subroutine repeatedly
LOOP:

    CALL ASCIIDEC_2_BIN ; Call decimal string to number subroutine
	
	; example of doing something else when given cy=1
	clr a			; clears A
	addc a,#00		; a will be the value of the cy flag
	jnz defect_num	; if a is not 0, aka the cy flag is set we print an E
    SJMP  LOOP

defect_num:
mov a,#10000110b		; encoding for E on a 7-segment display
mov P1,a				; output				
sjmp LOOP

; ===================================================================
;                           SUBROUTINE(S)
; ===================================================================


; -------------------------------------------------------------------
; ASCIIDEC_2_BIN
; -------------------------------------------------------------------
; Purpose: Converts an ASCII decimal string into a 16-bit unsigned number
; -------------------------------------------------------------------
; INPUT(S):
;   R7 - Base address of the input string in the internal memory
; OUTPUT(S):
;   R5 - High byte of the parsed 16-bit number
;   R6 - Low byte of the parsed 16-bit number
;   CY - Invalid input string
; MODIFIES:
;   [TODO]
; -------------------------------------------------------------------



ASCIIDEC_2_BIN:
mov r0,0x7			; pushes the value of r7 to the stack
mov a,@r0			; reads the first byte at the pointed location
jnz continue1		; if it is zero, end of string has been reached
ret					; so we ret
continue1:
inc r0				; increment pointer
subb a,#30h			; a = a-48
mov r6,a			; saves a in r6
subb a,#0Ah			; a = a-10
jnc invalid			; if a was larger than 9, then it didn't carry, and it wasn't a ascii decimal number
mov a,@r0			; reads second byte from the pointers location
jnz continue2		; if end of string hasn't been reached, continue
ret					; else return
continue2:
inc r0				; increment pointer
subb a,#2Fh			; a = a-CY-47 (CY is known to be 1)
mov r1,a			; saves a in r1
subb a,#0Ah			; a = a-10
jnc invalid			; if a was larger than 9, then it didn't carry, and it wasn't a ascii decimal number
mov a,r6			; loads the first number to a
rl a				; a = 2*r6
mov r2,a			; r2 = a, or alteranitevly r2 = 2*r6
rl a				; a = 4*r6
rl a				; a = 8*r6
add a,r2			; a = 10*r6
add a,r1			; a = a+r1, we know for a fact that no combination of any two decimal numbers will be greater than 255
mov r6,a			; r6 gets updated
mov a,@r0			; we read next byte from the pointer
jnz continue3		; if the byte is zer0, the end of string has been reached
ret					; else return
continue3:
inc r0				; increment pointer
subb a,#30h			; a = a-48
mov r5,a			; saves a in r5
subb a,#0Ah			; a = a-10
jnc invalid			; if a was larger than 9, then it didn't carry, and it wasn't a ascii decimal number
mov a,@r0			; we read next byte from the pointer
jnz continue4		; if the byte is zer0, the end of string has been reached
mov a,r6			; a = low byte value
mov b,#0Ah			; b = 10
mul ab				; ab = a * b
add a,r5			; we add the most recent number to the low byte value
mov r6,a			; saves the lb in r6
mov a,b				; loads the ub to a
addc a,#00h			; in case it overflowed we add
mov r5,a			; saves the upper byte to r5
ret					; then return
continue4:
inc r0				; increments pointer
subb a,#2Fh			; again a = a-CY-47 and we know that CY is 1
mov r1,a			; save a in r1
subb a,#0Ah			; a = a-10
jnc invalid			; if a was larger than 9, then it didn't carry, and it wasn't a ascii decimal number
mov a,r5			; we've seen this before
rl a				; it multiplies r5 by 10
mov r2,a			; -||-
rl a				; -||-
rl a				; -||-
add a,r2			; -||-
add a,r1			; and then we add our current number to it
mov r5,a			; and stores it to r5
mov a,@r0			; yay, the final read (for now)
jnz continue5		; again if zer0 the null byte has been reached
mov a,r6			; a = ub
mov b,#64h			; b = 100
mul ab				; ab = 100*ub
add a,r5			; adds the newest values to a
mov r6,a			; stores it in r6
mov a,b				; loads ub to a
addc a,#00h			; and add the carry (if any)
mov r5,a			; loads ub to r5
ret					; return
continue5:
inc r0				; increments pointer
subb a,#30h			; a = a-48
mov r1,a			; saves a in r1
subb a,#0Ah			; a = a-10
jbc PSW.7,num5Pass	; if CY is set we jump to num5Pass and reset it, else it didn't carry	
setb PSW.7			; we set CY to 1
ret					; and we return
num5Pass:
mov a,r6			; loads the lb value
mov b,#64h			; b = 100
mul ab				; ab = 100*lb
add a,r5			; add the 
xch a,b				; ub now in a
addc a,#00			; add carry to ub
xch a,b				; lb now in a
mov r2,b			; save ub for later
mov b,#0Ah			; b = 10
mul ab				; ab = a*b
mov r6,a			; r6 = lb
mov a,b				; a = ub
add a,r2			; a = new ub + old ub
rlc a				; a = 2*ub
mov r2,a			; r2 = 2*ub
rlc a				; a = 4*ub
rlc a				; a = 8*ub
add a,r2			; a = 8*ub+2*ub = 10*ub
mov r5,a			; r5 = ub
xch a,r6			; r6 = ub, a = lb
add a,r1			; a = lb + current number
xch a,r6		 	; a = ub, r6 = lb
addc a,#00			; if it overflowed
mov r5,a			; store ub
ret					; return
invalid:			; in case we get a bad char
clr a				; clears a, a=0
dec a				; a=ff
add a,#01h			; a=00 and CY=1
ret					; return to main loop

END