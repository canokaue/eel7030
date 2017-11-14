ATRASO		EQU		30H							;define endereço do vetor de atraso
				
			ORG		00H							;programa começa do zero

INICIO:		MOV 	A,#01H						;faz com que o primeiro led aceso seja o mais da direita
			MOV		R2,#08H						;será usado para testar se já rotacionou 8 vezes

VOLTA:		MOV		P1,A						;joga o valor da vez nos leds
			MOV		ATRASO,#0FFH				;define atraso como um número gigante
			CALL 	DELAY						;chama subrotina de delay
			CALL	RLA							;chama subrotina de rotacionar A
			DJNZ	R2,VOLTA					;testa o número de rotações já feitas
			JMP 	INICIO						;em caso de ter terminado começa de novo
			
RLA:		RL		A							;rotaciona A para a esquerda
			RET									;volta ao programa
			
DELAY:		DJNZ	ATRASO,DELAY				;fica decrementando o número gigante para perder tempo
			RET									;volta ao programa
			
			END