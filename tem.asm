;---------------------------------------------------
;       Templete File for MASM assembly project
;                    3-12-2021 
;				by: Mohammad Saleh
;---------------------------------------------------
.MODEL SMALL	; Memory configuation 
.STACK 100H		; Stack size 

.data			; Data section

str DB "1. Array Sorting ",10,13,"2. Word Counter",10,13,"3. Exit",13,10,13,10,"Enter your choice: $" 
str1 DB 10,13,"Enter the size of the array: $"
str2 DB 10,13,"Enter $"
str3 DB " elements: ",10,13,"$"
str4 DB "Array after sorting: ",10,13,"$"
str5 DB 10,13,"Enter a text: $"
str6 DB "Enter a ward: $"
str7 DB "Number of occurrences: $" 
ONE DB 31H
TWO DB 32H
TEN DB 10 
NUM DB 0H
REM DB 0H
NEWLINE DB 10,13,"$"
Array DB 99 DUP(0)
space DB " $"
SIZEA DB 0

arrayText DB 100 DUP(0)
arrayWard DB 100 DUP(0)

ctr1 DB 0
ctr2 DB 0
ctr3 DB 0
.code			; Code section

;--------------------------------------------------
; displaySpace function to print space on screen
;--------------------------------------------------
displaySpace PROC

LEA DX, space
MOV AH,09h
INT 21h

RET
displaySpace ENDP
;-------------------------------------
; end displaySpace function
;-------------------------------------

;------------------------------------------------------
; displayNewLine function to print new line on screen
;------------------------------------------------------
displayNewLine PROC

LEA DX, NEWLINE
MOV AH,09h
INT 21h

RET
displayNewLine ENDP
;-------------------------------------
; end displayNewLine function
;-------------------------------------

;----------------------------------------------------
; displayTwoNum function print number with two digits
;----------------------------------------------------
displayTwoNum PROC

MOV AH, 0H
MOV AL, NUM
DIV TEN
MOV DL, AL
MOV REM, AH
ADD DL, 30H
MOV AH, 02H
INT 21H
MOV DL, REM
ADD DL, 30H
MOV AH, 02H
INT 21H

RET
displayTwoNum ENDP
;-------------------------------------
; end displayTwoNum function
;-------------------------------------

;------------------------------------------------------------------
; readTwoNum function to read number with two digits from the user
;------------------------------------------------------------------
readTwoNum PROC

Mov AH, 01H
INT 21H
SUB AL, 30H
MUL TEN
ADD NUM, AL

Mov AH, 01H
INT 21H
SUB AL, 30H
ADD NUM, AL

RET
readTwoNum ENDP
;-------------------------------------
; end readTwoNum function
;-------------------------------------

;-----------------------------------------------
; menu function to print out menu on the screen
;-----------------------------------------------
menu PROC

LEA DX, str
MOV AH,09h
INT 21h

RET
menu ENDP
;-------------------------------------
; end menu function
;-------------------------------------

;-------------------------------------
; sort function to sort the array
;-------------------------------------
sort PROC

MOV CL, BL
MOV BH, 0H
MOV DX, BX
DEC DX
MOV CH, 0H
label2:	
		MOV SI, 0H
		label3: CMP DX, SI
				JE break
				MOV AL, Array[SI]
				INC SI 
				CMP AL, Array[SI]
				JBE continue
				MOV AH, Array[SI]
				MOV Array[SI], AL
				DEC SI
				MOV Array[SI], AH
				INC SI
				continue: JMP label3	
		break:	
		LOOP label2

RET
sort ENDP
;------------------------------------
; end sort function
;------------------------------------

;----------------------------------------------------
; readElements function to read the array's elements
;----------------------------------------------------
readElements PROC

MOV BL, NUM
MOV BH,0H
MOV CL, BL
MOV CH, 0H
MOV SI, 0H

label1: Mov NUM, 0H
		CALL readTwoNum
		CALL displaySpace
		MOV AL, NUM
		MOV Array[SI], AL
		INC SI
		LOOP label1

RET 
readElements ENDP

;--------------------------------------------------
; end readElements function
;--------------------------------------------------

;--------------------------------------------------------
; displayElements function to print the array's contents 
;--------------------------------------------------------
displayElements PROC

MOV CL, BL
MOV CH, 0H
MOV SI, 0H
label4: MOV AL, Array[SI]
		MOV NUM, AL
		CALL displayTwoNum
		CALL displaySpace
		INC SI
		LOOP label4  
		
RET
displayElements ENDP
;--------------------------------------------------
; end displayElements function
;--------------------------------------------------


