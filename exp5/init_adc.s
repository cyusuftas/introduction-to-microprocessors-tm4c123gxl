RCGCADC			EQU		0x400FE638
ADCPC			EQU		0x40038FC4
ADCACTSS		EQU		0x40038000
ADCEMUX			EQU		0x40038014
ADCSSCTL3		EQU		0x400380a4
ADCSSMUX3		EQU		0x400380a0
PRADC			EQU		0x400fea38
	
	AREA 	initADC, CODE, READONLY
			THUMB
			
			EXPORT	init_adc
init_adc	PROC
			
			LDR		R1,=RCGCADC			
			LDR		R0,[R1]
			ORR		R0,#0x1			;enable clock for ADC0
			STR		R0,[R1]	
;			NOP						
;			NOP
;			NOP							;wait until ADC0 is ready
			LDR		R1,=PRADC
clock_ready
			LDR		R0,[R1]
			AND		R0,#1
			CMP		R0,#1
			BNE		clock_ready
			
			LDR		R1,=ADCACTSS		;disable ADC0 to configure
			LDR		R0,[R1]
			BIC		R0,#0x08
			STR		R0,[R1]
			LDR		R1,=ADCEMUX		
			LDR		R0,[R1]
			BIC		R0,#0xF000			;clear bit 15:12 to select triggering from main program
			STR		R0,[R1]
;			LDR		R1,=ADCSSMUX3		;ain0
;			LDR		R0,[R1]
;			BIC		R0,#0x0F
;			STR		R0,[R1]
			LDR		R1,=ADCSSCTL3		;set IEN0 and END0
			LDR		R0,[R1]
			ORR		R0,#0x06
			STR		R0,[R1]
			LDR		R1,=ADCPC			;set sampling speed to 125ksps
			LDR		R0,[R1]
			ORR		R0,#0x01
			STR		R0,[R1]
			
			BX		LR
			ENDP
			ALIGN
			END