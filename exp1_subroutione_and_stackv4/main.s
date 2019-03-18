;Cahit Yusuf Tas - 1937465
;07.11.2018

first 	EQU		0x20000000
my_data	EQU		0x20000600
n		EQU		0x20000700
cnt 	EQU		0x0A
cnt2	EQU		0x20
;value 	EQU		0x19231993
NUM		EQU		0x20000500
	
		AREA	my_program, CODE, READONLY
		THUMB
		EXPORT __main
__main
		;MOV		R7,#0
loop1	
		LDR		R0,=first		;initializations for CONVRT module
		MOV		R2,#0			
		LDR		R8,=cnt
		LDR		R3,=cnt2
		LDR		R5,=NUM			;NUM holds the starting memory address
		MOV		R12,#0
		MOV		R10,#0
		
inf_loop						;wait for user input in an infinite loop
		PUSH	{R5}			;don't lose the value at r5 since InChar uses it.
		IMPORT	InChar
		BL		InChar
		LDR		R11,=n
		STRB	R5,[R11,R10]	;store received values at memory
		ADD		R10,#1
		ADD		R12,#1			;increment counter
		POP		{R5}
		CMP		R12,#3			;check if enough character(s) received: I assumed user would give 3 digit input i.e if it is 51 it must be given as 051
		BNE		inf_loop
		B 		cont
		
loop	B		loop

