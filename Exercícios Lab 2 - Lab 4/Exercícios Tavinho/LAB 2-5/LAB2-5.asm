RESET		EQU		00H										;início do programa em 0h
DADOS   	EQU		60H										;salva o vetor de dados em 60h
	
			ORG		RESET									;começa o programa em 0h

INICIO:		MOV		R3,#00H									;parcela a ser gravada em 2100h
			MOV		DPTR,#TABELA							;põe endereço da tabela no dptr
		
			MOV		P2,#21H									;MSB do endereço da memória externa para salvar os números
			MOV		R1,#00H									;LSB do endereço da memória externa para salvar os números
		
VOLTA: 	 	MOV		A,R3									;põe em A a atual parcela a ser salva
			MOVC	A,@A+DPTR								;lê a parcela em questão
			MOVX	@R1,A									;salva no endereço de memória externa
			INC 		R1									;incrementa R1, define próximo endereço de memória externa
			INC		R3										;incrementa R3, atual parcela
			CJNE		R1,#0FH,VOLTA						;verifica se as 16 parcelas já não foram salvas
				
			MOV		R1,#00H									;limpa o LSB do endereço da memória externa para lidar

COPIA:		MOV		P2,#21H									;MSB do endereço da memória externa para copiar os números
			MOVX	A,@R1									;copia o número
		
COLA:		MOV		P2,#23H									;MSB do endereço da memória externa para colar os números
			MOVX	@R1,A									;cola o número
			INC		R1										;incrementa R1, define próximo endereço de memória externa
			CJNE		R1,#0FH,COPIA						;verifica se as 16 parcelas já não foram transferidas
			JMP		$										;caso afirmativo, encerra o programa

		
			ORG		DADOS

TABELA: 	DB		01H,01H,02H,03H,04H,05H,06H,07H,08H,09H,0AH,0BH,0CH,0DH,0EH,0FH
		
			END