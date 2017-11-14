RESET		EQU		00H					;endereço da memória de programa a ser usada pelo código
LTSERIAL	EQU		23H					;endereço do tratador de interrupção serial
STATE		EQU		2FH.0				;endereço de variável de teste
	
			ORG		RESET				;começa a leitura do código do programa
			JMP 	INICIO				;pula para as instruções
			
			ORG		LTSERIAL			;começa a leitura do tratador de interrupção
			CLR		TI					;limpa TI para não chamar a inetrrupção novamente
			SETB	STATE				;seta a variável de teste para sair do loop
			RETI						;retorna ao programa
			
INICIO:		MOV		IE,#10010000B		;habilita interrupção serial
			MOV		PCON,#00H			;smod = #0 para taxa de 4.8k
			MOV		SCON,#01000000B		;interrupção serial no modo 1
			MOV		TMOD,#20H			;timer 1 no modo 2
			MOV		TH1,#0FAH			;valor de recarga especificado para taxa de 4.8k
			MOV		TL1,#0FAH			;valor inicial de contagem para taxa de 4.8k
			
			MOV		P2,#20H				;MSB do endereço de memória externa
			MOV		R0,#00H				;LSB do endereço de memória externa
			MOV		R1,#01H				;r1 vai indicar qual o caracter que deve ser enviado
			MOV		R2,#00H				;r2 vai realizar a contagem de caracteres enviados
			MOV		DPTR,#TABELA		;dptr salva o endereço dos caracteres
			SETB	TR1					;começa a contagem
			MOV		SBUF,#'E'			;envia para sbuf o primeiro caracter
			
VOLTA:		JNB		STATE,VOLTA			;fica em loop até a interrupção ser executada
			CLR 	STATE				;limpa a variável de teste
			MOV		A,R1				;r1 define que qual caractere será enviado 
			MOVC	A,@A+DPTR			;a+dptr busca o caracter na memória
			MOV		SBUF,A				;e o caractere é enviado para sbuf, que enviará pra interface serial
			INC		R2					;r2 é incrementado, pois um novo caractere foi enviado
			MOV		A,R2				;move-se o novo valor de r2 para a
			MOVX	@R0,A				;e salva-se ele no endereço de memória externa especifica
			INC		R1					;r1 é incrementado para buscar o caracter seguinte após a próxima interrupção
			CJNE	R1,#1AH,VOLTA		;verifica-se se já não foram todos os caracteres
			MOV		R1,#00H				;em caso afirmativo, reseta-se o r1
			JMP		VOLTA				;e volta-se para o loop
			
TABELA:		DB		'EEL7030-Microprocessadores'
	
			END