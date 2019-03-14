;Cahit Yusuf Tas - 1934765
;cyusuftas@gmail.com 

		AREA my_data, DATA, READWRITE
		EXPORT	st
		EXPORT	ships
		EXPORT	mines
		EXPORT	sf
st		DCB		0x00											;holds the state
ships	DCB		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00	;holds the ship positions and number of ships: count,X1,Y1,X2,Y2,...
mines	DCB		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00	;holds the mine positions and number of mines: count,X1,Y1,X2,Y2,...
sf		DCB		0x00		
		END