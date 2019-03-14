RCGCADC			EQU		0x400FE638
ADCPC			EQU		0x40038FC4
ADCACTSS		EQU		0x40038000
ADCEMUX			EQU		0x40038014
ADCSSCTL2		EQU		0x40038084
ADCSSMUX2		EQU		0x40038080
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
			
			LDR		R1,=ADCACTSS		;disable ADC SS2 to configure
			LDR		R0,[R1]
			BIC		R0,#0x04
			STR		R0,[R1]
			LDR		R1,=ADCEMUX		
			LDR		R0,[R1]
			BIC		R0,#0x0F00			;clear bit 11:8(ss2) to select triggering from main program
			STR		R0,[R1]
			LDR		R1,=ADCSSMUX2		;4 sample: ain1 - ain0 - ain1 - ain0
			LDR		R0,[R1]
			MOV		R0,#0x1010
			STR		R0,[R1]
			LDR		R1,=ADCSSCTL2		;set IEN1 and END1
			LDR		R0,[R1]
			ORR		R0,#0x60			;interrupt will be enabled after two channel is sampled.
			STR		R0,[R1]
			LDR		R1,=ADCPC			;set sampling speed to 125ksps
			LDR		R0,[R1]
			ORR		R0,#0x01
			STR		R0,[R1]
			
			BX		LR
			ENDP
			ALIGN
			END