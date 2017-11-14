RESET		EQU		00H						;local onde estará escrito o programa
LTSERIAL	EQU		23H						;local do tratador de interrupção serial
STATE		EQU		2FH.1					;local de variável de teste
	
			ORG		RESET					;endereço do começo do programa
			JMP		INICIO					;vai para o início do código
			
			ORG		LTSERIAL				;endereço do tratador de interrupção serial
			CLR		RI						;limpa a flag que chamou o tratador
			SETB	STATE					;seta a variável de teste para sair do loop (linha 25)
			RETI							;volta ao programa
			
INICIO:		MOV		IE,#10010000B			;habilita interrupção serial
			MOV		SCON,#01010000B			;serial no modo 1 e REN=#1 para poder receber dados
			MOV		TMOD,#20H				;timer 1 no modo 2
			MOV		TH1,#0E8H				;seta th1 para obter a baud rate de 1.2k
			MOV		TL1,#0E8H				;seta tl1 para obter a baud rate de 1.2k
			MOV		PCON,#00H				;SMOD=#0H
			
			CLR		STATE					;limpa a variável de teste
			MOV		P2,#20H					;MSB dos endereços de memória externa a serem usados
			MOV		R0,#00H					;R0 será usado para indexar os LSB dos endereços de memória externa
			SETB	TR1						;começa a contagem no timer1
			
VOLTA:		JNB		STATE,VOLTA				;fica em loop até a interrupção serial ser chamada
			CLR		STATE					;limpa a variável de teste
			MOV		A,SBUF					;joga no acumulador o valor transmitido pela interface serial
			MOVX	@R0,A					;move para o endereço de memória externa desejado
			INC		R0						;incrementa R0 para mudar o próximo endereço de memória externa
			CJNE	R0,#1FH,VOLTA			;verifica se não foi atingido o fim desejado da memória externa
			MOV		R0,#00H					;em caso afirmativo, reseta R0 para voltar ao x:2000H
			JMP		VOLTA					;e volta ao ciclo
			
			END								;acaba o programa