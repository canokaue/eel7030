reset  		equ   0h 								;endere�o do in�cio do programa
ltmr0  		equ   0bh 								;local do tratador
intex1		equ	  13h								;tratador intex1
state       equ   20h 								;endere�o de vari�vel de teste para quebrar ciclo do timer0
state1		equ	  30h								;endere�o da vari�vel de teste para quebrar ciclo da intex1

		    org   reset								;PC=0 depois de reset
			jmp   inicio 							;vai para o in�cio do programa
			
			org   ltmr0								;faz a leitura do endere�o do tratador do Itmr0
			jmp	  handlert							;vai para o tratador do Itmr0

			org	  intex1							;faz a leitura do endere�o do tratador de intex1
			jmp	  handleri							;vai para o tratador de intex1

inicio:    	mov		ie,#10000110b     	 			;habilita tmr0 e intex1
			setb	it1								;interrup��o por borda de descida
			mov     tmod,#02h            			;define modo 2 para tmr0 
			mov     th0,#060h						;seta th0 no come�o do programa
			mov     tl0,#060h						;seta tl0 para fazer a primeira contagem
			
			;MODO 2: os registradores th0 e tl0 s�o definidos da seguinte forma: deseja-se que troque-se o caractere a cada 640 ciclos
			;de instru��o, por�m no modo 2 o tl0 funciona como contador e define (quando chega em #0ffh) que a interrup��o do timer ser�
			;solicitada, por�m #0ffh = #255d, ent�o � necess�rio que h� interrup��o seja chamada mais de uma vez antes de ocorrer a troca
			;do caractere. No caso, o programa s� sai do ciclo (linha31) quando a interrup��o tiver sido chamada 4 vezes, ent�o:
			;640/4 = 160, 255-160 = 95 = #05fh ==> ponto de partida #060h
			
			mov     state,#0h 						;define vari�vel de teste (timer0) como sendo 0
			mov     r0,#state 						;usa r0 como ponteiro para state
			mov		state1,#0h						;define vari�vel de teste (intex1) como sendo 0
			mov		r1,#state1						;usa r1 como ponteiro para state1
			mov 	dptr,#tabela					;salva no dptr o endere�o das infos da tabela
			mov     r2,#0							;r2 ser� usado como teste para saber se j� foram os 16 caracteres
			setb	tr0								;inicia a contagem

			;No trecho seguinte do c�digo, o programa vai ficar alternando entre as linhas 40 e 42 para ver qual interrup��o ser� 
			;solicitada primeiro...timer0 ou intex1, aquela que acontecer primeiro vai, atrav�s do seu tratador, direcionar o 
			;programa para mudar a porta p1 (timer0) ou mudar o tempo de contagem do timer0 (intex1)

volta:    	cjne    @r0,#4,volta1					;@r0 � incrementado a cada 160 ciclos, por isso "#4"
			jmp		cgcar							;pula para trecho que vai mudar a porta p1
volta1:		cjne	@r1,#1,volta					;vai sair do ciclo caso intex1 seja solicitada

			mov		state1,#0h						;zera a vari�vel de teste da intex1
			mov		a,p2							;joga em "a" o valor de p2
			mov		th0,a							;envia para th0
			mov		tl0,a							;e para tl0
			jmp		volta							;volta para o ciclo das linhas 40 e 42

cgcar:		mov 	state,#0h						;zera a vari�vel de teste do timer0
			mov     a,r2							;define qual o caracter a ser jogado em p1
			movc 	a,@a+dptr 						;salva em A o valor do caracter da vez
			mov  	p1,a							;joga em p1
			inc  	r2								;incrementa r2 para que da pr�xima busque-se o caracter seguinte
			cjne 	r2,#16,volta					;testa se j� n�o foram os 16 caracteres
			mov 	r2,#0h							;como � c�clico ele zera r2
			jmp  	volta							;volta para o come�o

handlert:   inc	  state								;aumenta a vari�vel de teste para sair do ciclo
			reti									;retorna ao programa

handleri:	mov	  state1,#1							;seta a vari�vel de teste para sair do ciclo
			reti									;retorna ao programa

tabela: 	db 'Microcontrolador'					;caracteres a serem jogados em p1
			end 