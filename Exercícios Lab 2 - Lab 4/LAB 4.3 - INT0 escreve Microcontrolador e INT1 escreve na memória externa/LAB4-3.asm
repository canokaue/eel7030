;consegui fazer o que o exercício solicita, mas usei registrador na interrupção

reset        equ  00h								;define onde vai começar o programa	 
ltint0       equ  03h 								;local tratador int ext 0
ltint1		 equ  13h 								;local tratador int ext 1
state0	   	 equ  30h								;variavel de teste para intex0 e intex1
state1		 equ  40h								;variável de teste para intex1

	 org reset   									;PC=0 depois de reset     
	 jmp inicio										;vai para o inicio do programa
	 
     org ltint0										;começa do endereço apropriado da interrupção externa 0
     jmp handler0 									;e pula para seu tratador de interrupção
	 
	 org ltint1										;começa do endereço apropriado da interrupção externa 1
	 jmp handler1									;e pula para o seu tratador de interrupção
 
inicio:       mov   ie,#10000101b     				;habilita intex0 e intex1
			  setb  it0    	          				;define intex0 habilitada por borda de descida 
			  setb	it1								;define intex1 habilitada por borda de descida
			  
			  clr	rs1								;msb do banco de registradores
			  setb	rs0								;lsb do banco de registradores
			  
			  mov  sp,#50h							;joga o sp na pqp pra não atrapalhar o banco de registradores
			  
			  mov  state0,#0h 						;limpa a variável de teste     	
			  mov  r0,#state0     					;salva o endereço da variável em r0
			  mov  dptr,#tabela     				;salva o endereço das informações a serem jogadas por interrupção no dptr
			  mov  r2,#0 							;contador das intex0
			  
			  mov  p2,#20h							;msb do endereço de memória externa
			  mov  r1,#00h							;lsb do end. de memória externa / contador das intex1
			  
volta:     cjne  @r0,#1,volta  						;compara o valor salvo em state0 com 1 para ficar em um loop
		   mov   state0,#0h      					;loop quebrado, volta o valor de state0 para loop futuro
		   mov 	 r3,state1							;joga a variavel de teste de intex1 em r3
		   cjne  r3,#0h,sepa						;se o loop tiver sido quebrado por intex1, ele salta para sepa
		   mov   a,r2      							;joga o atual caractere que está sendo lido
		   movc  a,@a+dptr      					;acrescenta ao endereço do dptr para mover ao acumulador o caractere certo
		   inc   r2 					    	    ;incrementa r2 para a próxima rodada
		   jmp   ola								;vai para ola, onde porá o valor correto nos leds
		   
sepa:	   mov	 r3,#0h								;limpa o valor de r3
		   mov   state1,#0h							;limpa o valor da variável de teste de intex1
		   movx   @r1,a								;joga o acumulador no endereço de memória externa
		   inc   r1									;atualiza para o próximo endereço
		   cjne  r1,#0fh,volta						;verifica se daí já não salvou os números
		   jmp   inicio								;em caso afirmativo volta para o início
		   
ola:	   mov   p1,a			 					;joga o valor do acumulador nos leds
		   cjne  r2,#0fh,volta      				;compara R2 com #0fh para ver se já não foram todos os caracteres
		   jmp   inicio								;quando acabarem os caracteres volta ao inicio
		   
handler0:   mov   state0,#1h             			;seta a variável para quebrar o loop em (35)
			reti									;volta para o programa

handler1:	mov	  state1,#1h						;seta a variável de teste para desviar o fluxo em (38)
			mov   state0,#1h						;seta a variável para quebrar o loop em (35)
			reti									;volta para o programa
			
tabela:  db 'Microcontrolador'  					;caracteres definidos
		 end 