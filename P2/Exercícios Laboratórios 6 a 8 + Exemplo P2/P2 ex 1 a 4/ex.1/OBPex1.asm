RESET		EQU		00H						;local onde estar� escrito o programa
LTSERIAL	EQU		23H						;local do tratador de interrup��o serial
STATE		EQU		2FH.1					;local de vari�vel de teste
	
			ORG		RESET					;endere�o do come�o do programa
			JMP		INICIO					;vai para o in�cio do c�digo
			
			ORG		LTSERIAL				;endere�o do tratador de interrup��o serial
			CLR		RI						;limpa a flag que chamou o tratador
			SETB	STATE					;seta a vari�vel de teste para sair do loop (linha 25)
			RETI							;volta ao programa
			
INICIO:		MOV		IE,#10010000B			;habilita interrup��o serial
			MOV		SCON,#01010000B			;serial no modo 1 e REN=#1 para poder receber dados
			MOV		TMOD,#20H				;timer 1 no modo 2
			MOV		TH1,#0E8H				;seta th1 para obter a baud rate de 1.2k
			MOV		TL1,#0E8H				;seta tl1 para obter a baud rate de 1.2k
			MOV		PCON,#00H				;SMOD=#0H
			
			CLR		STATE					;limpa a vari�vel de teste
			MOV		P2,#20H					;MSB dos endere�os de mem�ria externa a serem usados
			MOV		R0,#00H					;R0 ser� usado para indexar os LSB dos endere�os de mem�ria externa
			SETB	TR1						;come�a a contagem no timer1
			
VOLTA:		JNB		STATE,VOLTA				;fica em loop at� a interrup��o serial ser chamada
			CLR		STATE					;limpa a vari�vel de teste
			MOV		A,SBUF					;joga no acumulador o valor transmitido pela interface serial
			MOVX	@R0,A					;move para o endere�o de mem�ria externa desejado
			INC		R0						;incrementa R0 para mudar o pr�ximo endere�o de mem�ria externa
			CJNE	R0,#1FH,VOLTA			;verifica se n�o foi atingido o fim desejado da mem�ria externa
			MOV		R0,#00H					;em caso afirmativo, reseta R0 para voltar ao x:2000H
			JMP		VOLTA					;e volta ao ciclo
			
			END								;acaba o programa