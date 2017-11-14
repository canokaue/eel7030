reset  		equ   0h 								;endereço do início do programa
ltmr1  		equ   1bh 								;local do tratador de timer1
state       equ   20h 								;endereço de variável de teste

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o início do programa
			
			org   ltmr1								;faz a leitura do endereço do tratador do tmr1
			mov   th1,  #0ech						;recarrega th1 com seu valor desejado #0ech
			mov   tl1,  #00h						;recarrega tl1 com seu valor desejado #00h
			mov   state,#1h							;seta a variável de teste para sair do ciclo
			reti

inicio:    	mov		ie,#10001000b     	 			;habilita tmr1 
			mov     tmod,#00h            			;define modo 0 para tmr1
			mov     th1,#0ech						;seta th1 no começo do programa
			mov     tl1,#00h						;seta tl1 para fazer a primeira contagem
			
			;MODO 0: os valores de th0 e tl0 são definidos da seguinte forma: deseja-se que a interrupção do timer seja solicitada
			;em intervalos de 640 ciclos de instrução. th1 aumenta cada vez ocorre overflow nos 5 LSB do tl1, o que é equivalente à 
			;ocorrência de 32 ciclos de instrução. Desejamos 640 ciclos, como 640/32 = 20, é preciso que o th1 seja incrementado 20
			;vezes, (#ffh = #255b) então th1 = #255d-#19d = #236d = #0ech = th1, sendo th1 = 0 para começar a contagem. 
			
			mov     state,#0h 						;define variável de teste com sendo 0
			mov     r0,#state 						;salva o endereço da variável em r0
			mov 	dptr,#tabela					;salva no dptr o endereço das infos da tabela
			mov     r1,#0							;r1 será usado como teste para saber se já foram os 16 caracteres
			setb	tr1								;inicia a contagem
				
volta:    	cjne    @r0,#1,volta					;fica preo até acabar a contagem e chamar a interrupção

			mov 	state,#0h						;recupera valor de state
			mov     a,r1							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r1								;incrementa r1 para que da próxima busque-se o caracter seguinte
			cjne 	r1,#16,volta					;testa se já não foram os 16 caracteres
			clr     tr1								;se já tiver terminado ele para de contar
			jmp  	$								; e fica aqui de buenas
			
tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1

			end 