RESET		EQU		00H						;endere�o da mem�ria de programa inicial	
TIMER1		EQU		1BH						;endere�o do tratador de interrup��o do timer1
STATE		EQU		2FH.0					;enndere�o de vari�vel de teste
	
			ORG		RESET					;come�a o programa em 00h (reset)
			JMP		INICIO					;vai para o in�cio do c�digo
			
			ORG		TIMER1					;come�a o tratador no endere�o especificado
			SETB	STATE					;seta a vari�vel de teste para sair do loop
			RETI							;retorna ao programa
			
INICIO:		MOV		IE,#10001000B			;habilita a interrup��o do timer1
			MOV		TMOD,#20H				;especifica o timer1 no modo 2
			MOV		TH1,#60H				;define th1 que vai recarregar tl1 ao t�rmino das contagens
			MOV		TL1,#60H				;tl1 ser� incrementado e a interrup��o ser� solicitada quando chegar #0ffh
			
			;TIMER1 NO MODO 2: deseja-se a transfer�ncia de um caractere a cada 160 ciclos de instru��o, no modo 2 a interrup��o do
			;timer � solicitada sempre que tl1 atinge #0ffh. Dito isso � necess�rio carregar tl1 com o valor de #255d-#159d=#60h para
			;a interrup��o seja solicitada ap�s 160 ciclos. Ap�s a interrup��o tl1 ser� carregado automaticamente com o valor th1, por
			;� necess�rio tamb�m setar th1 com o valor #60h.
			
			MOV		P2,#10H					;MSB do endere�o de mem�ria externa a ser utilizado
			MOV		R0,#00H					;r0 ser� usado para definir o caractere e os LSB do endere�o de mem�ria externa
			MOV		DPTR,#TABELA			;salva o endere�o da tabela de caracteres no dptr, para poder apontar depois
			SETB	TR1						;come�a a contagem do timer1
			
VOLTA:		JNB		STATE,VOLTA				;fica em um loop at� que a interrup��o seja executada
			CLR		STATE					;limpa a vari�vel de teste para voltar ao loop depois
			MOV		A,R0					;joga-se em "a" qual o caracter da vez
			MOVC	A,@A+DPTR				;e busca-se esse caractere somando "a+dptr"
			MOVX	@R0,A					;move-se o valor para o endere�o da mem�ria externa da vez
			INC		R0						;incrementa-se r0 para buscar o pr�ximo valor e salvar no pr�ximo endere�o da memx
			CJNE	@R0,#15,VOLTA			;verifica se os 21 caracteres j� n�o foram enviados
			MOV		R0,#00H					;em caso afirmativo, limpa-se r0 para come�ar de novo
			JMP 	VOLTA					;e volta para o loop
			
TABELA:		DB		'Microcontrolador 8051' ;sequ�ncia de caracteres a ser enviado para a mem�ria externa
			
			END								;fim do programa