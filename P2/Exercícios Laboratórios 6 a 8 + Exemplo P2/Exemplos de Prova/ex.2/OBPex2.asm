RESET		EQU		00H						;endereço da memória de programa inicial	
TIMER1		EQU		1BH						;endereço do tratador de interrupção do timer1
STATE		EQU		2FH.0					;enndereço de variável de teste
	
			ORG		RESET					;começa o programa em 00h (reset)
			JMP		INICIO					;vai para o início do código
			
			ORG		TIMER1					;começa o tratador no endereço especificado
			SETB	STATE					;seta a variável de teste para sair do loop
			RETI							;retorna ao programa
			
INICIO:		MOV		IE,#10001000B			;habilita a interrupção do timer1
			MOV		TMOD,#20H				;especifica o timer1 no modo 2
			MOV		TH1,#60H				;define th1 que vai recarregar tl1 ao término das contagens
			MOV		TL1,#60H				;tl1 será incrementado e a interrupção será solicitada quando chegar #0ffh
			
			;TIMER1 NO MODO 2: deseja-se a transferência de um caractere a cada 160 ciclos de instrução, no modo 2 a interrupção do
			;timer é solicitada sempre que tl1 atinge #0ffh. Dito isso é necessário carregar tl1 com o valor de #255d-#159d=#60h para
			;a interrupção seja solicitada após 160 ciclos. Após a interrupção tl1 será carregado automaticamente com o valor th1, por
			;é necessário também setar th1 com o valor #60h.
			
			MOV		P2,#10H					;MSB do endereço de memória externa a ser utilizado
			MOV		R0,#00H					;r0 será usado para definir o caractere e os LSB do endereço de memória externa
			MOV		DPTR,#TABELA			;salva o endereço da tabela de caracteres no dptr, para poder apontar depois
			SETB	TR1						;começa a contagem do timer1
			
VOLTA:		JNB		STATE,VOLTA				;fica em um loop até que a interrupção seja executada
			CLR		STATE					;limpa a variável de teste para voltar ao loop depois
			MOV		A,R0					;joga-se em "a" qual o caracter da vez
			MOVC	A,@A+DPTR				;e busca-se esse caractere somando "a+dptr"
			MOVX	@R0,A					;move-se o valor para o endereço da memória externa da vez
			INC		R0						;incrementa-se r0 para buscar o próximo valor e salvar no próximo endereço da memx
			CJNE	@R0,#15,VOLTA			;verifica se os 21 caracteres já não foram enviados
			MOV		R0,#00H					;em caso afirmativo, limpa-se r0 para começar de novo
			JMP 	VOLTA					;e volta para o loop
			
TABELA:		DB		'Microcontrolador 8051' ;sequência de caracteres a ser enviado para a memória externa
			
			END								;fim do programa