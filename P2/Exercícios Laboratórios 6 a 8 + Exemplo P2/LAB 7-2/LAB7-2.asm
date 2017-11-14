RESET		EQU		00H					;endere�o do �nicio do programa
LTSERIAL	EQU		23H					;endere�o do tratador de interrup��o serial
STATE		EQU		20H					;endere�o de vari�vel de teste alterada na LTSERIAL

			ORG		RESET				;in�cio do programa
			JMP		INICIO				;pula para o in�cio
			
			ORG		LTSERIAL			;in�cio do tratador de interrup��o
			CLR		TI					;limpa o flag que chama a interrup��o
			MOV		STATE,#1H			;seta a vari�vel de teste para sair do ciclo
			RETI						;retorna ao programa
			
INICIO:		MOV		41H,#01H			;aqui s�o salvos v�rios dados nos endere�os de #41h at� #61h para serem transferidos
			MOV		42H,#02H			;atrav�s da interface serial (proposta do exerc�cio)
			MOV		43H,#03H
			MOV		44H,#04H
			MOV		45H,#02H
			MOV		46H,#02H
			MOV		47H,#02H
			MOV		48H,#02H
			MOV		49H,#02H
			MOV		4AH,#02H
			MOV		4BH,#02H
			MOV		4CH,#02H
			MOV		4DH,#02H
			MOV		4EH,#02H
			MOV		4FH,#02H
			MOV		50H,#02H
			MOV		51H,#01H
			MOV		52H,#02H
			MOV		53H,#03H
			MOV		54H,#04H
			MOV		55H,#02H
			MOV		56H,#02H
			MOV		57H,#02H
			MOV		58H,#02H
			MOV		59H,#02H
			MOV		5AH,#02H
			MOV		5BH,#02H
			MOV		5CH,#02H
			MOV		5DH,#02H
			MOV		5EH,#02H
			MOV		5FH,#02H
			MOV		60H,#02H
			MOV		61H,#02H
			
INICIO2:	MOV		IE,#10010000B			;habilita a ocorr�ncia de interrup��o serial
			MOV		SCON,#11000000B			;pela frequ�ncia desejada, � preciso utilizar o serial no modo 3
			MOV		TMOD,#00100000B			;pela frequ�ncia desejada, � preciso utilizar timer1 no modo 2
			MOV		TH1,#0FFH				;valor tabelado para obtermos 62.5kibi 
			MOV		TL1,#0FFH				;valor tabelado para obtermos 62.5kibi
			MOV		PCON,#10000000B			;para 62.5 kibi, smod=1
			SETB	TR1						;come�a a contar
			
			MOV		STATE,#0H				;zera a vari�vel de teste
			MOV		R0,#STATE				;r0 aponta para o endere�o da vari�vel
			MOV		R1,#41H					;r1 aponta para o endere�o dos dados
			MOV		SBUF,R1					;IMPORTANTE: para ocorrer a transmiss�o serial, o primeiro dado a ser transmitido
											;deve ser enviado para SBUF antes de se entrar no ciclo, caso contr�rio as interrup��es
											;seriais n�o ser�o atendidas
			
VOLTA:		CJNE	@R0,#1,VOLTA			;fica em ciclo testando a vari�vel de teste
			MOV		STATE,#0H				;ap�s interrup��o zera-se a vari�vel
			MOV		C,P						;move para C o bit de paridade
			MOV		TB8,C					;move para tb8, ou seja, ser� o nono bit a ser transmitido
			INC		R1						;incrementa-se r1 para enviar o dado seguinte
			MOV		SBUF,R1					;envia o dado para SBUF (que enviar� para a uart#1)
			CJNE    R1,#62H,VOLTA			;testa o endere�o do dado enviado para ver se j� n�o foram todos os dados
			MOV		R1,#40H					;caso j� tenham ido todos, ele reseta r1 para come�ar de novo
			JMP		VOLTA					;e volta para o ciclo
						
			END