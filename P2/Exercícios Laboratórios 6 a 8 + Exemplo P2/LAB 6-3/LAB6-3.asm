reset  		equ   0h 								;endereço do início do programa
ltmr0  		equ   0bh 								;local do tratador
state       equ   20h 								;endereço de variável de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o início do programa
			
			org   ltmr0								;faz a leitura do endereço do tratador do tmr0
			inc	  state								;seta a variável de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10000010b     	 			;habilita tmr0 
			mov     tmod,#02h            			;define modo 2 para tmr0 
			mov     th0,#060h						;seta th0 no começo do programa
			mov     tl0,#060h						;seta tl0 para fazer a primeira contagem
			
			;MODO 2: os registradores th0 e tl0 são definidos da seguinte forma: deseja-se que troque-se o caractere a cada 640 ciclos
			;de instrução, porém no modo 2 o tl0 funciona como contador e define (quando chega em #0ffh) que a interrupção do timer será
			;solicitada, porém #0ffh = #255d, então é necessário que há interrupção seja chamada mais de uma vez antes de ocorrer a troca
			;do caractere. No caso, o programa só sai do ciclo (linha32) quando a interrupção tiver sido chamada 4 vezes, então:
			;640/4 = 160, 255-160 = 95 = #05fh ==> ponto de partida #060h
			
			;é importante ressaltar que, ao contrário dos modos 0, 1 e 3, no modo 2 não é preciso recarregar os valores th0 e tl0
			;no tratador de interrupção, o tl0 sempre vai receber o valor especificado para th0 no programa.
			
			mov     state,#0h 						;define variável de teste com sendo 0
			mov     r0,#state 						;salva o endereço da variável em r0
			mov 	dptr,#tabela					;salva no dptr o endereço das infos da tabela
			mov     r1,#0							;r1 será usado como teste para saber se já foram os 16 caracteres
			setb	tr0								;inicia a contagem
				
volta:    	cjne    @r0,#4,volta					;fica preso até acabar a contagem e chamar a interrupção

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da próxima busque-se o caracter seguinte
			cjne 	r1,#16,volta					;testa se já não foram os 16 caracteres
			mov		r1,#0							;reseta r1
			jmp  	volta							;volta para o ciclo
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 