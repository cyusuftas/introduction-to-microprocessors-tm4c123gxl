;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

GPIO_PORTA_PCTL		EQU		0x4000452C
GPIO_PORTA_AMSEL	EQU		0x40004528
GPIO_PORTA_DIR		EQU		0x40004400
GPIO_PORTA_PUR		EQU		0x40004510
GPIO_PORTA_AFSEL	EQU		0x40004420
GPIO_PORTA_DEN		EQU		0x4000451C

SYSCTL_RCGCGPIO		EQU		0x400FE608
PRGPIO				EQU		0x400FEA08
	
		AREA initgpio, CODE, READONLY
		THUMB
		
		EXPORT init_gpio
init_gpio PROC
		PUSH	{R2}
		LDR		R1,=SYSCTL_RCGCGPIO
		LDR		R0,[R1]
		ORR		R0,#0x01					;Enable GPIO clock for PortA	
		STR		R0,[R1]
		
		LDR		R1,=PRGPIO
check
		LDR		R0,[R1]
		AND		R0,#1
		CMP		R0,#1
		BNE		check
		
		LDR		R1,=GPIO_PORTA_DIR			;config of PortA 
		LDR		R0,[R1]
		ORR		R0,#0xC0					;set pa7 and pa6 as output pins
		STR		R0,[R1]
;		LDR		R1,=GPIO_PORTA_PUR
;		LDR		R0,[R1]
;		ORR		R0,#4						;pa2(ssi0 clk) is set high when it is not driven
;		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_AFSEL		;portB will be used for digital operations
		LDR		R0,[R1]
		ORR		R0,R0,#0x2C					;choose alternative func for pa5,3,2
		BIC		R0,#0xC0					;disable alternative func. for pa6 and pa7
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_PCTL
		LDR		R0,[R1]
		MOV32	R2,#0x00202200
		ORR		R0,R0,R2					;pa5: ssi0 tx, pa3: ssi0 fss, pa2: ssi0 clk 
		BIC		R0,#0xFF000000
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_AMSEL
		LDR		R0,[R1]						;disable analog for pa5,pa3,pa2,pa6,pa7
		BIC		R0,#0xEC					
		STR		R0,[R1]
		LDR		R1,=GPIO_PORTA_DEN			;enable port
		LDR		R0,[R1]
		ORR		R0,#0xEC
		STR		R0,[R1]
		
		POP		{R2}
		BX		LR
		
		ENDP
		ALIGN
		END