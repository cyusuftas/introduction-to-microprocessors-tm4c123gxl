;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 
		AREA lcd_dfuncs, CODE, READONLY
		THUMB
			
		IMPORT	lcdWriteData
		IMPORT	setCursor
			
		EXPORT	lcdDrawCursor
lcdDrawCursor PROC					;it takes R8(x pos) and R9(y pos) as arguments
		PUSH	{R0,R2,R5,R6,R7,R8,R9,R10,R11,R12,LR}
		
		ADD		R8,#8				;offsets
		ADD		R9,#10
		
		
		MOV		R11,#8
		UDIV	R10,R9,R11			;R10 = R9/R11, R9-> y position (between 0 and 83)
		MLS		R12,R10,R11,R9		;R12 = R9 - R10*R11, remanent
		
		CMP		R12,#1
		BLO		draw_upper
		BEQ		draw_upper2
		BHI		cont
draw_upper
		MOV		R6,R8
		SUB		R7,R10,#1
		BL		setCursor
		MOV		R5,#0xC0
		BL		lcdWriteData
		B		cont
draw_upper2
		MOV		R6,R8
		SUB		R7,R10,#1
		BL		setCursor
		MOV		R5,#0x80
		BL		lcdWriteData
		B		cont
cont
		SUB		R6,R8,#2
		MOV		R7,R10
		BL		setCursor
		MOV		R0,#1
		LSL		R5,R0,R12
		BL		lcdWriteData
		BL		lcdWriteData
		MOV		R0,#4
		MOV		R5,#0x7c
		CMP		R12,R0
		SUBLS	R2,R0,R12
		LSRLS	R5,R2
		SUBHI	R2,R12,R0
		LSLHI	R5,R2
		AND		R5,#0xFF
		BL		lcdWriteData
		ADD		R6,R8,#1
		MOV		R7,R10
		BL		setCursor
		MOV		R0,#1
		LSL		R5,R0,R12
		BL		lcdWriteData
		BL		lcdWriteData
		CMP		R12,#6
		BEQ		draw_lower
		BHI		draw_lower1
		BLO		cont2
draw_lower
		MOV		R6,R8
		ADD		R7,R10,#1
		BL		setCursor
		MOV		R5,#0x01
		BL		lcdWriteData
		B		cont2
draw_lower1
		MOV		R6,R8
		ADD		R7,R10,#1
		BL		setCursor
		MOV		R5,#0x03
		BL		lcdWriteData
		;B		cont2
