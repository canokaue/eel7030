;consegui fazer o que o exerc�cio solicita, mas usei registrador na interrup��o

reset        equ  00h								;define onde vai come�ar o programa	 
ltint0       equ  03h 								;local tratador int ext 0
ltint1		 equ  13h 								;local tratador int ext 1
state0	   	 equ  30h								;variavel de teste para intex0 e intex1
state1		 equ  40h								;vari�vel de teste para intex1

	 org reset   									;PC=0 depois de reset     
	 jmp inicio										;vai para o inicio do programa
	 
     org ltint0										;come�a do endere�o apropriado da interrup��o externa 0
     jmp handler0 									;e pula para seu tratador de interrup��o
	 
	 org ltint1										;come�a do endere�o apropriado da interrup��o externa 1
	 jmp handler1									;e pula para o seu tratador de interrup��o
 
inicio:       mov   ie,#10000101b     				;habilita intex0 e intex1
			  setb  it0    	          				;define intex0 habilitada por borda de descida 
			  setb	it1								;define intex1 habilitada por borda de descida
			  
			  clr	rs1								;msb do banco de registradores
			  setb	rs0								;lsb do banco de registradores
			  
			  mov  sp,#50h							;joga o sp na pqp pra n�o atrapalhar o banco de registradores
			  
			  mov  state0,#0h 						;limpa a vari�vel de teste     	
			  mov  r0,#state0     					;salva o endere�o da vari�vel em r0
			  mov  dptr,#tabela     				;salva o endere�o das informa��es a serem jogadas por interrup��o no dptr
			  mov  r2,#0 							;contador das intex0
			  
			  mov  p2,#20h							;msb do endere�o de mem�ria externa
			  mov  r1,#00h							;lsb do end. de mem�ria externa / contador das intex1
			  
volta:     cjne  @r0,#1,volta  						;compara o valor salvo em state0 com 1 para ficar em um loop
		   mov   state0,#0h      					;loop quebrado, volta o valor de state0 para loop futuro
		   mov 	 r3,state1							;joga a variavel de teste de intex1 em r3
		   cjne  r3,#0h,sepa						;se o loop tiver sido quebrado por intex1, ele salta para sepa
		   mov   a,r2      							;joga o atual caractere que est� sendo lido
		   movc  a,@a+dptr      					;acrescenta ao endere�o do dptr para mover ao acumulador o caractere certo
		   inc   r2 					    	    ;incrementa r2 para a pr�xima rodada
		   jmp   ola								;vai para ola, onde por� o valor correto nos leds
		   
sepa:	   mov	 r3,#0h								;limpa o valor de r3
		   mov   state1,#0h							;limpa o valor da vari�vel de teste de intex1
		   movx   @r1,a								;joga o acumulador no endere�o de mem�ria externa
		   inc   r1									;atualiza para o pr�ximo endere�o
		   cjne  r1,#0fh,volta						;verifica se da� j� n�o salvou os n�meros
		   jmp   inicio								;em caso afirmativo volta para o in�cio
		   
ola:	   mov   p1,a			 					;joga o valor do acumulador nos leds
		   cjne  r2,#0fh,volta      				;compara R2 com #0fh para ver se j� n�o foram todos os caracteres
		   jmp   inicio								;quando acabarem os caracteres volta ao inicio
		   
handler0:   mov   state0,#1h             			;seta a vari�vel para quebrar o loop em (35)
			reti									;volta para o programa

handler1:	mov	  state1,#1h						;seta a vari�vel de teste para desviar o fluxo em (38)
			mov   state0,#1h						;seta a vari�vel para quebrar o loop em (35)
			reti									;volta para o programa
			
tabela:  db 'Microcontrolador'  					;caracteres definidos
		 end 