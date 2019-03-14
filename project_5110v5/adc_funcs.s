;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

ADCACTSS		EQU		0x40038000
ADCSSCTL2		EQU		0x40038084
ADCSSMUX2		EQU		0x40038080	
ADCPSSI			EQU		0x40038028
ADCRIS			EQU		0x40038004
ADCSSFIFO2		EQU		0x40038088
ADCISC			EQU		0x4003800c

		AREA adcfuncs, CODE, READONLY
		THUMB
		
		EXPORT	read_ADC
read_ADC PROC
		PUSH	{R0,R1,LR}
		LDR		R1,=ADCACTSS
		LDR		R0,[R1]
		ORR		R0,#0x04			;enable ss2
		STR		R0,[R1]
	
		LDR		R1,=ADCPSSI
		LDR		R0,[R1]
		ORR		R0,#0x04			;initiate sampling for ss2
		STR		R0,[R1]	
	
check_adcris
		LDR		R1,=ADCRIS
		LDR		R0,[R1]
		AND		R0,#0x4
		CMP		R0,#0x4				;check if ss3 ris is set
		BNE		check_adcris		;if not set keep polling
		LDR		R1,=ADCSSFIFO2		;if set read the data from fifo
		LDR		R3,[R1]				;sample 0 -> ain0(pe3)
		LDR		R4,[R1]				;sample 1 -> ain1(pe2)
		
		MOV		R0,#69				;4096/69 = 59
		UDIV	R3,R0		
		MOV		R0,#151				;4096/151 = 27
		UDIV	R4,R0				;return mapped values in R3 and R4
		
		LDR		R1,=ADCISC
		LDR		R0,[R1]	
		ORR		R0,#0x04			;clear the ss2 interrupt flag 
		STR		R0,[R1]
		
		POP		{R0,R1,LR}
		BX		LR
		ENDP
			
		ALIGN
		END