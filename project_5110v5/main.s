;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

		AREA main, CODE, READONLY
		THUMB		

		EXPORT	__main
__main
;---------------initiations------------
;----LCD----
		IMPORT	init_pll
		BL		init_pll
		
		IMPORT	init_gpio
		BL		init_gpio			;init gpio A for spi pins(clk, mosi, ce) and lcd pins(reset, dc)
		
		IMPORT	init_spi
		BL		init_spi
		
		IMPORT	init_lcd
		BL		init_lcd			;set LCD Vop, temp coeff, bias and basic commands 
		
		IMPORT	clearLcdScreen
		BL		clearLcdScreen
		
		IMPORT	lcdWriteData
		IMPORT	lcdWriteCmd
		IMPORT 	setCursor
		IMPORT	lcdDrawCursor
		IMPORT	lcdDrawNum
		IMPORT	lcdDrawXY
		IMPORT	lcdDrawChar
		IMPORT	lcdDrawRemainingTime
		IMPORT	lcdDrawBattleship
		IMPORT	lcdDrawCivilianship
		IMPORT	lcdDrawShips
;----ADC----
		IMPORT	init_portE			;init portE(pe3 and pe2)
		BL		init_portE
		IMPORT	init_adc			;init adc for reading from two different potentiometers
		BL		init_adc
		
		IMPORT 	read_ADC			;readADC function returns sampled values of pe3 and pe2 analog inputs in R3 and R4
;---------------------------------
;----Buttons-----
		IMPORT	init_portF
		BL		init_portF
;----------------
;----Timers------
		IMPORT	init_timer_1
		BL 		init_timer_1
		IMPORT	init_timer_0
		BL		init_timer_0
;----------------
;----Helpers-----
		IMPORT	check_buttons
		IMPORT	sf
;----------------

		CPSIE	I					;enable interrupts
		
loop	
		BL		check_buttons
		BL		clearLcdScreen		;clear entire screen at the beginning of every loop
		PUSH	{R3,R4,R8,R9}
		BL		read_ADC
		MOV		R8,R3				;move returned values from read_ADC
		MOV		R9,R4				;so that draw functions can understand
		BL		lcdDrawXY
		BL		lcdDrawRemainingTime
		BL		lcdDrawCursor		;draw cursor at the position defined by ADC readings
		POP		{R3,R4,R8,R9}
		BL		lcdDrawShips
		B		loop
		
loop2
		BL		clearLcdScreen
		B		loop2
		
		ALIGN
		END