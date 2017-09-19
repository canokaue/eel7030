;OTÁVIO BOHN PESSATTI 15100593 

reset        equ  00h								;define onde vai começar o programa	 
intex0		 equ  03h								;endereço do tratador da interrupção externa 0
intex1		 equ  13h 								;endereço do tratador da interrupção externa 1
state	   	 equ  20h								;endereço da variável de teste

			 org  reset								;começa o programa do endereço zero
			 jmp  inicio							;vai para o inicio do código
			 
			 org  intex0							;parte para o endereço do tratador de intex0
			 cpl  ie.2
			 ;aplicando-se cpl no byte ie.2 está se variando a habilitação da interrupção externa 1. Quando ie.2 estiver setado
			 ;com '1', cpl irá zerar o byte. Quando ie.2 estiver setado com '0', cpl irá setar '1' no byte. Assim desabilitando
			 ;intex1 quando estiver habilitada e habilitando quando estiver desabilitada
			 clr  ie1
			 ;faz-se necessário limpar o byte ie1, pois o mesmo é posto em nível lógico alto quando existe alguma pendência de 
			 ;atendimento da intex1. Se intex1 não estiver habilita e o nível lógico p3.3 baixar, o nível lógico de ie1 subirá 
			 ;registrando que foi solicitada uma interrupção que não pode ser atendida. Limpando-se ie1, garante-se que ao 
			 ;habilitar intex1 a mesma não ocorrerá por conta de uma solicitação feita enquanto intex1 estava desabilitada.
			 reti
			 
			 org  intex1							;parte para o endereço do tratador de intex1
			 mov  state,#01h						;faz state=1 para sair do loop na linha 31
			 reti									;volta para o programa

inicio:		 mov  ie,#10000101b						;habilita a intex1 e intex0
			 setb it0								;intex0 ativada por borda de descida
			 setb it1								;intex1 ativada por borda de descida
			 
			 mov  r3,#00001111b						
			 ;esse número gravado em r3 será usado em uma operação de lógica and com o valor lido em p1, a ideia é anular
			 ;os 4 dígitos mais significativos, tornando possível a leitura de um número entre #00h e #0fh 
			 
			 mov  state,#00h						;variável de teste=0, visando criar um loop na linha 31
			 mov  r1,#state							;r1 contém o endereço de state para podermos usar a instrução cnje
			 
dadop1:		 cjne @r1,#01h,dadop1					;fica em um loop até a chamada da intex1
			 mov  state,#00h						;zera state para poder entrar em loop posteriormente
			 mov  a,p1								;transefere dado lido de p1 para a
			 anl  a,r3								;faz a lógica and com r3 para zerar os 4 primeiros bytes
			 call converte							;chama subrotina que converterá para o valor ascii
			 mov  p2,a								;transefere o valor convertido para a porta p2
			 jmp  dadop1							;volta para loop onde aguardará nova intex1
			 
converte:  	 inc  a     							;A é incrementado para pular a instrução RET após a instrução seguinte
			 movc a,@a+pc							;A é um número, e o dado do PC cai exatamente em RET, porém se forem somados o que      
			 ret 									;está em A ao que está em PC, vai cair em algum dos números da tabela de dados abaixo
		   
tabela: 	 db 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 41H, 42H, 43H, 44H, 45H, 46H			 
			   ;0	 1	  2	   3	4	 5	  6	   7	8	 9	  a	   b	c	 d	  e	   f  (tabela ascii)
			 end