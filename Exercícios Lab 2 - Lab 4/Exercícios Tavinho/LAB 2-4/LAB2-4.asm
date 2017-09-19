RESET		EQU		00H										;in�cio do programa em 0h
DADOS   	EQU		60H										;salva o vetor de dados em 60h
	
			ORG		RESET									;come�a o programa em 0h

INICIO:		MOV		R3,#00H									;parcela a ser gravada em 2100h
			MOV		R0,#50H									;define endere�o onde ser�o salvas as parcelas
			MOV		R2,#05H									;define n�mero de parcelas
			MOV		DPTR,#TABELA							;p�e endere�o da tabela no dptr
		
			MOV		P2,#22H									;MSB do endere�o da mem�ria externa para salvar os n�meros
			MOV		R1,#00H									;LSB do endere�o da mem�ria externa para salvar os n�meros
		
VOLTA: 	 	MOV		A,R3									;p�e em A a atual parcela a ser salva
			MOVC	A,@A+DPTR								;l� a parcela em quest�o
			MOV		@R0,A									;salva no endere�o da mem�ria interna
			MOVX	@R1,A									;salva no endere�o de mem�ria externa
			INC 	R1										;incrementa R1, define pr�ximo endere�o de mem�ria externa
			INC		R0										;incrementa R0, define pr�ximo endere�o de mem�ria interna
			INC		R3										;incrementa R3, atual parcela
			DJNZ	R2,VOLTA								;verifica se as 5 parcelas j� n�o foram salvas
			JMP		$
		
			ORG		DADOS

TABELA: 	DB		01H,02H,03H,04H,05H		
			END