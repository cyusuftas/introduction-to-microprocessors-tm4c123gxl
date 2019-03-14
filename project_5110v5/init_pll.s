;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

SYSCTL_RIS	EQU		0x400fe050
SYSCTL_RCC	EQU		0x400fe060
SYSCTL_RCC2	EQU		0x400fe070
	
			AREA initpll, CODE, READONLY
			THUMB
			
			EXPORT	init_pll
init_pll	PROC
			
			LDR		R1,=SYSCTL_RCC2
			LDR		R0,[R1]
			ORR		R0,#0x80000000				;configure the system to use rcc2 
			ORR		R0,#0x00000800				;bypass pll while initializing
			STR		R0,[R1]
			
			LDR		R1,=SYSCTL_RCC
			LDR		R0,[R1]
			BIC		R0,#0x7C0					;clear xtal field
			ORR		R0,#0x540					;configure for 16mhz crystal
			STR		R0,[R1]
			
			LDR		R1,=SYSCTL_RCC2
			LDR		R0,[R1]
			BIC		R0,#0x70					;clear oscillator source field
			ORR		R0,#0x0						;configure for main oscillator source
			
			BIC		R0,#0x2000					;activate pll by clearing pwrdwn
			ORR		R0,#0x40000000				;use 400mhz pll
			BIC		R0,#0x1FC00000				;clear sysdiv2 field
			ORR		R0,#0x01C00000				;set divisor to 8(sysdiv2: 7) for 50mhz
			STR		R0,[R1]
			
			LDR		R1,=SYSCTL_RIS
check_pll_ready
			LDR		R0,[R1]
			AND		R0,#0x40					;wait for pll to lock by checking pllris
			CMP		R0,#0x40
			BNE		check_pll_ready
			
			LDR		R1,=SYSCTL_RCC2
			LDR		R0,[R1]
			BIC		R0,#0x800
			STR		R0,[R1]
			
			BX		LR
			ENDP
			ALIGN
			END

			