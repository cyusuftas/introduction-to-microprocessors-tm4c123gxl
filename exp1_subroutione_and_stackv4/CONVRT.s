first 	EQU		0x20000000
;cnt 	EQU		0x0A
;cnt2	EQU		0x20
NUM		EQU		0x20000500
;value 	EQU		0x7FFFFFFF
;value 	EQU		0xF1135
		AREA	my_sr, CODE, READONLY
		THUMB
		EXPORT CONVRT
CONVRT	PROC
		LDR		R5,=NUM
		;LDR		R0,=first
		MOV		R1,#0
		MOV		R2,#0
		MOV		R10,#0			;clear virtual carry
		MOV		R8,R5
		ADD		R8,#10			;EOT address
fill	STRB	R1,[R0,R2]		;SPACE directives can be used
		ADDS	R2,#1
		CMP		R2,#0x0A
		BNE		fill
		MOV		R2,#0
		
l_shift
		MOV		R9,R4
		LSR		R9,#31
		MOV		R10,R9		;carry at r10
		LSL		R4,#1
lsl_mem
		LDRB	R6,[R0]
		BFC		R6,#4,#4
		LSL		R6,#1
		ADD		R6,R10
		;CMP		R6,#4
		;ADDHI	R6,#3
		AND		R11,R6,#0x0F
		STRB	R11,[R0]
		ADD		R0,#1
		ADD		R2,#1
		MOV		R7,R6
		LSR		R7,#4
		MOV		R10,R7
		CMP		R2,#10
		BNE		lsl_mem
		MOV		R2,#0
		LDR		R0,=first
		CMP		R3,#1
		MOVEQ	R1,#9
		BEQ		ascii
check
		LDRB	R6,[R0]
		ADD		R2,#1
		CMP		R6,#5
		ADDHS	R6,#3
		STRB	R6,[R0]
		ADD		R0,#1
		CMP		R2,#0x0A
		BNE		check
		LDR		R0,=first
		MOV		R2,#0
		SUBS	R3,#1
		MOVEQ	R1,#9
		BEQ		ascii
		BNE		l_shift
ascii	
		LDR		R0,=first
		;MOV		R1,#9			;holds counter
		MOV		R2,#0			;holds ascii equivalent
		LDRB	R3,[R0,R1]
		CMP		R3,#0
		MOVEQ	R2,#0x30
		CMP		R3,#1
		MOVEQ	R2,#0x31
		CMP		R3,#2
		MOVEQ	R2,#0x32
		CMP		R3,#3
		MOVEQ	R2,#0x33
		CMP		R3,#4
		MOVEQ	R2,#0x34
		CMP		R3,#5
		MOVEQ	R2,#0x35
		CMP		R3,#6
		MOVEQ	R2,#0x36
		CMP		R3,#7
		MOVEQ	R2,#0x37
		CMP		R3,#8
		MOVEQ	R2,#0x38
		CMP		R3,#9
		MOVEQ	R2,#0x39
		STRB	R2,[R5]
		;PUSH	{R5}
		ADD		R5,#1
		SUBS	R1,#1
		BPL		ascii
		MOV		R1,#0
		;POP		{R5}
		LDR		R5,=NUM
		MOV		R7,R5
		ADD		R7,#9
		;SUB		R5,#9
check_zeros
		LDRB	R0,[R5]
		CMP		R0,#0x30
		ADDEQ	R5,#1
		BNE		exit
		CMP		R5,R7
		BNE		check_zeros
		BEQ		exit
		
exit	
		MOV		R0,#0x04
		STRB	R0,[R8]
		BX		LR
		ENDP
		ALIGN
		END