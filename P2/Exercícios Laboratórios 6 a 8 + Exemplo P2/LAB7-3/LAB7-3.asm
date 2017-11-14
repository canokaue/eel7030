RESET		EQU		00H					;endere�o do �nicio do programa
LTSERIAL	EQU		23H					;endere�o do tratador de interrup��o serial
STATE1		EQU		2FH.1					;endere�o de vari�vel de teste para enviar dados 
STATE2		EQU		2FH.2					;endere�o da vari�vel de teste para receber dados

			ORG		RESET				;in�cio do programa
			JMP		INICIO				;pula para o in�cio
			
			ORG		LTSERIAL			;in�cio do tratador de interrup��o
			JNB		RI,RECEBE			;caso RI=0, significa que � para um dado ser enviado, ent�o desvia-se para setar STATE1
			SETB		STATE2				;caso RI=1, significa que um dado foi recebido, ent�o seta-se STATE2
			CLR		RI					;limpa-se RI para o programa n�o chamar a interrup��o quando voltar
			JMP		RETIS				;pula as instru��es referentes ao envio de dados
RECEBE:			SETB	STATE1				;seta a vari�vel de teste do envio de dados
			CLR		TI					;limpa-se TI para o programa n�o chamar a interrup��o quando voltar
RETIS:			RETI						;retorna ao programa
			
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
			MOV		SCON,#11010000B			;pela frequ�ncia desejada, � preciso utilizar o serial no modo 3, REN=1
			MOV		TMOD,#00100000B			;pela frequ�ncia desejada, � preciso utilizar timer1 no modo 2
			MOV		TH1,#0FFH				;valor tabelado para obtermos 62.5kibi 
			MOV		TL1,#0FFH				;valor tabelado para obtermos 62.5kibi
			MOV		PCON,#10000000B			;para 62.5 kibi, smod=1
			
			CLR		STATE1					;zera a vari�vel de teste de envio de dados
			CLR		STATE2					;zera a vari�vel de teste para recebimento de dados
			MOV		R0,#30H					;r0 vai apontar para o endere�o solicitado pelo exerc�cio
			MOV		R1,#41H					;r1 aponta para o endere�o para pegar dados e enviar pro serial
			SETB	TR1						;come�a a contar
			MOV		SBUF,@R1				;IMPORTANTE: para ocorrer a transmiss�o serial, o primeiro dado a ser transmitido
											;deve ser enviado para SBUF antes de se entrar no ciclo, caso contr�rio as interrup��es
											;seriais n�o ser�o atendidas
			
VOLTA:		JNB		STATE1,VOLTA1			;aqui nesse trecho o programa fica alternando entre as linhas 68 e 70 para quebrar o ciclo				JMP		ENVIADADOS			;na linha 68 (caso seja momento de enviar dados) ou na linha 70 (caso seja momento de receber
VOLTA1:		JNB		STATE2,VOLTA			;os dados)
			
			CLR		STATE2					;limpa a vari�vel de teste de recebimento de dados
			MOV		A,SBUF					;envia o dado que foi recebido para A
			MOV		@R0,A					;envia o dado para o endere�o da mem�ria interna da vez
			INC		R0						;incrementa r0 para enviar o dado para o pr�ximo endere�o da pr�xima vez
			CJNE		R0,#35H,VOLTA			;verifica se j� n�o chegou no endere�o #35h
			MOV		R0,#30H					;se j� tiver terminado, recarrega o r0 para ficar c�clico
			JMP		VOLTA					;volta para o ciclo
			
ENVIADADOS:		CLR		STATE1					;ap�s interrup��o zera-se a vari�vel
			MOV		C,P						;move-se para C o bit de paridade
			MOV		TB8,C					;move-se o bit de paridade para o nono bit a ser enviado
			INC		R1						;incrementa-se r1 para enviar o dado seguinte
			MOV		SBUF,@R1				;envia o dado para SBUF (que enviar� para a uart#1)
			CJNE	        R1,#62H,VOLTA			;testa o endere�o do dado enviado para ver se j� n�o foram todos os dados
			MOV		R1,#40H					;caso j� tenham ido todos, ele reseta r1 para come�ar de novo
			JMP		VOLTA					;e volta para o ciclo
						
			END