;		LDR		R4,=value
;		LDR		R0,=first
;		MOV		R2,#0
;		LDR		R8,=cnt
;		LDR		R3,=cnt2
;		MOV		R1,#0			;initial set
;		MOV		R10,#0			;carry
;		MOV		R9,#0
;fill	STRB	R1,[R0,R2]		;SPACE directives can be used
;		ADDS	R2,#1
;		CMP		R2,#0x0A
;		BNE		fill
;		MOV		R2,#0
;		
;l_shift
;		MOV		R9,R4
;		LSR		R9,#31
;		MOV		R10,R9		;carry at r10
;		LSL		R4,#1
;lsl_mem
;		LDRB	R6,[R0]
;		BFC		R6,#4,#4
;		LSL		R6,#1
;		ADD		R6,R10
;		;CMP		R6,#4
;		;ADDHI	R6,#3
;		AND		R11,R6,#0x0F
;		STRB	R11,[R0]
;		ADD		R0,#1
;		ADD		R2,#1
;		MOV		R7,R6
;		LSR		R7,#4
;		MOV		R10,R7
;		CMP		R2,#10
;		BNE		lsl_mem
;		MOV		R2,#0
;		LDR		R0,=first
;		CMP		R3,#1
;		BEQ		loop
;check
;		LDRB	R6,[R0]
;		ADD		R2,#1
;		CMP		R6,#5
;		ADDHS	R6,#3
;		STRB	R6,[R0]
;		ADD		R0,#1
;		CMP		R2,#0x0A
;		BNE		check
;		LDR		R0,=first
;		MOV		R2,#0
;		SUBS	R3,#1
;		BEQ		loop
;		BNE		l_shift

;check
;		LDR		R6,[R0]
;		ADD		R2,#1
;		CMP		R6,#4
;		ADDHS	R6,#3
;		STR		R6,[R0]
;		ADD		R0,#1
;		CMP		R2,#9
;		BNE		check
;		BX		LR