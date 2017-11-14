RESET		EQU		00H					;endereço do ínicio do programa
LTSERIAL	EQU		23H					;endereço do tratador de interrupção serial
STATE1		EQU		2FH.1					;endereço de variável de teste para enviar dados 
STATE2		EQU		2FH.2					;endereço da variável de teste para receber dados

			ORG		RESET				;início do programa
			JMP		INICIO				;pula para o início
			
			ORG		LTSERIAL			;início do tratador de interrupção
			JNB		RI,RECEBE			;caso RI=0, significa que é para um dado ser enviado, então desvia-se para setar STATE1
			SETB		STATE2				;caso RI=1, significa que um dado foi recebido, então seta-se STATE2
			CLR		RI					;limpa-se RI para o programa não chamar a interrupção quando voltar
			JMP		RETIS				;pula as instruções referentes ao envio de dados
RECEBE:			SETB	STATE1				;seta a variável de teste do envio de dados
			CLR		TI					;limpa-se TI para o programa não chamar a interrupção quando voltar
RETIS:			RETI						;retorna ao programa
			
INICIO:		MOV		41H,#01H			;aqui são salvos vários dados nos endereços de #41h até #61h para serem transferidos
			MOV		42H,#02H			;através da interface serial (proposta do exercício)
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
			
INICIO2:	MOV		IE,#10010000B			;habilita a ocorrência de interrupção serial
			MOV		SCON,#11010000B			;pela frequência desejada, é preciso utilizar o serial no modo 3, REN=1
			MOV		TMOD,#00100000B			;pela frequência desejada, é preciso utilizar timer1 no modo 2
			MOV		TH1,#0FFH				;valor tabelado para obtermos 62.5kibi 
			MOV		TL1,#0FFH				;valor tabelado para obtermos 62.5kibi
			MOV		PCON,#10000000B			;para 62.5 kibi, smod=1
			
			CLR		STATE1					;zera a variável de teste de envio de dados
			CLR		STATE2					;zera a variável de teste para recebimento de dados
			MOV		R0,#30H					;r0 vai apontar para o endereço solicitado pelo exercício
			MOV		R1,#41H					;r1 aponta para o endereço para pegar dados e enviar pro serial
			SETB	TR1						;começa a contar
			MOV		SBUF,@R1				;IMPORTANTE: para ocorrer a transmissão serial, o primeiro dado a ser transmitido
											;deve ser enviado para SBUF antes de se entrar no ciclo, caso contrário as interrupções
											;seriais não serão atendidas
			
VOLTA:		JNB		STATE1,VOLTA1			;aqui nesse trecho o programa fica alternando entre as linhas 68 e 70 para quebrar o ciclo				JMP		ENVIADADOS			;na linha 68 (caso seja momento de enviar dados) ou na linha 70 (caso seja momento de receber
VOLTA1:		JNB		STATE2,VOLTA			;os dados)
			
			CLR		STATE2					;limpa a variável de teste de recebimento de dados
			MOV		A,SBUF					;envia o dado que foi recebido para A
			MOV		@R0,A					;envia o dado para o endereço da memória interna da vez
			INC		R0						;incrementa r0 para enviar o dado para o próximo endereço da próxima vez
			CJNE		R0,#35H,VOLTA			;verifica se já não chegou no endereço #35h
			MOV		R0,#30H					;se já tiver terminado, recarrega o r0 para ficar cíclico
			JMP		VOLTA					;volta para o ciclo
			
ENVIADADOS:		CLR		STATE1					;após interrupção zera-se a variável
			MOV		C,P						;move-se para C o bit de paridade
			MOV		TB8,C					;move-se o bit de paridade para o nono bit a ser enviado
			INC		R1						;incrementa-se r1 para enviar o dado seguinte
			MOV		SBUF,@R1				;envia o dado para SBUF (que enviará para a uart#1)
			CJNE	        R1,#62H,VOLTA			;testa o endereço do dado enviado para ver se já não foram todos os dados
			MOV		R1,#40H					;caso já tenham ido todos, ele reseta r1 para começar de novo
			JMP		VOLTA					;e volta para o ciclo
						
			END