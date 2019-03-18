;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

ADCSSMUX3		EQU		0x400380a0
ADCACTSS		EQU		0x40038000
ADCPSSI			EQU		0x40038028
ADCRIS			EQU		0x40038004
ADCSSFIFO3		EQU		0x400380a8
ADCISC			EQU		0x4003800c
data_adr		EQU		0x20000000
	
			AREA	main, CODE, READONLY
			THUMB	
				
			EXPORT	__main
__main
			IMPORT	init_portE			;init portE(pe3)
			BL		init_portE
			IMPORT	init_adc			;init adc(adc0)
			BL		init_adc
			
			MOV		R2,#0x4D9			;0x4d9: 1241 = 4096/3.3
			MOV		R8,#0				;X 
			MOV		R9,#0				;Y
			MOV		R10,#0				;Z
			MOV		R6,#10				;multiplier 10
			
			MOV		R11,#0				;hold last outputted value
			
			LDR		R1,=data_adr
			MOV		R0,#0x2E			;ascii code of dot(.)
			STRB	R0,[R1,#1]
			MOV		R0,#0x0A			;ascii code of new line
			STRB	R0,[R1,#4]
			MOV		R0,#0x04			;ascii code of eot
			STRB	R0,[R1,#5]
			
			LDR		R1,=ADCACTSS
			LDR		R0,[R1]
			ORR		R0,#0x08			;enable ss3
			STR		R0,[R1]
		
			LDR		R1,=ADCPSSI
			LDR		R0,[R1]
			ORR		R0,#0x08			;initiate sampling for ss3
			STR		R0,[R1]	
	
check_adcris
			LDR		R1,=ADCRIS
			LDR		R0,[R1]
			AND		R0,#0x8
			CMP		R0,#0x8				;check if ss3 ris is set
			BNE		check_adcris		;if not set keep polling
			LDR		R1,=ADCSSFIFO3		;if set read the data from fifo
			LDR		R7,[R1]				;hold the data in R7
			
			;-----BCD conversion------
			UDIV	R8,R7,R2			;X = data / 1241
			MLS		R4,R8,R2,R7			;R4 = R7 - R8 * R2 (to find remaining part)
			MUL		R4,R6				;remaining * 10
			UDIV	R9,R4,R2			;Y = (remaining * 10)/1241
			MLS		R4,R9,R2,R4
			MUL		R4,R6
			UDIV	R10,R4,R2			;Z
			
			ADD		R8,#0x30			;ascii conversion of bcd numbers
			ADD		R9,#0x30
			ADD		R10,#0x30
			
			LDR		R1,=data_adr		;store the converted number in memory
			STRB	R8,[R1]
			STRB	R9,[R1,#2]
			STRB	R10,[R1,#3]
			;---------------------
			
			SUBS	R12,R11,R7			;R12 = R11 - R7
			RSBMI	R12,R12,#0			;take absolute value of difference
			CMP		R12,#0xF8			;compare it with 0.2V(0xF8: 248)
			BHS		out
			BLO		cont
out
			MOV		R11,R7				;assign last outputted value to the current read
			LDR		R5,=data_adr
			IMPORT	OutStr
			BL		OutStr
			
cont
			LDR		R1,=ADCISC
			LDR		R0,[R1]	
			ORR		R0,#0x08			;clear the ss3 interrupt flag 
			STR		R0,[R1]
			LDR		R1,=ADCPSSI
			LDR		R0,[R1]
			ORR		R0,#0x08			;initiate sampling for ss3
			STR		R0,[R1]	
			B		check_adcris
			
			ALIGN
			END
				