RESET 		EQU 	00H					;come�o do programa
LTSERIAL	EQU 	23H 				;local tratador de serial
STATE 		EQU 	20H					;endere�o da vari�vel de teste

			ORG 	RESET 				;PC=0 depois de reset
			JMP 	INICIO				;pula para in�cio do programa

			ORG 	LTSERIAL			;vai para endere�o do tratador de serial
			CLR 	RI					;limpa RI (flag que solicita a execu��o do tratador)
			MOV 	STATE,#1H			;seta a vari�vel de teste
			RETI						;volta ao programa

INICIO: 	MOV 	IE,#10010000B		;habilita interrup��o serial
			MOV 	SCON,#01010000B		;serial no modo 1 de funcionamento, REN=#1 ==> programa pode receber dados
			MOV 	TMOD,#00100000B		;modo 2 para o timer1
			MOV 	TH1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo th1 =#0fdh (tabela12 - pg.51)
			MOV 	TL1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo tl1 =#0fdh (tabela12 - pg.51)
			MOV 	PCON,#0H			;nesse modo para obter 9.6k, SMOD (FF de PCON) deve ser igual a 0
			SETB 	TR1					;come�a a contar
			
INICIO2:	MOV 	STATE,#0H			;zera a vari�vel de teste
			MOV 	R0,#STATE			;salva o endere�o da vari�vel de teste
			MOV		R1,#30H				;salva o endere�o onde deseja-se salvar os dados

VOLTA: 		CJNE 	@R0,#1,VOLTA		;fica em um ciclo at� chamar a interrup��o serial
			MOV 	STATE,#0H			;zera a vari�vel
			MOV 	A,SBUF				;manda para A o que tiver em SBUF
			MOV		@R1,A				;manda o valor recebido para o endere�o apontado por r1
			INC		R1					;aumenta r1 para salvar o pr�ximo dado no endere�o seguinte
			CJNE 	R1,#35H,VOLTA		;testa se j� n�o foram ocupados os 5 endere�os de mem�ria
			MOV		R1,#30H				;reseta o valor de r1, para volta ao ciclo
			JMP 	VOLTA				;volta para salvar os novos dados no primeiro endere�o indicado

			END