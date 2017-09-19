ATRASO		EQU		30H							;define endereço do vetor de atraso				
			ORG		00H							;programa começa do zero

INICIO:		MOV		R5,#00001111B				;número para fazer lógica and com porta p2
			MOV		R4,#00H						;variável que define se vai para a esquerda ou direita
			MOV 	R3,#01H						;faz com que o primeiro led aceso seja o mais da direita
			MOV		A,R3						;joga r3 no acumulador
			MOV		P1,A						;para jogar nos leds
			JMP 	CICLO						;pula a fase de pre-ciclo

PRECICLO:	MOV		A,P2						;loop para segurar rotação do led após sua execução
			RLC		A							;joga p2.7 no carry
			JNC     CICLO						;vai para o ciclo caso p2.7=0
			JMP     PRECICLO					;se p2.7=1 fica preso aqui
				
CICLO:		MOV 	A,P2						;joga o valor pressionada em P2 em A
			RLC		A							;rotaciona para a esquerda, jogando o p2.7 no Carry
			JNC		CICLO						;se p2.7 = 1, fica preso no ciclo
			RLC		A							;se p2.7 = 0, rotaciona mais uma vez
			JC		ESQUERDA					;se p2.6 = 1 deve rotacionar para a esquerda
			JMP		BITS4						;pula para registrar o número de casas que o led rotacionará
ESQUERDA:	MOV		R4,#01H						;se for para a esquerda, deverá setar R4 com 1

BITS4:		MOV		A,P2						;busca de novo o valor pressionado em P2
			CPL		A							;complementa para pegar nível lógico baixo
			ANL		A,R5						;lógica and com #00001111b para zerar os 4 primeiros bytes
			MOV		R2,A						;salva em R2
			
			
VOLTA:		MOV		ATRASO,#0FFH				;define atraso como um número gigante
			CALL 	DELAY						;chama subrotina de delay
			CJNE	R4,#00H,CALLRRA				;testa a variável de R4 para saber se vai para a esquerda ou direita
			
			CALL	RLA							;chama subrotina de rotacionar A para a esquerda 
			JMP		DR2							;já rotacionou, pode jogar no led e decrementar R2

CALLRRA:	CALL	RRA							;chama subrotina de rotacionar A para a direita

DR2:		MOV		A,R3						;joga o valor da vez no acumulador
			MOV		P1,A						;joga o valor da vez nos led
			DJNZ	R2,VOLTA					;testa o número de rotações já feitas
			JMP		PRECICLO					;quando termina desvia fluxo para preciclo
			
RLA:		MOV		A,R3						;joga n-1 em A
			RL		A							;rotaciona para a esquerda
			MOV		R3,A						;salva n em R3
			RET									;volta ao programa
			
RRA:		MOV		A,R3						;joga n-1 em A						
			RR		A							;rotaciona para a direita
			MOV		R3,A						;salva n em R3
			RET									;volta ao programa
			
DELAY:		DJNZ	ATRASO,DELAY				;fica decrementando o número gigante para perder tempo
			RET									;volta ao programa
			
			END