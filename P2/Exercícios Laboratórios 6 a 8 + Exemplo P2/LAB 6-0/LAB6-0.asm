reset  		equ   0h 								;endereço do início do programa
ltmr0  		equ   0bh 								;local do tratador
state       equ   20h 								;endereço de variável de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o início do programa
			
			org   ltmr0								;faz a leitura do endereço do tratador do tmr0
			mov   th0,  #0ffh						;recarrega th0 com seu valor desejado #0ffh
			mov   tl0,  #09ch						;recarrega tl0 com seu valor desejado #9ch
			mov   state,#1h							;seta a variável de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10000010b     	 			;habilita tmr0 
			mov     tmod,#01h            			;define modo 1 para tmr0
			mov     th0,#0ffh						;seta th0 no começo do programa
			mov     tl0,#09ch						;seta tl0 para fazer a primeira contagem
			
			;MODO 1: os valores de th0 e tl0 são definidos da seguinte forma: deseja-se que a interrupção do timer seja solicitada
			;em intervalos de 100 ciclos de instrução. Subtraímos 100 de 2^16, e analisamos o resultado dessa conta em hex
			;(2^16)-100 = #65436b = #FF9Ch, os dois MSB são alocados em th0 e os LSB são alocados em tl0
			
			mov     state,#0h 						;define variável de teste com sendo 0
			mov     r0,#state 						;salva o endereço da variável em r0
			mov 	dptr,#tabela					;salva no dptr o endereço das infos da tabela
			mov     r1,#0							;r1 será usado como teste para saber se já foram os 16 caracteres
			setb	tr0								;inicia a contagem
				
volta:    	cjne    @r0,#1,volta					;fica preso até acabar a contagem e chamar a interrupção

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da próxima busque-se o caractere seguinte
			cjne 	r1,#16,volta					;testa se já não foram os 16 caracteres
			clr     tr0								;se já tiver terminado ele para de contar
			jmp  	$								; e fica aqui de buenas
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 