cont
		LDR		R10,=n
		LDRB	R9,[R10]		;100's -> Most significant digit
		LDRB	R11,[R10,#1]	;10's  -> 2nd digit
		LDRB	R12,[R10,#2]	;1's   -> Least significant digit
cmp_n1							
		CMP		R9,#0x30		;compare R9 with Ascii values
		MOVEQ	R9,#0			;set R9 to actual value if it matches with Ascii value.
		CMP		R9,#0x31		;this process is repeated too much it can be a subroutine. open to development
		MOVEQ	R9,#1
		CMP		R9,#0x32
		MOVEQ	R9,#2
		CMP		R9,#0x33
		MOVEQ	R9,#3
		CMP		R9,#0x34
		MOVEQ	R9,#4
		CMP		R9,#0x35
		MOVEQ	R9,#5
		CMP		R9,#0x36
		MOVEQ	R9,#6
		CMP		R9,#0x37
		MOVEQ	R9,#7
		CMP		R9,#0x38
		MOVEQ	R9,#8
		CMP		R9,#0x39
		MOVEQ	R9,#9
		CMP		R11,#0x30		;compare R11 with Ascii values
		MOVEQ	R11,#0			;set R11 to actual value if it matches with Ascii value.
		CMP		R11,#0x31
		MOVEQ	R11,#1
		CMP		R11,#0x32
		MOVEQ	R11,#2
		CMP		R11,#0x33
		MOVEQ	R11,#3
		CMP		R11,#0x34
		MOVEQ	R11,#4
		CMP		R11,#0x35
		MOVEQ	R11,#5
		CMP		R11,#0x36
		MOVEQ	R11,#6
		CMP		R11,#0x37
		MOVEQ	R11,#7
		CMP		R11,#0x38
		MOVEQ	R11,#8
		CMP		R11,#0x39
		MOVEQ	R11,#9
		CMP		R12,#0x30		;apply same checks for least significant digit
		MOVEQ	R12,#0			;set actual value of least significant digit if it matches it's Ascii value 
		CMP		R12,#0x31
		MOVEQ	R12,#1
		CMP		R12,#0x32
		MOVEQ	R12,#2
		CMP		R12,#0x33
		MOVEQ	R12,#3
		CMP		R12,#0x34
		MOVEQ	R12,#4
		CMP		R12,#0x35
		MOVEQ	R12,#5
		CMP		R12,#0x36
		MOVEQ	R12,#6
		CMP		R12,#0x37
		MOVEQ	R12,#7
		CMP		R12,#0x38
		MOVEQ	R12,#8
		CMP		R12,#0x39
		MOVEQ	R12,#9
		ADD		R6,R9,LSL #2		;multiply can be done by using LSL with desired amount 
		ADD		R6,R9,LSL #5
		ADD		R6,R9,LSL #6		;R6 = 100*R9
		ADD		R6,R11,LSL #1		;
		ADD		R6,R11,LSL #3		;R6 = 100*R9 + 10*R11
		MOV		R11,R6				
		ADD		R11,R12				;R6 = 100*R9 + 10*R11 + R12
		MOV		R12,#0				;At the end R11 holds the result of user input in hex
		MOV		R2,R11				;R2 holds the minimum value
									;Set minimum value as given number of soulstones initially

		BL		recursive
		B		conv
;RECURSIVE PART OF CODE
recursive
		PUSH	{LR,R1}				;Push eligibiliy register(R1) and Link Register to stack.
		CMP		R11,#0				
		MOVEQ	R2,#0
		BEQ		cont1
									
									;R11 holds the remaining number of souls or a given number of souls if it is for the first time
		MOV		R1,#0				;R1 holds portal entry eligibility ->	1001:9 -> means it can go through portals 1 and 4 but not 2 and 3.
		
									;Portal 4 checks
		MOV		R12,#21				;check if its divisible with 21
		UDIV	R10,R11,R12			;R10=R11/R12	
		MLS		R9,R10,R12,R11		;R9=R11-R10*R12
		CMP		R9,#0				;Compare remaining is 0 or not
		ADDEQ	R1,#8				;Set 4th LSB to 1 to indicate Portal 4 is available to enter for a given number of soulstones or remaining soulstones
		PUSHEQ	{R11}				;Don't lose the number of soulstones.
		SUBEQ	R11,R11				;If you enter portal 4 you spend all of the soulstones
		BLEQ	recursive			;Enter from the portal
		
		CMP		R11,#99				;Portal 1 checks
		ADDHI	R1,#1				;Set LSB to 1 to indicate Portal 1 is available.
		PUSHHI	{R11}
		SUBHI	R11,#47				;spend 47 soulstones
		BLHI	recursive			;Enter portal
		
									;Portal 3 checks
		MOV		R12,#2				;Set dividing part
		UDIV	R10,R11,R12
		MLS		R9,R10,R12,R11
		CMP		R9,#0				;Check if remaining is 0 meaning it is even or not
		ADDEQ	R1,#4				;Set 3th LSB of eligibility register to indicate 3rd portal is available
		PUSHEQ	{R11}
		LSREQ	R11,#1				;spend half of soulstones
		BLEQ	recursive			;enter portal
		
									;Portal 2 checks
		MOV		R12,#2
		UDIV	R10,R11,R12
		MLS		R9,R10,R12,R11
		CMP		R9,#1				;Check if it is odd or not
		ADDEQ	R1,#2				;If it is odd set eligibility bit of Portal 2
		BEQ		check_50			;if it is odd check if it is greater than 50 or not
		BNE		cont2
check_50
		CMP		R11,#50
		SUBMI	R1,#2				;if it is not greater than 50 take back 2 added
		PUSHHI	{R11}				;if it passes all checks get the product of digits.
		BLHI	get_product
		BLLS	cont2				;otherwise continue
get_product
		PUSH	{R0,R1,R2,R3}		;since CONVRT subroutine is used, dont lose register values
		MOV		R4,R11				;give total number of soulstones available as input to CONVRT subroutine using R4
		PUSH	{R11}
		IMPORT	CONVRT				;CONVRT subroutine is used in order to convert binary value to ascii value of corresponding digits.
		BL		CONVRT
		POP		{R11}
		MOV		R3,#1				;hold the result of digit product
digit_product
		LDRB	R1,[R5]				;Load one digit and check next digit
		LDRB	R2,[R5,#1]			
		ADD		R5,#1				;Corresponding values of Ascii represented digits are assigned
		CMP		R1,#0x30
		MOVEQ	R1,#1
		CMP		R1,#0x31
		MOVEQ	R1,#1
		CMP		R1,#0x32
		MOVEQ	R1,#2
		CMP		R1,#0x33
		MOVEQ	R1,#3
		CMP		R1,#0x34
		MOVEQ	R1,#4
		CMP		R1,#0x35
		MOVEQ	R1,#5
		CMP		R1,#0x36
		MOVEQ	R1,#6
		CMP		R1,#0x37
		MOVEQ	R1,#7
		CMP		R1,#0x38
		MOVEQ	R1,#8
		CMP		R1,#0x39
		MOVEQ	R1,#9
		MUL		R3,R1					;digits are multiplied in here
		CMP		R2,#0x04				;check if next digit is string null
		BNE		digit_product			;loop until end of digits
		SUB		R11,R3					;R11 = R11 - R3  -> R3 holds the product of digits
		;SUB		R11,#5				;multiply of its digits will be subtracted. its equal to 5 for testing purposes.
		POP		{R0,R1,R2,R3}			;release back R0-R3
		BL		recursive				;enter portal
cont2		
		CMP		R1,#0					;check if any portal is available or not by controlling eligibility register(R1) 
		BEQ		set_min					;if there is no available portal go to set_min					
		BNE		cont1					;program reaches to cont1 when all availaable portals are visited for a given number of soulstones
set_min
		CMP		R11,R2					;check if remaining number of soulstones are less than previous minimum value
		MOVLO	R2,R11					;assign remaining number of soulstones as new minimum value
cont1
		POP		{R1,LR}					;release registers
		POP		{R11}
		BX		LR

conv	
		MOV		R4,R2				;move minimum value to R4 since CONVRT takes R4 as an argument to convert it to decimal
		IMPORT	CONVRT
		BL		CONVRT				;Convert the minimum value in binary to corresponding Ascii representation for each decimal digit. 
		IMPORT	OutStr					
		BL		OutStr				;takes r5 as an argument to point the start of memory location holding decimal digits 
		B		loop1				;Go back to way up and wait for next input from user.

		ALIGN
		END