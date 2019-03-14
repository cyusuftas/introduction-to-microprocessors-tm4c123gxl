TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_IMR			EQU 0x40031018
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_TAPR			EQU 0x40031038
TIMER1_TAR			EQU	0x40031048 ; Timer register
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval


	
NVIC_Timer			EQU	0xE000E100

			AREA timer_init, CODE, READONLY
			THUMB
			
			EXPORT	init_timer_1
init_timer_1 PROC
			PUSH	{R2}
			LDR 	R1,=SYSCTL_RCGCTIMER 	;Start clock for Timer1
			LDR 	R0,[R1]
			ORR 	R0,#0x02
			STR 	R0,[R1]
			NOP 						;allow clock to settle
			NOP
			NOP
			NOP
			
			LDR		R1,=TIMER1_CTL
			LDR		R0,[R1]
			MOV		R2,#0x101
			BIC		R0,R2				;disable timer A and B while configuring
			STR		R0,[R1]
			
			LDR		R1,=TIMER1_CFG
			LDR		R0,[R1]
			BIC		R0,#0x7				;set cfg to 0x0 so it is a 32 bit timer
			STR		R0,[R1]
			
			LDR		R1,=TIMER1_TAMR
			LDR		R0,[R1]
			BIC		R0,#0x2				;set TAMR to 0x1 (one shot)
			ORR		R0,#0x1
			BIC		R0,#0x10			;count down
			STR		R0,[R1]
			
			LDR		R1,=TIMER1_TAILR
			MOV32	R0,#0x4190AB00		;set timer's starting value
			STR		R0,[R1]
			
			LDR		R1,=TIMER1_ICR
			LDR		R0,[R1]
			ORR		R0,R2				;clear TATO and TBTO interrupts
			STR		R0,[R1]		
			
			LDR		R1,=TIMER1_IMR
			LDR		R0,[R1]
			ORR		R0,#0x1				;TATO interrupt is enabled
			STR		R0,[R1]
			
			LDR		R1,=NVIC_Timer
			LDR		R0,[R1]
			MOV32	R2,#0x00200000		;Enable Timer1A_Handler
			ORR		R0,R2
			STR		R0,[R1]
			
;			LDR		R1,=TIMER1_CTL
;			LDR		R0,[R1]
;			ORR		R0,#0x1				;enable timer A (32 bit mode)
;			STR		R0,[R1]
			
			POP		{R2}
			BX		LR
			ENDP
				
			EXPORT	init_timer_0
init_timer_0 PROC
			PUSH	{R2}
			LDR 	R1,=SYSCTL_RCGCTIMER 	;Start clock for Timer0
			LDR 	R0,[R1]
			ORR 	R0,#0x01
			STR 	R0,[R1]
			NOP 						;allow clock to settle
			NOP
			NOP
			NOP
			
			LDR		R1,=TIMER0_CTL
			LDR		R0,[R1]
			MOV		R2,#0x101
			BIC		R0,R2				;disable timer A and B while configuring
			STR		R0,[R1]
			
			LDR		R1,=TIMER0_CFG
			LDR		R0,[R1]
			BIC		R0,#0x7				;set cfg to 0x0 so it is a 32 bit timer
			STR		R0,[R1]
			
			LDR		R1,=TIMER0_TAMR
			LDR		R0,[R1]
			BIC		R0,#0x2				;set TAMR to 0x1 (one shot)
			ORR		R0,#0x1
			BIC		R0,#0x10			;count down
			STR		R0,[R1]
			
			LDR		R1,=TIMER0_TAILR
			MOV32	R0,#0x4190AB00		;set timer's starting value
			STR		R0,[R1]
			
			LDR		R1,=TIMER0_ICR
			LDR		R0,[R1]
			ORR		R0,R2				;clear TATO and TBTO interrupts
			STR		R0,[R1]		
			
			LDR		R1,=TIMER0_IMR
			LDR		R0,[R1]
			ORR		R0,#0x1				;TATO interrupt is enabled
			STR		R0,[R1]
			
			LDR		R1,=NVIC_Timer
			LDR		R0,[R1]
			MOV32	R2,#0x00080000		;Enable Timer0A_Handler
			ORR		R0,R2
			STR		R0,[R1]
			
			LDR		R1,=TIMER0_CTL
			LDR		R0,[R1]
			ORR		R0,#0x3				;enable timer A (32 bit mode)
			STR		R0,[R1]
			
			POP		{R2}
			BX		LR
			ENDP
				
			ALIGN
			END			