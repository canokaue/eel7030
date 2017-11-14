RESET		EQU		00H					;endere�o da mem�ria de programa a ser usada no c�digo
LTSERIAL	EQU		23H					;endere�o do tratador de interrup��o serial
STATE		EQU		2FH.0				;endere�o da vari�vel de teste
	
			ORG		RESET				;come�a o programa da posi��o #00h da mem�ria de programa
			JMP		INICIO				;desvia para o in�cio do c�digo
			
			ORG		LTSERIAL			;come�a o tratador no endere�o especificado
			CLR		RI					;limpa flag que solicitou a execu��o do tratador
			SETB	STATE				;seta a vari�vel de teste
			RETI						;retorna ao programa
			
INICIO:		MOV		IE,#10010000B		;habilita interrup��o serial
			MOV		PCON,#00H			;smod = #0 para br=2.4k
			MOV		SCON,#11010000B		;serial modo 3 e REN=#1h
			MOV		TMOD,#20H			;timer1 no modo 2
			MOV		TH1,#0F4H			;valor de recarga tabelado para br=2.4k
			MOV		TL1,#0F4H			;valor de in�cio de contagem para br=2.4k
			
			MOV		P2,#20H				;MSB do endere�o da mem�ria externa
			MOV		R0,#00H				;LSB do endere�o da mem�ria externa
			MOV		R1,#30H				;endere�o da mem�ria interna a ser usada
			SETB	TR1					;come�a a contagem
			
VOLTA:		JNB		STATE,VOLTA			;fica em loop at� a interrup��o seria ser solicitada
			CLR		STATE				;limpa a vari�vel de teste
			MOV		A,SBUF				;joga o valor transmitido em "a"
			JNB		RB8,EXT				;testa o nono bit recebido para ver onde vai salvar a mem�ria
	
INT:		MOV		@R1,A				;caso rb8=1, o valor de sbuf que foi salvo em "a" � enviado para mem�ria interna
			INC		R1					;incrementa-se r1 para o pr�ximo valor ser salvo no pr�ximo endere�o
			CJNE	R1,#40H,VOLTA		;verifica se j� n�o salvou at� o endere�o #3fh
			MOV		R1,#30H				;em caso afirmativo, reseta r1
			JMP		VOLTA				;e volta para o loop
			
EXT:		MOVX	@R0,A				;caso rb8=0, o valor de sbuf que foi salvo � enviado para a mem�ria externa
			JMP		VOLTA				;e volta-se para o loop
			
			END