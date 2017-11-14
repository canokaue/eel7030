RESET		EQU		00H					;endere�o da mem�ria de programa a ser usada pelo c�digo
LTSERIAL	EQU		23H					;endere�o do tratador de interrup��o serial
STATE		EQU		2FH.0				;endere�o de vari�vel de teste
	
			ORG		RESET				;come�a a leitura do c�digo do programa
			JMP 	INICIO				;pula para as instru��es
			
			ORG		LTSERIAL			;come�a a leitura do tratador de interrup��o
			CLR		TI					;limpa TI para n�o chamar a inetrrup��o novamente
			SETB	STATE				;seta a vari�vel de teste para sair do loop
			RETI						;retorna ao programa
			
INICIO:		MOV		IE,#10010000B		;habilita interrup��o serial
			MOV		PCON,#00H			;smod = #0 para taxa de 4.8k
			MOV		SCON,#01000000B		;interrup��o serial no modo 1
			MOV		TMOD,#20H			;timer 1 no modo 2
			MOV		TH1,#0FAH			;valor de recarga especificado para taxa de 4.8k
			MOV		TL1,#0FAH			;valor inicial de contagem para taxa de 4.8k
			
			MOV		P2,#20H				;MSB do endere�o de mem�ria externa
			MOV		R0,#00H				;LSB do endere�o de mem�ria externa
			MOV		R1,#01H				;r1 vai indicar qual o caracter que deve ser enviado
			MOV		R2,#00H				;r2 vai realizar a contagem de caracteres enviados
			MOV		DPTR,#TABELA		;dptr salva o endere�o dos caracteres
			SETB	TR1					;come�a a contagem
			MOV		SBUF,#'E'			;envia para sbuf o primeiro caracter
			
VOLTA:		JNB		STATE,VOLTA			;fica em loop at� a interrup��o ser executada
			CLR 	STATE				;limpa a vari�vel de teste
			MOV		A,R1				;r1 define que qual caractere ser� enviado 
			MOVC	A,@A+DPTR			;a+dptr busca o caracter na mem�ria
			MOV		SBUF,A				;e o caractere � enviado para sbuf, que enviar� pra interface serial
			INC		R2					;r2 � incrementado, pois um novo caractere foi enviado
			MOV		A,R2				;move-se o novo valor de r2 para a
			MOVX	@R0,A				;e salva-se ele no endere�o de mem�ria externa especifica
			INC		R1					;r1 � incrementado para buscar o caracter seguinte ap�s a pr�xima interrup��o
			CJNE	R1,#1AH,VOLTA		;verifica-se se j� n�o foram todos os caracteres
			MOV		R1,#00H				;em caso afirmativo, reseta-se o r1
			JMP		VOLTA				;e volta-se para o loop
			
TABELA:		DB		'EEL7030-Microprocessadores'
	
			END