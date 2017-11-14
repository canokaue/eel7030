RESET 		EQU 	00H					;começo do programa
LTSERIAL	EQU 	23H 				;local tratador de serial
STATE 		EQU 	20H					;endereço da variável de teste

			ORG 	RESET 				;PC=0 depois de reset
			JMP 	INICIO				;pula para início do programa

			ORG 	LTSERIAL			;vai para endereço do tratador de serial
			CLR 	RI					;limpa RI (flag que solicita a execução do tratador)
			MOV 	STATE,#1H			;seta a variável de teste
			RETI						;volta ao programa

INICIO: 	MOV 	IE,#10010000B		;habilita interrupção serial
			MOV 	SCON,#01010000B		;serial no modo 1 de funcionamento, REN=#1 ==> programa pode receber dados
			MOV 	TMOD,#00100000B		;modo 2 para o timer1
			MOV 	TH1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo th1 =#0fdh (tabela12 - pg.51)
			MOV 	TL1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo tl1 =#0fdh (tabela12 - pg.51)
			MOV 	PCON,#0H			;nesse modo para obter 9.6k, SMOD (FF de PCON) deve ser igual a 0
			SETB 	TR1					;começa a contar
			
INICIO2:	MOV 	STATE,#0H			;zera a variável de teste
			MOV 	R0,#STATE			;salva o endereço da variável de teste
			MOV		R1,#30H				;salva o endereço onde deseja-se salvar os dados

VOLTA: 		CJNE 	@R0,#1,VOLTA		;fica em um ciclo até chamar a interrupção serial
			MOV 	STATE,#0H			;zera a variável
			MOV 	A,SBUF				;manda para A o que tiver em SBUF
			MOV		@R1,A				;manda o valor recebido para o endereço apontado por r1
			INC		R1					;aumenta r1 para salvar o próximo dado no endereço seguinte
			CJNE 	R1,#35H,VOLTA		;testa se já não foram ocupados os 5 endereços de memória
			MOV		R1,#30H				;reseta o valor de r1, para volta ao ciclo
			JMP 	VOLTA				;volta para salvar os novos dados no primeiro endereço indicado

			END