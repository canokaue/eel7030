RESET 		EQU 	00H					;come�o do programa
LTSERIAL	EQU 	23H 				;local tratador de serial
STATE 		EQU 	20H					;endere�o da vari�vel de teste

			ORG 	RESET 				;PC=0 depois de reset
			JMP 	INICIO				;pula para in�cio do programa

			ORG 	LTSERIAL			;vai para endere�o do tratador
			CLR 	TI					;limpa ff que solicitou a execu��o do tratador
			MOV 	STATE,#1H			;seta a vari�vel de teste
			RETI						;volta ao programa

INICIO: 	MOV 	IE,#10010000B		;habilita interrup��o serial
			MOV 	SCON,#01000000B		;serial no modo 1 de funcionamento, define os valores de th1 e tl1 atrav�s da tabela na apostila
			MOV 	TMOD,#00100000B		;modo 2 para o timer1
			MOV 	TH1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo th1 =#0fdh (tabela12 - pg.51)
			MOV 	TL1,#0FDH			;deseja-se uma baud rate de 9.6k no modo 1, logo tl1 =#0fdh (tabela12 - pg.51)
			MOV 	PCON,#0H			;nesse modo para obter 9.6k, SMOD (FF de PCON) deve ser igual a 0
			SETB 	TR1					;come�a a contar
			
			MOV 	STATE,#0H			;zera a vari�vel de teste
			MOV 	R0,#STATE			;salva o endere�o da vari�vel de teste
			MOV 	DPTR,#TABELA		;salva o endere�o dos valores
			MOV 	R1,#1				;contador para ver se j� foram os 16 caracteres
			MOV 	SBUF,#'M'			;joga o primeiro caractere em SBUF, se n�o fizer isso o programa n�o chama a interrup��o serial

VOLTA: 		CJNE 	@R0,#1,VOLTA		;fica em um ciclo at� chamar a interrup��o serial
			MOV 	STATE,#0H			;zera a vari�vel
			MOV 	A,R1				;joga em a o n�mero do caractere da vez
			MOVC 	A,@A+DPTR			;soma ao endere�o de dptr e salva o valor do caractere em A
			MOV 	SBUF,A				;manda para SBUF, o 8051 envia sozinho para a interface serial
			INC 	R1					;incrementa r1 para registrar que mais um caractere foi enviado
			CJNE 	R1,#16,VOLTA		;testa se j� n�o foram os 16 caracteres
			CLR 	TR1					;em caso afirmativo ele para de contar
			JMP 	$					;e fica aqui de buenas

TABELA: 	DB 		'Microcontrolador'
			END