reset  		equ   0h 								;endere�o do in�cio do programa
ltmr0  		equ   0bh 								;local do tratador
state       equ   20h 								;endere�o de vari�vel de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o in�cio do programa
			
			org   ltmr0								;faz a leitura do endere�o do tratador do tmr0
			inc	  state								;seta a vari�vel de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10000010b     	 			;habilita tmr0 
			mov     tmod,#02h            			;define modo 2 para tmr0 
			mov     th0,#060h						;seta th0 no come�o do programa
			mov     tl0,#060h						;seta tl0 para fazer a primeira contagem
			
			;MODO 2: os registradores th0 e tl0 s�o definidos da seguinte forma: deseja-se que troque-se o caractere a cada 640 ciclos
			;de instru��o, por�m no modo 2 o tl0 funciona como contador e define (quando chega em #0ffh) que a interrup��o do timer ser�
			;solicitada, por�m #0ffh = #255d, ent�o � necess�rio que h� interrup��o seja chamada mais de uma vez antes de ocorrer a troca
			;do caractere. No caso, o programa s� sai do ciclo (linha32) quando a interrup��o tiver sido chamada 4 vezes, ent�o:
			;640/4 = 160, 255-160 = 95 = #05fh ==> ponto de partida #060h
			
			;� importante ressaltar que, ao contr�rio dos modos 0, 1 e 3, no modo 2 n�o � preciso recarregar os valores th0 e tl0
			;no tratador de interrup��o, o tl0 sempre vai receber o valor especificado para th0 no programa.
			
			mov     state,#0h 						;define vari�vel de teste com sendo 0
			mov     r0,#state 						;salva o endere�o da vari�vel em r0
			mov 	dptr,#tabela					;salva no dptr o endere�o das infos da tabela
			mov     r1,#0							;r1 ser� usado como teste para saber se j� foram os 16 caracteres
			setb	tr0								;inicia a contagem
				
volta:    	cjne    @r0,#4,volta					;fica preso at� acabar a contagem e chamar a interrup��o

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da pr�xima busque-se o caracter seguinte
			cjne 	r1,#16,volta					;testa se j� n�o foram os 16 caracteres
			mov		r1,#0							;reseta r1
			jmp  	volta							;volta para o ciclo
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 