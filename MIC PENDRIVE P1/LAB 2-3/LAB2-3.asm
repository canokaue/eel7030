;Programa Endere�aExterno.asm
RESET 	EQU 0H							;define o come�o do c�digo do programa
VETOR   EQU 60H							;define onde ser� salvo o vetor de dados
		
		ORG RESET 						;PC = 0000H ao se resetar o 8051
		
		MOV DPTR,#NRO 					;endereco nro parcelas a ser somado
		MOV A,#0						;limpa A
		MOVC A,@A+DPTR					;joga em A o n�mero de parcelas a ser somado
		JZ	FIM							;se o n�mero de parcelas a ser somado for zero, nem roda
		MOV R3,A 						;R3 = nro parcelas a ser somado
		MOV DPTR,#DADOS 				;end. vetor de dados a ser somado
		MOV R2,#0 						;guarda resultado das somas realizadas
		MOV R0,#0 						;especifica parcela a ser lida do vetor de dados
		MOV R4,#0						;armazena byte mais significativo da soma
		
		MOV P2,#00H						;MSB do endere�o da mem�ria externa	
		MOV R1,#00H						;LSB do endere�o da mem�ria externa

VOLTA: 	MOV A,R0						;p�e no acumulador a parcela que est� sendo lida
		MOVC A,@A+DPTR 					;l� parcela da vez
		ADD A,R2						;adiciona a soma j� efetuada � parcela da vez
		MOV R2,A						;e salva esse valor em R2
		MOV A,#0						;A=0
		ADDC A,R4						;joga o valor do carry em A porque R4=0
		MOV R4,A						;salva o valor do carry em R4
		MOVX @R1,A						;joga na mem�ria externa
		INC R0							;atualiza qual parcela ser� lida
		DJNZ R3,VOLTA					;testa o n�mero de parcelas j� somado
FIM: 	JMP FIM							;caso tenha acabado, encerra o programa

		ORG VETOR

NRO: 	DB 0FFH
DADOS: 	DB 01H,0AH,05H,06H,0AH,0E2H,0AH,05H,06H,0AH,0E2H,0AH,05H,06H,0AH,0E2H,0AH,05H,06H,0AH,0E2H,0AH,05H,06H,0AH,0E2H,0AH,05H,06H,0AH,0E2H

END