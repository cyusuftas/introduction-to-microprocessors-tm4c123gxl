;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

GPIO_PORTA_DATA		EQU		0x400043FC
SSISR				EQU		0x4000800C
SSIDR				EQU		0x40008008
	
		AREA initlcd, CODE, READONLY
		THUMB
			
		EXPORT	init_lcd
init_lcd PROC
		PUSH	{LR}
		LDR		R1,=GPIO_PORTA_DATA
		LDR		R0,[R1]
		BIC		R0,#0x80				;reset(pa7) -> low
		STR		R0,[R1]
		
		;delay 100ns
		MOV		R0,#19
rst_delay
		SUB		R0,#1
		CMP		R0,#0
		BNE		rst_delay
		
		LDR		R1,=GPIO_PORTA_DATA
		LDR		R0,[R1]
		ORR		R0,#0x80				;reset(pa7) -> high
		STR		R0,[R1]
		
		MOV		R5,#0x21				;use extended commands
		IMPORT	lcdWriteCmd
		BL		lcdWriteCmd
		MOV		R5,#0xB8				;set LCD Vop
		BL		lcdWriteCmd
		MOV		R5,#0x04				;set temp coeff
		BL		lcdWriteCmd
		MOV		R5,#0x14				;set lcd bias
		BL		lcdWriteCmd
		MOV		R5,#0x20				;lcd basic commands
		BL		lcdWriteCmd
		MOV		R5,#0x0C				;all segments on
		BL		lcdWriteCmd	
		
		POP		{LR}
		BX		LR
		ENDP
			
		ALIGN
		END