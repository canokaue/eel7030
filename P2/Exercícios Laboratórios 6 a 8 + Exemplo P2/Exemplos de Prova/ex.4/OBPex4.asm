RESET		EQU		00H					;endereço da memória de programa a ser usada no código
LTSERIAL	EQU		23H					;endereço do tratador de interrupção serial
STATE		EQU		2FH.0				;endereço da variável de teste
	
			ORG		RESET				;começa o programa da posição #00h da memória de programa
			JMP		INICIO				;desvia para o início do código
			
			ORG		LTSERIAL			;começa o tratador no endereço especificado
			CLR		RI					;limpa flag que solicitou a execução do tratador
			SETB	STATE				;seta a variável de teste
			RETI						;retorna ao programa
			
INICIO:		MOV		IE,#10010000B		;habilita interrupção serial
			MOV		PCON,#00H			;smod = #0 para br=2.4k
			MOV		SCON,#11010000B		;serial modo 3 e REN=#1h
			MOV		TMOD,#20H			;timer1 no modo 2
			MOV		TH1,#0F4H			;valor de recarga tabelado para br=2.4k
			MOV		TL1,#0F4H			;valor de início de contagem para br=2.4k
			
			MOV		P2,#20H				;MSB do endereço da memória externa
			MOV		R0,#00H				;LSB do endereço da memória externa
			MOV		R1,#30H				;endereço da memória interna a ser usada
			SETB	TR1					;começa a contagem
			
VOLTA:		JNB		STATE,VOLTA			;fica em loop até a interrupção seria ser solicitada
			CLR		STATE				;limpa a variável de teste
			MOV		A,SBUF				;joga o valor transmitido em "a"
			JNB		RB8,EXT				;testa o nono bit recebido para ver onde vai salvar a memória
	
INT:		MOV		@R1,A				;caso rb8=1, o valor de sbuf que foi salvo em "a" é enviado para memória interna
			INC		R1					;incrementa-se r1 para o próximo valor ser salvo no próximo endereço
			CJNE	R1,#40H,VOLTA		;verifica se já não salvou até o endereço #3fh
			MOV		R1,#30H				;em caso afirmativo, reseta r1
			JMP		VOLTA				;e volta para o loop
			
EXT:		MOVX	@R0,A				;caso rb8=0, o valor de sbuf que foi salvo é enviado para a memória externa
			JMP		VOLTA				;e volta-se para o loop
			
			END