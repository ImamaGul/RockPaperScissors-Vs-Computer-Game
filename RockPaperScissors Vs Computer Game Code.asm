;RockPaperScissors Vs Computer Game
;Imama Gul(01-135232-033)
;Sarah Naseer(01-135232-088)





; =========================================================================
; LAB CONCEPT MAPPED: STACKS (.STACK 100H defines the stack segment size)
; =========================================================================
.MODEL SMALL
.STACK 100H

.DATA

TITLEMSG DB 'ROCK PAPER SCISSORS$'
P1 DB '1 = ROCK$'
P2 DB '2 = PAPER$'
P3 DB '3 = SCISSORS$'
ASK DB 'ENTER CHOICE: $'

USERMSG DB 'YOU: $'
COMPMSG DB 'COMPUTER: $'

ROCKMSG DB 'ROCK$'
PAPERMSG DB 'PAPER$'
SCISSORMSG DB 'SCISSORS$'

WINMSG DB 'YOU WIN!$'
LOSEMSG DB 'COMPUTER WINS!$'
DRAWMSG DB 'DRAW!$'

AGAINMSG DB 'PLAY AGAIN? Y/N : $'

PLAYER DB ?
COMP DB ?

.CODE

; =========================================================================
; LAB CONCEPT MAPPED: PROCEDURES (MAIN PROC defines the main execution block)
; =========================================================================
MAIN PROC

MOV AX, @DATA
MOV DS, AX

; =========================================================================
; LAB CONCEPT MAPPED: LOOPS / CONTROL STRUCTURES (START: acts as the loop entry point for replay)
; =========================================================================
START:

; =========================================================================
; LAB CONCEPT MAPPED: BIOS INTERRUPTS (INT 10H AX=0003H Clears screen / sets text mode)
; =========================================================================
MOV AX, 0003H
INT 10H

; =========================
; DRAW BOX
; =========================

; =========================================================================
; LAB CONCEPT MAPPED: BIOS INTERRUPTS (INT 10H AH=06H Scrolls/clears window to draw colored box)
; =========================================================================
MOV AH, 06H
MOV AL, 0
MOV BH, 1EH
MOV CH, 3
MOV CL, 15
MOV DH, 22
MOV DL, 65
INT 10H

; =========================
; TITLE
; =========================

; =========================================================================
; LAB CONCEPT MAPPED: BIOS INTERRUPTS (INT 10H AH=02H Sets cursor position)
; =========================================================================
MOV AH, 02H
MOV BH, 0
MOV DH, 5
MOV DL, 28
INT 10H

LEA DX, TITLEMSG
MOV AH, 09H
INT 21H

; =========================
; MENU
; =========================

MOV AH, 02H
MOV DH, 8
MOV DL, 22
INT 10H

LEA DX, P1
MOV AH, 09H
INT 21H

MOV AH, 02H
MOV DH, 10
MOV DL, 22
INT 10H

LEA DX, P2
MOV AH, 09H
INT 21H

MOV AH, 02H
MOV DH, 12
MOV DL, 22
INT 10H

LEA DX, P3
MOV AH, 09H
INT 21H

; =========================
; INPUT
; =========================

; =========================================================================
; LAB CONCEPT MAPPED: LOOPS / CONTROL STRUCTURES (INPUT: acts as a conditional validation loop)
; =========================================================================
INPUT:

MOV AH, 02H
MOV DH, 15
MOV DL, 22
INT 10H

LEA DX, ASK
MOV AH, 09H
INT 21H

MOV AH, 01H
INT 21H

; =========================================================================
; LAB CONCEPT MAPPED: ARITHMETIC OPERATION (SUB instruction converts ASCII character to integer value)
; =========================================================================
SUB AL, 30H

; =========================================================================
; LAB CONCEPT MAPPED: CONTROL STRUCTURES (CMP & JL jump back if choice is less than 1)
; =========================================================================
CMP AL, 1
JL INPUT

; =========================================================================
; LAB CONCEPT MAPPED: CONTROL STRUCTURES (CMP & JG jump back if choice is greater than 3)
; =========================================================================
CMP AL, 3
JG INPUT

MOV PLAYER, AL

; =========================
; COMPUTER RANDOM
; =========================

; =========================================================================
; LAB CONCEPT MAPPED: BIOS INTERRUPTS (INT 1AH AH=00H Gets system clock ticks for random seed)
; =========================================================================
MOV AH, 00H
INT 1AH

