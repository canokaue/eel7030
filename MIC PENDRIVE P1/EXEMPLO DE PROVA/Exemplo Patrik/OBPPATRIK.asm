;OT�VIO BOHN PESSATTI 15100593 

reset        equ  00h								;define onde vai come�ar o programa	 
intex0		 equ  03h								;endere�o do tratador da interrup��o externa 0
intex1		 equ  13h 								;endere�o do tratador da interrup��o externa 1
state	   	 equ  20h								;endere�o da vari�vel de teste

			 org  reset								;come�a o programa do endere�o zero
			 jmp  inicio							;vai para o inicio do c�digo
			 
			 org  intex0							;parte para o endere�o do tratador de intex0
			 cpl  ie.2
			 ;aplicando-se cpl no byte ie.2 est� se variando a habilita��o da interrup��o externa 1. Quando ie.2 estiver setado
			 ;com '1', cpl ir� zerar o byte. Quando ie.2 estiver setado com '0', cpl ir� setar '1' no byte. Assim desabilitando
			 ;intex1 quando estiver habilitada e habilitando quando estiver desabilitada
			 clr  ie1
			 ;faz-se necess�rio limpar o byte ie1, pois o mesmo � posto em n�vel l�gico alto quando existe alguma pend�ncia de 
			 ;atendimento da intex1. Se intex1 n�o estiver habilita e o n�vel l�gico p3.3 baixar, o n�vel l�gico de ie1 subir� 
			 ;registrando que foi solicitada uma interrup��o que n�o pode ser atendida. Limpando-se ie1, garante-se que ao 
			 ;habilitar intex1 a mesma n�o ocorrer� por conta de uma solicita��o feita enquanto intex1 estava desabilitada.
			 reti
			 
			 org  intex1							;parte para o endere�o do tratador de intex1
			 mov  state,#01h						;faz state=1 para sair do loop na linha 31
			 reti									;volta para o programa

inicio:		 mov  ie,#10000101b						;habilita a intex1 e intex0
			 setb it0								;intex0 ativada por borda de descida
			 setb it1								;intex1 ativada por borda de descida
			 
			 mov  r3,#00001111b						
			 ;esse n�mero gravado em r3 ser� usado em uma opera��o de l�gica and com o valor lido em p1, a ideia � anular
			 ;os 4 d�gitos mais significativos, tornando poss�vel a leitura de um n�mero entre #00h e #0fh 
			 
			 mov  state,#00h						;vari�vel de teste=0, visando criar um loop na linha 31
			 mov  r1,#state							;r1 cont�m o endere�o de state para podermos usar a instru��o cnje
			 
dadop1:		 cjne @r1,#01h,dadop1					;fica em um loop at� a chamada da intex1
			 mov  state,#00h						;zera state para poder entrar em loop posteriormente
			 mov  a,p1								;transefere dado lido de p1 para a
			 anl  a,r3								;faz a l�gica and com r3 para zerar os 4 primeiros bytes
			 call converte							;chama subrotina que converter� para o valor ascii
			 mov  p2,a								;transefere o valor convertido para a porta p2
			 jmp  dadop1							;volta para loop onde aguardar� nova intex1
			 
converte:  	 inc  a     							;A � incrementado para pular a instru��o RET ap�s a instru��o seguinte
			 movc a,@a+pc							;A � um n�mero, e o dado do PC cai exatamente em RET, por�m se forem somados o que      
			 ret 									;est� em A ao que est� em PC, vai cair em algum dos n�meros da tabela de dados abaixo
		   
tabela: 	 db 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 41H, 42H, 43H, 44H, 45H, 46H			 
			   ;0	 1	  2	   3	4	 5	  6	   7	8	 9	  a	   b	c	 d	  e	   f  (tabela ascii)
			 end