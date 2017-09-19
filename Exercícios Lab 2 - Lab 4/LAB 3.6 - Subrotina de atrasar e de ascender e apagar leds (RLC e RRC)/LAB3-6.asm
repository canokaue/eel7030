ATRASO		EQU		30H							;define endere�o do vetor de atraso				
			ORG		00H							;programa come�a do zero

INICIO:		MOV		R6,#00H						;define o n�mero de teste para ver se j� acendeu os 8 leds
			MOV		R5,#00H						;zero para operar com o carry
			MOV 	R4,#01H						;faz com que o primeiro led aceso seja o mais da direita
			MOV		R3,#01H						;n�mero que ser� rotacionado para somar com A
			MOV		R2,#08H						;ser� usado para testar se j� rotacionou 8 vezes

VOLTAL:		MOV		A,R4						;joga o valor da vez no acumulador
			MOV		P1,A						;joga o valor da vez nos leds
			MOV		ATRASO,#0FFH				;define atraso como um n�mero gigante
			CALL 	DELAY						;chama subrotina de delay
			CALL	RLA							;chama subrotina de rotacionar A 
			DJNZ	R2,VOLTAL					;testa o n�mero de rota��es j� feitas
			
			MOV		R2,#08H						;redefine o n�mero de teste para as rota��es
			MOV		R6,#01H						;seta R6 para rotacionar para a direita
			MOV		R3,#10000000B				;define o primeiro numero a subtrair de R4
			
			
VOLTAR:		CALL 	RLA							;chama a subrotina de rotacionar A
			MOV		A,R4						;joga o valor da vez no acumulador
			MOV 	P1,A						;joga o valor da vez nos leds
			MOV		ATRASO,#0FFH				;define atraso como um n�mero gigante
			CALL 	DELAY						;chama a subrotina de delay
			DJNZ	R2,VOLTAR					;testa se j� n�o foram 8 rota��es
			JMP 	INICIO   					;em caso de ter terminado come�a de novo
			
RLA:		CJNE	R6,#00H,RRA					;R6=0 vai somar os leds para a esquerda. R6=1 vai subtrair os leds para a direita
			
			MOV		A,R3						;define A como o n�mero a ser somado ao exposto nos leds
			RLC		A							;rotaciona A para a esquerda
			MOV		R3,A						;salva em R3
			MOV		A,R4						;define A como sendo o atual n�mero exposto
			ADDC	A,R3						;soma o n�mero exposto com o byte seguinte e o carry
			SUBB	A,R5						;tira o carry
			MOV		R4,A						;salva em R4
			JMP 	RETORNA						;vai para o RET
			
RRA:		MOV		A,R4
			SUBB	A,R3
			ADDC	A,R5
			MOV		R4,A
			MOV		A,R3
			RRC		A
			MOV		R3,A
RETORNA:	RET									;volta ao programa
			
DELAY:		DJNZ	ATRASO,DELAY				;fica decrementando o n�mero gigante para perder tempo
			RET									;volta ao programa
			
			END