MOV AX, DX
; =========================================================================
; LAB CONCEPT MAPPED: ARITHMETIC OPERATION (Bitwise AND operation to restrict value range)
; =========================================================================
AND AX, 0003H

; =========================================================================
; LAB CONCEPT MAPPED: CONTROL STRUCTURES (Conditional selection structure for computer's move)
; =========================================================================
CMP AX, 0
JE CROCK

CMP AX, 1
JE CPAPER

JMP CSCISSOR

CROCK:
MOV COMP, 1
JMP SHOW

CPAPER:
MOV COMP, 2
JMP SHOW

CSCISSOR:
MOV COMP, 3

; =========================
; SHOW CHOICES
; =========================

SHOW:

MOV AH, 02H
MOV DH, 17
MOV DL, 22
INT 10H

LEA DX, USERMSG
MOV AH, 09H
INT 21H

; =========================================================================
; LAB CONCEPT MAPPED: CONTROL STRUCTURES (Multi-way branch checking player move)
; =========================================================================
CMP PLAYER, 1
JE SHOW_USER_ROCK

CMP PLAYER, 2
JE SHOW_USER_PAPER

JMP SHOW_USER_SCISSOR

SHOW_USER_ROCK:
LEA DX, ROCKMSG
MOV AH, 09H
INT 21H
JMP SHOW_COMP

SHOW_USER_PAPER:
LEA DX, PAPERMSG
MOV AH, 09H
INT 21H
JMP SHOW_COMP

SHOW_USER_SCISSOR:
LEA DX, SCISSORMSG
MOV AH, 09H
INT 21H

SHOW_COMP:

MOV AH, 02H
MOV DH, 19
MOV DL, 22
INT 10H

LEA DX, COMPMSG
MOV AH, 09H
INT 21H

; =========================================================================
; LAB CONCEPT MAPPED: CONTROL STRUCTURES (Multi-way branch checking computer move)
; =========================================================================
CMP COMP, 1
JE SHOW_COMP_ROCK

CMP COMP, 2
JE SHOW_COMP_PAPER

JMP SHOW_COMP_SCISSOR

SHOW_COMP_ROCK:
LEA DX, ROCKMSG
MOV AH, 09H
INT 21H
JMP RESULT

SHOW_COMP_PAPER:
LEA DX, PAPERMSG
MOV AH, 09H
INT 21H
JMP RESULT

SHOW_COMP_SCISSOR:
LEA DX, SCISSORMSG
MOV AH, 09H
INT 21H

; =========================
; RESULT
; =========================

RESULT:

MOV AL, PLAYER
CMP AL, COMP
JE DRAW

; =========================================================================
; LAB CONCEPT MAPPED: NESTED CONTROL STRUCTURES (Outer comparison blocks leading to nested checks)
; =========================================================================
CMP AL, 1
JE PLAYER_ROCK

CMP AL, 2
JE PLAYER_PAPER

JMP PLAYER_SCISSOR

; =========================================================================
; LAB CONCEPT MAPPED: NESTED CONTROL STRUCTURES (Inner comparison blocks verifying specific outcome combinations)
; =========================================================================
PLAYER_ROCK:
CMP COMP, 2
JE LOSE
JMP WIN

PLAYER_PAPER:
CMP COMP, 3
JE LOSE
JMP WIN

PLAYER_SCISSOR:
CMP COMP, 1
JE LOSE
JMP WIN

WIN:

MOV AH, 02H
MOV DH, 21
MOV DL, 28
INT 10H

LEA DX, WINMSG
MOV AH, 09H
INT 21H

JMP AGAIN

LOSE:

MOV AH, 02H
MOV DH, 21
MOV DL, 26
INT 10H

LEA DX, LOSEMSG
MOV AH, 09H
INT 21H

JMP AGAIN

DRAW:

MOV AH, 02H
MOV DH, 21
MOV DL, 32
INT 10H

LEA DX, DRAWMSG
MOV AH, 09H
INT 21H

; =========================
; PLAY AGAIN
; =========================

AGAIN:

MOV AH, 02H
MOV DH, 23
MOV DL, 20
INT 10H

LEA DX, AGAINMSG
MOV AH, 09H
INT 21H

MOV AH, 01H
INT 21H

; =========================================================================
; LAB CONCEPT MAPPED: LOOPS / CONTROL STRUCTURES (Conditional jumps that loop back to START or exit)
; =========================================================================
CMP AL, 'Y'
JE START

CMP AL, 'y'
JE START

MOV AH, 4CH
INT 21H

MAIN ENDP
END MAIN