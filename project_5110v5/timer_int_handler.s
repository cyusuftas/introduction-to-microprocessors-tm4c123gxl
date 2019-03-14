GPIO_PORTF_DATA		EQU		0x400253fc
TIMER1_ICR			EQU 	0x40031024
TIMER0_ICR			EQU 	0x40030024
TIMER1_CTL			EQU 	0x4003100C
TIMER1_TAV			EQU 	0x40031050
TIMER0_CTL			EQU 	0x4003000C
TIMER0_TAV			EQU 	0x40030050

		EXPORT	TIMER0_TAV
		EXPORT	TIMER1_TAV

		AREA timer_inthandler, CODE, READONLY
		THUMB
			
		EXPORT	My_Timer1A_Handler
My_Timer1A_Handler PROC
		LDR		R1,=GPIO_PORTF_DATA
		LDR		R0,[R1]
		ORR		R0,#0x2
		STR		R0,[R1]
			
		LDR		R1,=TIMER1_ICR
		LDR		R0,[R1]
		ORR		R0,#0x1
		STR		R0,[R1]
		
		LDR		R1,=TIMER0_CTL
		LDR		R0,[R1]
		ORR		R0,#0x1				;enable timer1 A (32 bit mode)
		STR		R0,[R1]
			
		BX		LR
		ENDP
			
		EXPORT My_Timer0A_Handler
My_Timer0A_Handler PROC
		LDR		R1,=GPIO_PORTF_DATA
		LDR		R0,[R1]
		BIC		R0,#0x2
		STR		R0,[R1]
		
		LDR		R1,=TIMER0_ICR
		LDR		R0,[R1]
		ORR		R0,#0x1
		STR		R0,[R1]	
		
		LDR		R1,=TIMER1_CTL
		LDR		R0,[R1]
		ORR		R0,#0x1				;enable timer1 A (32 bit mode)
		STR		R0,[R1]
		
		BX		LR
		ENDP
			
		ALIGN
		END