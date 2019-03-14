;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

GPIO_PORTA_DATA		EQU		0x400043FC
SSISR				EQU		0x4000800C
SSIDR				EQU		0x40008008

x_addr		EQU		0x80		;x6-x5-x4-x3-x2-x1-x0 (0<=x<=83)
y_addr		EQU		0x40		;y2-y1-y0 (0<=y<=5)
	
		AREA lcdfuncs, CODE, READONLY
		THUMB
		
		EXPORT	lcdWriteCmd
lcdWriteCmd PROC
		PUSH	{R0,R1}

		LDR		R1,=SSISR
check_busy
		LDR		R0,[R1]
		AND		R0,#0x10				;check if ssi0 is busy or not
		CMP		R0,#0x10
		BEQ		check_busy
		
		LDR		R1,=GPIO_PORTA_DATA
		LDR		R0,[R1]
		BIC		R0,#0x40				;command (pa6-> low)
		STR		R0,[R1]
		
		LDR		R1,=SSIDR
		MOV		R0,R5					;r5 is the argument whichs shows the command to be written
		STR		R0,[R1]
		
		LDR		R1,=SSISR
check_busy2
		LDR		R0,[R1]
		AND		R0,#0x10				;check if ssi0 is busy or not
		CMP		R0,#0x10
		BEQ		check_busy2
		
		POP		{R0,R1}
		BX		LR
		ENDP
		
		EXPORT	lcdWriteData
lcdWriteData PROC
		PUSH	{R0,R1}
		
		LDR		R1,=SSISR
wait_tnf		
		LDR		R0,[R1]
		AND		R0,#2
		CMP		R0,#2
		BNE		wait_tnf
		
		LDR		R1,=GPIO_PORTA_DATA
		LDR		R0,[R1]
		ORR		R0,#0x40				;dc-> high (data is going to be written)
		STR		R0,[R1]
		
		LDR		R1,=SSIDR
		MOV		R0,R5
		STR		R0,[R1]	
		
		POP		{R0,R1}
		BX		LR
		ENDP
			
		EXPORT	clearLcdScreen
clearLcdScreen PROC
		PUSH	{R2,R5,LR}
		MOV32	R2,#0x1F8				;84*6= 504 (0x1f8) clear all the pixels in screen by writing 0 to
		MOV		R5,#0x00				;all addressable bytes.
write	
		BL		lcdWriteData
		SUB		R2,#1
		CMP		R2,#0
		BNE		write
		
		POP		{R2,R5,LR}
		BX		LR
		ENDP
			
		EXPORT	setCursor
setCursor PROC
		PUSH 	{R0,LR}
		LDR		R5,=x_addr						;set cursor position
		ORR		R5,R6
		BL		lcdWriteCmd
		LDR		R5,=y_addr
		ORR		R5,R7
		BL		lcdWriteCmd
		POP		{R0,LR}
		BX		LR
		ENDP
			
		ALIGN
		END
		