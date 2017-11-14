reset  		equ   0h 								;endere�o do in�cio do programa
ltmr0  		equ   0bh 								;local do tratador
state       equ   20h 								;endere�o de vari�vel de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o in�cio do programa
			
			org   ltmr0								;faz a leitura do endere�o do tratador do tmr0
			mov   th0,  #0fdh						;recarrega th0 com seu valor desejado #0fdh
			mov   tl0,  #081h						;recarrega tl0 com seu valor desejado #081h
			mov   state,#1h							;seta a vari�vel de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10000010b     	 			;habilita tmr0 
			mov     tmod,#01h            			;define modo 1 para tmr0
			mov     th0,#0fdh						;seta th0 no come�o do programa
			mov     tl0,#081h						;seta tl0 para fazer a primeira contagem
			
			;MODO 1: os valores de th0 e tl0 s�o definidos da seguinte forma: deseja-se que a interrup��o do timer seja solicitada
			;em intervalos de 640 ciclos de instru��o. Subtra�mos 640 de 2^16, e analisamos o resultado dessa conta em hex
			;(2^16)-640 = #64896d = #fd80h, os dois MSB s�o alocados em th0 e os (LSB+1) s�o alocados em tl0
			
			;A cada ocorr�ncia de 640 ciclos de instru��o � chamada a interrup��o, ap�s a execu��o da mesma e da leitura de algumas
			;linhas de comando � que o caractere vai ser enviado para a porta p1, por isso existe uma certa defasagem at� o envio
			;da informa��o para a porta p1
			
			;as �nicas altera��es feitas foram na defini��o de th0 e tl0 (linhas 9,10,16 e 17)
			
			mov     state,#0h 						;define vari�vel de teste com sendo 0
			mov     r0,#state 						;salva o endere�o da vari�vel em r0
			mov 	dptr,#tabela					;salva no dptr o endere�o das infos da tabela
			mov     r1,#0							;r1 ser� usado como teste para saber se j� foram os 16 caracteres
			setb	tr0								;inicia a contagem
				
volta:    	cjne    @r0,#1,volta					;fica preo at� acabar a contagem e chamar a interrup��o

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da pr�xima busque-se o caracter seguinte
			cjne 	r1,#16,volta					;testa se j� n�o foram os 16 caracteres
			clr     tr0								;se j� tiver terminado ele para de contar
			jmp  	$								; e fica aqui de buenas
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 