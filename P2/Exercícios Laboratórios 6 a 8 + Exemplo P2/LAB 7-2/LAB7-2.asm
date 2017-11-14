RESET		EQU		00H					;endereço do ínicio do programa
LTSERIAL	EQU		23H					;endereço do tratador de interrupção serial
STATE		EQU		20H					;endereço de variável de teste alterada na LTSERIAL

			ORG		RESET				;início do programa
			JMP		INICIO				;pula para o início
			
			ORG		LTSERIAL			;início do tratador de interrupção
			CLR		TI					;limpa o flag que chama a interrupção
			MOV		STATE,#1H			;seta a variável de teste para sair do ciclo
			RETI						;retorna ao programa
			
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
			MOV		SCON,#11000000B			;pela frequência desejada, é preciso utilizar o serial no modo 3
			MOV		TMOD,#00100000B			;pela frequência desejada, é preciso utilizar timer1 no modo 2
			MOV		TH1,#0FFH				;valor tabelado para obtermos 62.5kibi 
			MOV		TL1,#0FFH				;valor tabelado para obtermos 62.5kibi
			MOV		PCON,#10000000B			;para 62.5 kibi, smod=1
			SETB	TR1						;começa a contar
			
			MOV		STATE,#0H				;zera a variável de teste
			MOV		R0,#STATE				;r0 aponta para o endereço da variável
			MOV		R1,#41H					;r1 aponta para o endereço dos dados
			MOV		SBUF,R1					;IMPORTANTE: para ocorrer a transmissão serial, o primeiro dado a ser transmitido
											;deve ser enviado para SBUF antes de se entrar no ciclo, caso contrário as interrupções
											;seriais não serão atendidas
			
VOLTA:		CJNE	@R0,#1,VOLTA			;fica em ciclo testando a variável de teste
			MOV		STATE,#0H				;após interrupção zera-se a variável
			MOV		C,P						;move para C o bit de paridade
			MOV		TB8,C					;move para tb8, ou seja, será o nono bit a ser transmitido
			INC		R1						;incrementa-se r1 para enviar o dado seguinte
			MOV		SBUF,R1					;envia o dado para SBUF (que enviará para a uart#1)
			CJNE    R1,#62H,VOLTA			;testa o endereço do dado enviado para ver se já não foram todos os dados
			MOV		R1,#40H					;caso já tenham ido todos, ele reseta r1 para começar de novo
			JMP		VOLTA					;e volta para o ciclo
						
			END