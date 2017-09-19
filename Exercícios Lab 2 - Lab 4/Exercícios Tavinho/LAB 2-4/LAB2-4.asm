RESET		EQU		00H										;início do programa em 0h
DADOS   	EQU		60H										;salva o vetor de dados em 60h
	
			ORG		RESET									;começa o programa em 0h

INICIO:		MOV		R3,#00H									;parcela a ser gravada em 2100h
			MOV		R0,#50H									;define endereço onde serão salvas as parcelas
			MOV		R2,#05H									;define número de parcelas
			MOV		DPTR,#TABELA							;põe endereço da tabela no dptr
		
			MOV		P2,#22H									;MSB do endereço da memória externa para salvar os números
			MOV		R1,#00H									;LSB do endereço da memória externa para salvar os números
		
VOLTA: 	 	MOV		A,R3									;põe em A a atual parcela a ser salva
			MOVC	A,@A+DPTR								;lê a parcela em questão
			MOV		@R0,A									;salva no endereço da memória interna
			MOVX	@R1,A									;salva no endereço de memória externa
			INC 	R1										;incrementa R1, define próximo endereço de memória externa
			INC		R0										;incrementa R0, define próximo endereço de memória interna
			INC		R3										;incrementa R3, atual parcela
			DJNZ	R2,VOLTA								;verifica se as 5 parcelas já não foram salvas
			JMP		$
		
			ORG		DADOS

TABELA: 	DB		01H,02H,03H,04H,05H		
			END