cont2
;		MOV		R5,#0xFF
;		BL		lcdWriteData
;		MOV		R5,#0xFF
;		BL		lcdWriteData
		POP 	{R0,R2,R5,R6,R7,R8,R9,R10,R11,R12,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawNum
lcdDrawNum PROC
		PUSH	{R0,R1,R2,LR}
		IMPORT	num_0
		LDR		R1,=num_0
		MOV		R0,#5
		MUL		R0,R5
		MOV		R2,#0
		BL		setCursor			;R6 and R7 is provided as inputs(X and Y address)
write_num
		LDRB	R5,[R1,R0]
		BL		lcdWriteData
		ADD		R0,#1
		ADD		R2,#1
		CMP		R2,#5
		BNE		write_num
		MOV		R2,#0
		
		POP		{R0,R1,R2,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawXY			;takes R8 and R9 as input parameter: X and Y addresses
lcdDrawXY PROC
		PUSH	{R0,R1,R5,R6,R7,R8,R9,R11,R12,LR}
		IMPORT	X
		IMPORT	Y
		IMPORT	colon
		LDR		R11,=X
		MOV		R6,#0				;set cursor to 0,0
		MOV		R7,#0
		BL		setCursor
		BL		lcdDrawChar
		LDR		R11,=colon
		MOV		R6,#5				;set cursor to 5,0
		MOV		R7,#0
		BL		setCursor
		BL		lcdDrawChar
		ADD		R8,#9
		ADD		R9,#11
		MOV		R0,#10
		UDIV	R1,R8,R0			
		MLS		R5,R1,R0,R8			;find digits
		MOV		R6,#15				;set where to print number
		MOV		R7,#0
		BL		lcdDrawNum
		UDIV	R12,R1,R0
		MLS		R5,R12,R0,R1
		MOV		R6,#10				;set where to print number
		MOV		R7,#0
		BL		lcdDrawNum
		
		LDR		R11,=Y
		MOV		R6,#35				;set cursor to 35,0
		MOV		R7,#0
		BL		setCursor
		BL		lcdDrawChar
		LDR		R11,=colon
		MOV		R6,#40				;set cursor to 50,0
		MOV		R7,#0
		BL		setCursor
		BL		lcdDrawChar
		UDIV	R1,R9,R0			
		MLS		R5,R1,R0,R9			;find digits
		MOV		R6,#50				;set where to print number
		MOV		R7,#0
		BL		lcdDrawNum
		UDIV	R12,R1,R0
		MLS		R5,R12,R0,R1
		MOV		R6,#45				;set where to print number
		MOV		R7,#0
		BL		lcdDrawNum
	
		POP		{R0,R1,R5,R6,R7,R8,R9,R11,R12,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawChar			;Expects the starting memory location of character as input in R11
lcdDrawChar	PROC
		PUSH	{R2,R5,LR}
		MOV		R2,#0
write_char
		LDRB	R5,[R11,R2]
		BL		lcdWriteData
		ADD		R2,#1
		CMP		R2,#5
		BNE		write_char
		MOV		R2,#0
		
		
		POP		{R2,R5,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawRemainingTime
lcdDrawRemainingTime PROC
		PUSH	{R0,R1,R2,R3,R4,R5,R6,R7,R12,LR}
		IMPORT	TIMER0_TAV
		LDR		R1,=TIMER0_TAV
		LDR		R0,[R1]
		MOV32	R3,#0x2FAF080
		MOV		R4,#10
		UDIV	R2,R0,R3
		UDIV	R0,R2,R4
		MLS		R5,R0,R4,R2
		MOV		R6,#78					;X 
		MOV		R7,#0					;Y
		BL		lcdDrawNum

		MOV		R5,R0
		MOV		R6,#72
		MOV		R7,#0
		BL		lcdDrawNum

		POP		{R0,R1,R2,R3,R4,R5,R6,R7,R12,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawBattleship					;R6:X address, R7:Y address. X,Y represents top left of the ship 
lcdDrawBattleship PROC
		PUSH	{R0,R1,R2,R3,R4,R5,R6,R7,LR}
		;MOV		R6,#23
		;MOV		R7,#27
		CMP		R6,#9
		BLO		ending
		CMP		R6,#68
		BHI		ending
		CMP		R7,#8
		BLO		ending
		CMP		R7,#40
		BHI		ending
		MOV		R0,#8
		UDIV	R1,R7,R0
		MLS		R2,R0,R1,R7
		MOV		R3,#0xFF
		MOV		R7,R1						;set Y address
		BL		setCursor
		CMP		R2,#0
		BEQ		draw_5
		SUB		R4,R0,R2
		LSL		R3,R2
		AND		R5,R3,#0xFF
		MOV		R0,#8
draw_1
		BL		lcdWriteData
		SUBS	R0,#1
		BNE		draw_1
		MOV		R0,#8
		
		ADD		R7,#1
		BL		setCursor
		MOV		R3,#0xFF
		LSR		R5,R3,R4
draw_2
		BL		lcdWriteData
		SUBS	R0,#1
		BNE		draw_2
		B		ending
draw_5
		MOV		R5,#0xFF
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
ending		
		POP		{R0,R1,R2,R3,R4,R5,R6,R7,LR}
		BX		LR
		ENDP
		
		EXPORT	lcdDrawCivilianship
lcdDrawCivilianship PROC
		PUSH	{R0,R1,R2,R3,R4,R5,R6,R7,LR}
		;MOV		R6,#12
		;MOV		R7,#28
		CMP		R6,#9
		BLO		ending2
		CMP		R6,#68
		BHI		ending2
		CMP		R7,#8
		BLO		ending2
		CMP		R7,#40
		BHI		ending2
		MOV		R0,#8
		UDIV	R1,R7,R0
		MLS		R2,R0,R1,R7
		MOV		R3,#0xaa
		MOV		R7,R1						;set Y address
		BL		setCursor
		CMP		R2,#0
		BEQ		draw_6
		SUB		R4,R0,R2
		LSL		R3,R2
		AND		R5,R3,#0xFF
		MOV		R0,#8
draw_3
		BL		lcdWriteData
		SUBS	R0,#1
		BNE		draw_3
		MOV		R0,#8
		
		ADD		R7,#1
		BL		setCursor
		MOV		R3,#0xaa
		LSR		R5,R3,R4
draw_4
		BL		lcdWriteData
		SUBS	R0,#1
		BNE		draw_4
		B		ending2
draw_6
		MOV		R5,#0xaa
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
		BL		lcdWriteData
ending2		
		POP		{R0,R1,R2,R3,R4,R5,R6,R7,LR}
		BX		LR
		ENDP
			
		EXPORT	lcdDrawShips
lcdDrawShips PROC
		PUSH	{R0,R1,R2,R3,R6,R7,LR}
		IMPORT	ships
		LDR		R1,=ships
		LDRB	R0,[R1]				;load number of ships
		MOV		R2,R0				;R2 holds the ship count
		ADD		R1,#1				;points to the first ship's X address
		
		CMP		R2,#0
		BEQ		ending3				;if ship count=0, quit without drawing anything

draw_ships					
		LDRB	R6,[R1],#1
		AND		R6,#0x7F			;delete the bit which represent the type of ship
		LDRB	R7,[R1],#-1			;R6 and R7 holds the X and Y pos. of the ship
		
		LDRB	R0,[R1]				;check type of the ship
		ANDS	R3,R0,#0x80
		BLEQ	lcdDrawCivilianship
		BLNE	lcdDrawBattleship
		
		SUBS	R2,#1
		ADDNE	R1,#2	
		BNE		draw_ships
		
ending3
		POP		{R0,R1,R2,R3,R6,R7,LR}
		BX		LR
		ENDP
			
		ALIGN
		END