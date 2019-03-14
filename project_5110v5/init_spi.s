;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

SYSCTL_RCGCSSI		EQU		0x400FE61C
SYSCTL_PRSSI		EQU		0x400FEA1C
SSICR0				EQU		0x40008000
SSICR1				EQU		0x40008004
SSICPSR				EQU		0x40008010
SSICC				EQU		0x40008FC8
	
		AREA initspi, CODE, READONLY
		THUMB
		
		EXPORT	init_spi
init_spi PROC
		PUSH	{R2}
		
		LDR		R1,=SYSCTL_RCGCSSI
		LDR     R0,[R1]
		ORR		R0,#1					;enable clock for ssi0
		STR		R0,[R1]
		
		LDR		R1,=SYSCTL_PRSSI
check
		LDR		R0,[R1]
		AND		R0,#1
		CMP		R0,#1
		BNE		check
		
		LDR		R1,=SSICR1				
		LDR		R0,[R1]
		BIC		R0,#2					;disable ssi0
		BIC		R0,#4					;master mode
		STR		R0,[R1]
		
		LDR		R1,=SSICC
		LDR		R0,[R1]
		BIC		R0,#0xF					;clock source: system clock
		STR		R0,[R1]
		
		
		LDR		R1,=SSICPSR
		MOV		R0,#16					;CPSR equals 16. Clock is divided by 16 -> 50/(16*(1+0)) = 3.3MHz
		STR		R0,[R1]	
		
		LDR		R1,=SSICR0
		LDR		R0,[R1]
		MOV32	R2,#0xFFF0
		BIC		R0,R2					;SCR equals 0, clock phase:first edge, clk is low when data is not transmitted
										;format:Freescale SPI
		ORR		R0,#0x07				;data size: 8 bit							 
		STR		R0,[R1]
		
		LDR		R1,=SSICR1
		LDR		R0,[R1]
		ORR		R0,#2					;enable ssi0
		STR		R0,[R1]	
		
		POP		{R2}
		BX		LR
		ENDP
			
		ALIGN
		END