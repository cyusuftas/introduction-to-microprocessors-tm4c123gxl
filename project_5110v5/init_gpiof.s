GPIO_PORTF_PCTL		EQU		0x4002552C
GPIO_PORTF_AMSEL	EQU		0x40025528
GPIO_PORTF_DIR		EQU		0x40025400
GPIO_PORTF_AFSEL	EQU		0x40025420
GPIO_PORTF_DEN		EQU		0x4002551C
GPIO_PORTF_PUR		EQU		0x40025510
GPIO_PORTF_LOCK		EQU		0x40025520
GPIO_PORTF_CR		EQU		0x40025524
	
GPIO_PORTF_DATA		EQU		0x400253fc

SYSCTL_RCGCGPIO		EQU		0x400FE608
	
			AREA 	init_gpiof, CODE, READONLY
			THUMB
				
			EXPORT	init_portF
init_portF	PROC
			LDR		R1,=SYSCTL_RCGCGPIO
			LDR		R0,[R1]
			ORR		R0,#0x20					;Enable GPIO clock for PortF
			STR		R0,[R1]
			NOP			
			NOP
			NOP									;wait for GPIO clock to stabilize
			
			LDR		R1,=GPIO_PORTF_DEN			;disable digital while configuring
			LDR		R0,[R1]
			BIC		R0,#0x1F
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_LOCK			;unlock portf
			MOV32	R0,#0x4c4f434b
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_CR
			LDR		R0,[R1]
			ORR		R0,#0x11					;set the value for PF4 and PF0 in commit register to use it as normal GPIO pin	
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_AFSEL
			LDR		R0,[R1]
			BIC		R0,#0x1F					;set pins as gpio. no alternate function
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_AMSEL
			LDR		R0,[R1]
			BIC		R0,#0x1F					;analog mode is disabled
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_DIR
			LDR		R0,[R1]
			BIC		R0,#0x11					;set pf4 and pf0 as inputs
			ORR		R0,#0xe						;set pf1-2-3 as outputs (rgb leds)
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_PUR
			LDR		R0,[R1]
			ORR		R0,#0x11					;set pullup for pf0 and pf4
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_DEN
			LDR		R0,[R1]
			ORR		R0,#0x1F					;enable digital for portf pins
			STR		R0,[R1]
			
			LDR		R1,=GPIO_PORTF_DATA
			LDR		R0,[R1]
			ORR		R0,#0x2
			STR		R0,[R1]
			
			BX		LR
			ENDP
			
			ALIGN
			END
			
			
			
			