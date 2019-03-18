		MOV 	R1, #5
		BL		my_subroutine
		MOV		R1, #6
		MOV		R2, #3
		MOV		R1, #7
		B		loop
		
		EXPORT	my_subroutine
my_subroutine\
		PROC
		;PUSH	{R1, R2}
		PUSH	{LR}
		MOV		R2, #0
		ADD		R2, #1
		IMPORT	another_subroutine
		BL		another_subroutine
		MOV32 	R1, #0x20000000
		STR		R2, [R1]
		;POP		{R1, R2}
		POP		{LR}
		BX		LR
		ENDP