;------------------------------------------------------
; sortArray function to handle the first part of menu
;-------------------------------------------------------
sortArray PROC

MOV NUM, 0H
LEA DX, str1
MOV AH,09h
INT 21h

CALL readTwoNum
CALL displayNewLine

LEA DX, str2
MOV AH,09h
INT 21h

CALL displayTwoNum

LEA DX, str3
MOV AH,09h
INT 21h

CALL readElements
CALL sort
CALL displayNewLine
CALL displayNewLine
CALL displayNewLine

LEA DX, str4
MOV AH,09h
INT 21h

CALL displayElements
CALL displayNewLine
CALL displayNewLine
CALL displayNewLine

RET
sortArray ENDP
;--------------------------------------------------
; end sortArray function
;--------------------------------------------------

;--------------------------------------------------
; readText function to read the text from the user
;--------------------------------------------------
readText PROC

MOV SI, 0H
MOV BL, 0H
a1: Mov AH, 01H
	INT 21H
	CMP AL, 13
	JE stop
	MOV arrayText[SI],AL
	INC SI
	INC BL
	JMP a1
stop:
MOV ctr1, BL
CALL displayNewLine

RET 
readText ENDP
;--------------------------------------------------
; end readText function
;--------------------------------------------------

;--------------------------------------------------
; readWord function to read the word from the user
;--------------------------------------------------
readWord PROC 

MOV SI, 0H
MOV BL, 0H
a2: Mov AH, 01H
	INT 21H
	CMP AL, 13
	JE stop1
	MOV arrayWard[SI],AL
	INC SI
	INC BL
	JMP a2
stop1:
MOV ctr2, BL

RET 
readWord ENDP
;--------------------------------------------------
; end readWord function
;--------------------------------------------------

;-------------------------------------------------------------------------------------
; findNumberOfOccurrenes function to find how many times the word repeated in the text
;-------------------------------------------------------------------------------------
findNumberOfOccurrenes PROC

MOV ctr3, 0H
MOV SI, 0H
MOV DI, 0H
MOV CL, ctr1
MOV CH, 0H
DEC ctr1
MOV BL, ctr2
DEC BL
MOV DL, 0H
find:	MOV AL, arrayWard[DI]
		CMP AL, arrayText[SI]
		JNE notEqual
		MOV AL, ctr1
		MOV AH, 0H
		CMP AX, SI
		JNE B1
		MOV BH, 0H
		CMP BX, DI
		JNE B1
		INC ctr3
		JMP B4
		B1: MOV AX, 0H
			CMP AX, DI
			JNE B5
			CMP DL, 0H
			JNE B4
			B5:	INC DI
				MOV DL, 1H
				JMP B2
		notEqual: 	MOV AL, 20H
					CMP AL, arrayText[SI]
					JNE B4
					MOV DL, 0H
					MOV AL, ctr2
					MOV AH, 0H
					CMP AX, DI
					JNE B3
					INC ctr3
					JMP B3
		B4: MOV DL, 1H
		B3: MOV DI, 0H
		B2: INC SI
		LOOP find
	  
RET
findNumberOfOccurrenes ENDP
;--------------------------------------------------
; end findNumberOfOccurrenes function
;--------------------------------------------------


;------------------------------------------------------
; counter function to handle the second part of menu
;-------------------------------------------------------
counter PROC

LEA DX, str5
MOV AH,09h
INT 21h

CALL readText

LEA DX, str6
MOV AH,09h
INT 21h	

CALL readWord 


CALL findNumberOfOccurrenes

LEA DX, str7
MOV AH,09h
INT 21h	

MOV AL, ctr3
MOV NUM, AL

CALL displayTwoNum
CALL displayNewLine
CALL displayNewLine

RET
counter ENDP
;------------------------------------------------------
; end counter function 
;-------------------------------------------------------

;--------------------------------------------------
; MAIN function
;--------------------------------------------------
MAIN PROC
MOV AX,@DATA	; Initialize DS by setting its address
MOV DS,AX

;Your code here


L1: CALL menu
	MOV AH,01h
	INT 21h
	MOV AH, ONE
	CMP AH, AL
	JE choice1
	MOV AH, TWO
	cmp AH, AL
	JE choice2
	JMP Exit
	

choice1: CALL sortArray
		 JMP L1	
choice2: CALL counter
		 JMP L1
Exit:
MOV AH,4CH	; End the program
INT 21H

MAIN ENDP
END MAIN
;--------------------------------------------------
; end MAIN function
;--------------------------------------------------