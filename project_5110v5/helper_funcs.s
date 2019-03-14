;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

GPIO_PORTF_DATA		EQU		0x400253fc	
	
		AREA helperfuncs, CODE, READONLY
		THUMB
			
		EXPORT 	delay_20ms
delay_20ms PROC
		MOV32	R5,#0xF4240

delay	SUBS	R5,#1						;it takes R5 as counter argument					
		BPL		delay
		
		BX		LR
		ENDP
			
		EXPORT	check_buttons
check_buttons PROC
		PUSH	{LR}
		LDR		R1,=GPIO_PORTF_DATA
		LDR		R2,[R1]
check
		MOV		R0,R2
		BL		delay_20ms
		LDR		R2,[R1]
		CMP		R2,R0
		BNE		check				;if two successive readings are not the same, wait for it to stabilize
		AND		R2,#0x11
		CMP		R2,#0x11
		BEQ		check_two
		BNE		set_func
check_two
		CMP 	R6,#1
		BEQ		set
		BNE		cont
set_func
		CMP		R6,#1
		BEQ		cont
		MOVNE	R8,R2
		MOVNE	R6,#1
		BNE		cont
set	
		MOV		R6,#0
		CMP		R8,#0x10
		BLEQ	sw2_handler
		CMP		R8,#0x01
		BLEQ	sw1_handler
cont
		POP		{LR}
		BX		LR
		ENDP
		
		EXPORT	sw1_handler
sw1_handler PROC
		PUSH	{R0,R1,R2,R3,R4,R5,R6,R7,R8,LR}
		IMPORT	st							;import state variable
		IMPORT	ships
		IMPORT	mines
		LDR		R1,=st
		LDRB	R0,[R1]
		CMP		R0,#0x00
		BEQ		place_battleship_state
		CMP		R0,#0x01
		BEQ		clear_screen_state
		CMP		R0,#0x03
		BEQ		place_mine_state
		B		ending

place_battleship_state
		IMPORT	read_ADC
		BL		read_ADC				;read X and Y pos.
		MOV		R6,R3
		MOV		R7,R4
		ADD		R6,#8
		ADD		R7,#10
		
		LDR		R1,=ships
		LDRB	R0,[R1]					;load ship count
		LSL		R2,R0,#1
		ADD		R0,#1
		MOV		R3,R0
		STRB	R0,[R1]
		ADD		R2,#1
		ADD		R1,R2
		
		ORR		R6,#0x80			;define ship type as battleship->MSB=1
		STRB	R6,[R1],#1		
		STRB	R7,[R1]
		
		CMP		R3,#4
		LDREQ	R1,=st
		MOVEQ	R0,#0x01
		STRBEQ	R0,[R1]
		
		LDR		R1,=GPIO_PORTF_DATA
		LDR		R0,[R1]
		ORR		R0,#0x8
		STR		R0,[R1]
		
		B		ending

clear_screen_state
		IMPORT	sf
		LDR		R1,=sf
		MOV		R0,#0x01
		STRB	R0,[R1]
		B 		ending

place_mine_state



ending
		
		POP		{R0,R1,R2,R3,R4,R5,R6,R7,R8,LR}
		BX		LR
		ENDP
			
		EXPORT	sw2_handler
sw2_handler PROC
		PUSH	{R0,R1,R2,R3,R4,R5,R6,R7,R8,LR}
		IMPORT	st							;import state variable
		IMPORT	ships
		IMPORT	mines
		LDR		R1,=st
		LDRB	R0,[R1]
		CMP		R0,#0x00
		BEQ		place_civilianship_state
		CMP		R0,#0x02
		BEQ		flash_screen_state
		B		ending2
		
place_civilianship_state
		IMPORT	read_ADC
		BL		read_ADC				;read X and Y pos.
		MOV		R6,R3					;move output of adc
		MOV		R7,R4
		ADD		R6,#8					;add offsets
		ADD		R7,#10
		
		LDR		R1,=ships
		LDRB	R0,[R1]					;load ship count
		LSL		R2,R0,#1
		ADD		R0,#1
		MOV		R3,R0
		STRB	R0,[R1]					;update ship count
		ADD		R2,#1
		ADD		R1,R2
		
		BIC		R6,#0x80				;define ship type as civilianship-> MSB=0
		STRB	R6,[R1],#1
		STRB	R7,[R1]
		
		CMP		R3,#4
		LDREQ	R1,=st
		MOVEQ	R0,#0x01
		STRBEQ	R0,[R1]
		
		LDR		R1,=GPIO_PORTF_DATA
		LDR		R0,[R1]
		BIC		R0,#0x8
		STR		R0,[R1]
		
		B 		ending2

flash_screen_state
		
	
ending2				
		POP		{R0,R1,R2,R3,R4,R5,R6,R7,R8,LR}
		BX		LR
		ENDP
		
		ALIGN
		END