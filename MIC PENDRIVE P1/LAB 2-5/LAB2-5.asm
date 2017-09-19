RESET		EQU		00H										;in�cio do programa em 0h
DADOS   	EQU		60H										;salva o vetor de dados em 60h
	
			ORG		RESET									;come�a o programa em 0h

INICIO:		MOV		R3,#00H									;parcela a ser gravada em 2100h
			MOV		DPTR,#TABELA							;p�e endere�o da tabela no dptr
		
			MOV		P2,#21H									;MSB do endere�o da mem�ria externa para salvar os n�meros
			MOV		R1,#00H									;LSB do endere�o da mem�ria externa para salvar os n�meros
		
VOLTA: 	 	MOV		A,R3									;p�e em A a atual parcela a ser salva
			MOVC	A,@A+DPTR								;l� a parcela em quest�o
			MOVX	@R1,A									;salva no endere�o de mem�ria externa
			INC 		R1									;incrementa R1, define pr�ximo endere�o de mem�ria externa
			INC		R3										;incrementa R3, atual parcela
			CJNE		R1,#0FH,VOLTA						;verifica se as 16 parcelas j� n�o foram salvas
				
			MOV		R1,#00H									;limpa o LSB do endere�o da mem�ria externa para lidar

COPIA:		MOV		P2,#21H									;MSB do endere�o da mem�ria externa para copiar os n�meros
			MOVX	A,@R1									;copia o n�mero
		
COLA:		MOV		P2,#23H									;MSB do endere�o da mem�ria externa para colar os n�meros
			MOVX	@R1,A									;cola o n�mero
			INC		R1										;incrementa R1, define pr�ximo endere�o de mem�ria externa
			CJNE		R1,#0FH,COPIA						;verifica se as 16 parcelas j� n�o foram transferidas
			JMP		$										;caso afirmativo, encerra o programa

		
			ORG		DADOS

TABELA: 	DB		01H,01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH,0BH,0CH,0DH,0EH,0FH
		
			END