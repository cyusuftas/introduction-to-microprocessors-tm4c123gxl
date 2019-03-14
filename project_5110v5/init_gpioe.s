;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

GPIO_PORTE_PCTL		EQU		0x4002452C
GPIO_PORTE_AMSEL	EQU		0x40024528
GPIO_PORTE_DIR		EQU		0x40024400
GPIO_PORTE_AFSEL	EQU		0x40024420
GPIO_PORTE_DEN		EQU		0x4002451C
SYSCTL_RCGCGPIO		EQU		0x400FE608

			AREA 	init_gpio, CODE, READONLY
			THUMB
			
			EXPORT	init_portE
init_portE	PROC
			LDR		R1,=SYSCTL_RCGCGPIO
			LDR		R0,[R1]
			ORR		R0,#0x10					;Enable GPIO clock for PortE
			STR		R0,[R1]
			NOP			
			NOP
			NOP									;wait for GPIO clock to stabilize
			
			LDR		R1,=GPIO_PORTE_AFSEL		;portE3(ain0) and pe2(ain1) will be used as input for adc
			LDR		R0,[R1]
			ORR		R0,R0,#0x0c					;choose alternative func for pe3 and pe2
			STR		R0,[R1]
			LDR		R1,=GPIO_PORTE_DIR			;config of PortE 
			LDR		R0,[R1]
			BIC		R0,#0x0c					;set PE3 and PE2 as input
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTE_DEN			;disable digital for pe3
			BIC		R0,#0x0c
			STR		R0,[R1]
			LDR		R1,=GPIO_PORTE_AMSEL
			MOV		R0,#0x0c					;enable analog for pe3
			STR		R0,[R1]
			
			BX		LR
			ENDP
			ALIGN
			END