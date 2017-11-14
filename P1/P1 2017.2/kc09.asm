; Kaue Cano 15101142   TURMA 04235A

; Update Frequency: 100

            DELAY   EQU		30H					;atraso aponta para 30h				
			ORG		00H							;pc em zero

INICIO:		

			MOV		R2,#08H						;comparador de numero de rotacoes
			MOV		R6,#00H						;seleciona para qual lado ira rodar os leds 
			MOV		R5,#00H						;operador "filtro" do carry
			MOV 	R4,#01H						;inicia a acender pela direita do binario
			MOV		R3,#01H						;configuracao base que, rotacionada e somada, "aciona" mais leds

LOOP1:		MOV		A,R4						;resgate da configuração atual dos leds
			MOV		P1,A						;transfere esta configuracao para P1
			MOV		DELAY,#0FFH				    ;define-se um numero atraso para ser decrementado a zero
			CALL 	DECREMENT					;chama subrotina decrementadora
			CALL	RLA							;chama subrotina que rotaciona A para a esquerda
			DJNZ	R2,LOOP1					;executa o LOOP1 oito vezes 
			
			MOV		R2,#08H						;redefine o comparador para o proximo passo
			MOV		R6,#01H						;prepara R6 para redirecionar a RRA
			MOV		R3,#10000000B				;redefine a configuracao base em R3 para "apagar" leds
			
			
LOOP2:		CALL 	RLA							;chama a subrotina de rotacionar A
			MOV		A,R4						;transfere o valor atual para o acumulador
			MOV 	P1,A						;transfere o valor atual para P1
			MOV		DELAY,#0FFH				    ;define-se um atraso para o processo
			CALL 	DECREMENT					;chama a subrotina que "gasta" o delay
			DJNZ	R2,LOOP2					;roda LOOP2 oito vezes
			JMP 	INICIO   					;reinicia, eternamente
			
RLA:		CJNE	R6,#00H,RRA					;R6=0 ira somar os leds para a esquerda, enquanto R6=1 vai subtrair os leds para a direita
			
			MOV		A,R3						;resgate da configuracao base contida em R3
			RLC		A							;rotaciona esta configuracao para a esquerda
			MOV		R3,A						;salva ela de volta em R3
			MOV		A,R4						;resgate da configuracao atual dos leds
			ADDC	A,R3						;soma o a configuracao atual com a rotacionada e o carry
			SUBB	A,R5						;tira o carry
			MOV		R4,A						;salva o resultado na configuracao atual
			JMP 	RETURN						;vai para o RET
			
RRA:		MOV		A,R4                        ;joga o valor atual no acumulador
			SUBB	A,R3						;substrai a configuracao atual da base subtratora
			ADDC	A,R5						;filtra de antemao o carry
			MOV		R4,A 						;salva o resultado na configuracao atual
			MOV		A,R3						;move a configuracao base para o acumulador
			RRC		A 							;rotaciona a configuracao base para a direita
			MOV		R3,A 						;salva esta nova base subtratora
RETURN:	    RET									;sai da subrotina
			
DECREMENT:	DJNZ	DELAY,DECREMENT			    ;decrementa DELAY até ele chegar a zero
			RET									;sai da subrotina
			
			END
