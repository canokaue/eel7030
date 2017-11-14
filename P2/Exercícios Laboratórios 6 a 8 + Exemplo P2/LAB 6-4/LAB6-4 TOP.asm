reset  		equ   0h 								;endereço do início do programa
ltmr0  		equ   0bh 								;local do tratador de Itmr0
Itmr1		equ	  1bh								;local do tratador de Itmr1
state       equ   20h 								;endereço de variável de teste para tmr0
state1		equ	  30h								;endereço de variável de teste para tmr1				

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o início do programa
			
			org   ltmr0								;faz a leitura do endereço do tratador do tmr0
			mov   th0,  #05fh						;recarrega th0 com seu valor desejado #05fh
			mov   tl0,  #05fh						;recarrega tl0 com seu valor desejado #05fh
			inc	  state								;seta a variável de teste para sair do ciclo
			reti									;retorna ao programa
			
			org	  Itmr1								;faz a leitura do endereço do tratador do tmr1
			mov	  th1,#0e2h							;recarrega th1 com o valor desejado #0e2h
			mov	  tl1,#00h							;recarrega tl1 com o valor desejado #00h
			mov	  state1,#1							;seta a variável de teste para sair do ciclo
			reti									;retorna ao programa

inicio:    	mov		ie,#10001010b     	 			;habilita tmr0 e tmr1 
			mov     tmod,#02h            			;define modo 0 para tmr1 e modo 2 para tmr0
			mov		th1,#0e2h						;seta th1 no começo do programa
			mov		tl1,#00h						;seta tl1 para fazer a primeira contagem
inicio1:	mov     th0,#05fh						;seta th0 no começo do programa
			mov     tl0,#05fh						;seta tl0 para fazer a primeira contagem
						
			;MODO 2 (timer 0): os valores de th0 e tl0 são definidos da seguinte forma: deseja-se que a interrupção do timer0 seja
			;a cada 640 ciclos de instrução. A interrupção é solicitada cada vez que tl0 atinge #0ffh, feito isso, tl0 é recarregado 
			;com o valor definifo em th0. Desejamos 640 ciclos, porém #0ffh = #255d, logo no ciclo é preciso fazer com que a variável
			;de teste seja comparada com #4 e no tratador do timer, incrementa-se a variável.#640d/4 = #160d, #255d - #160d = #95d = #5fh
			;Atribui-se então th0 = tl0 = #5fh			
						
			;MODO 0 (timer1): os valores de th1 e tl1 são definidos da seguinte forma: deseja-se que a interrupção do timer1 seja 
			;a cada 960 ciclos de instrução. th1 aumenta cada vez que ocorre overflow nos 5 lsb de tl1, o que é equivalente à ocorrência
			;de 32 ciclos de instrução. Desejamos 960 ciclos, como 960/32 = 30, é preciso que o th1 seja incrementado 30 vezes,
			;(#ffh = #255d) então th1 = #255d-#29d = #226d = #0e2h = th1, começando tl1=0.
			
			mov     state,#0h 						;define variável de teste de timer0 como sendo 0
			mov     r0,#state 						;salva o endereço da variável em r0
			mov		state1,#0h						;define variável de teste de timer1 como sendo 1
			mov		r1,#state1						;salva o endereço da variável em r1
			mov 	dptr,#tabela					;salva no dptr o endereço das infos da tabela
			mov     r2,#0							;r2 será usado como teste para saber se já foram os 16 caracteres
			mov		r7,#00001000b					;número para fazer xor com p2, quando chamar timer1
			setb	tr0								;inicia a contagem timer0
			setb	tr1								;inicia a contagem timer1
			
volta:    	cjne	@r1,#1,volta1					;testa a variável de teste do timer 1
			jmp		setp2							;state = #1, pula para setp2, onde vai alterar a porta p2.3
volta1:		cjne    @r0,#4,volta					;fica preso até acabar a contagem e chamar a interrupção

			mov 	state,#0h						;recupera valor de state
			mov     a,r2							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r2								;incrementa r1 para que da próxima busque-se o caracter seguinte
			cjne 	r2,#16,volta					;testa se já não foram os 16 caracteres
			mov		r2,#0							;reseta r2 para voltar ao ciclo
			jmp  	volta   						;e reseta os dados do timer 0
			
setp2:		mov		state1,#0h						;zera variável de teste
			mov		a,p2							;joga no acumulador o valor de p2
			xrl		a,r7							;xor com r7 para mudar o byte que estiver na porta p2.3
			mov		p2,a							;joga de volta para p2
			jmp		volta							;volta para o ciclo
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end