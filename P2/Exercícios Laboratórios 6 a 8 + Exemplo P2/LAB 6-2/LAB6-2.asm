reset  		equ   0h 								;endere�o do in�cio do programa
ltmr1  		equ   1bh 								;local do tratador de timer1
state       equ   20h 								;endere�o de vari�vel de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o in�cio do programa
			
			org   ltmr1								;faz a leitura do endere�o do tratador do tmr1
			mov   th1,  #0ech						;recarrega th1 com seu valor desejado #0ech
			mov   tl1,  #00h						;recarrega tl1 com seu valor desejado #00h
			mov   state,#1h							;seta a vari�vel de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10001000b     	 			;habilita tmr1 
			mov     tmod,#00h            			;define modo 0 para tmr1
			mov     th1,#0ech						;seta th1 no come�o do programa
			mov     tl1,#00h						;seta tl1 para fazer a primeira contagem
			
			;MODO 0: os valores de th0 e tl0 s�o definidos da seguinte forma: deseja-se que a interrup��o do timer seja solicitada
			;em intervalos de 640 ciclos de instru��o. th1 aumenta cada vez ocorre overflow nos 5 LSB do tl1, o que � equivalente � 
			;ocorr�ncia de 32 ciclos de instru��o. Desejamos 640 ciclos, como 640/32 = 20, � preciso que o th1 seja incrementado 20
			;vezes, (#ffh = #255b) ent�o th1 = #255d-#19d = #236d = #0ech = th1, sendo th1 = 0 para come�ar a contagem. 
			
			mov     state,#0h 						;define vari�vel de teste com sendo 0
			mov     r0,#state 						;salva o endere�o da vari�vel em r0
			mov 	dptr,#tabela					;salva no dptr o endere�o das infos da tabela
			mov     r1,#0							;r1 ser� usado como teste para saber se j� foram os 16 caracteres
			setb	tr1								;inicia a contagem
				
volta:    	cjne    @r0,#1,volta					;fica preo at� acabar a contagem e chamar a interrup��o

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da pr�xima busque-se o caracter seguinte
			cjne 	r1,#16,volta					;testa se j� n�o foram os 16 caracteres
			clr     tr1								;se j� tiver terminado ele para de contar
			jmp  	$								; e fica aqui de buenas
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 