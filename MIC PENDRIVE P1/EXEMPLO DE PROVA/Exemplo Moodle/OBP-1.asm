;OTÁVIO BOHN PESSATTI EEL 7030

reset        equ  00h								;define onde vai começar o programa	 
intex1		 equ  13h 								;local tratador int ext 1
state	   	 equ  20h								;endereço acima dos registradores para ser usado
rp1			 equ  30h								;endereço, recolhe p1

			 org  reset								;começa o programa do endereço zero
			 jmp  inicio							;vai para o inicio do código
			 
			 org  intex1							;parte para o endereço do tratador de intex1
			 mov  state,#01h						;faz state=1 para sair do loop em em (22) ou (26)
			 reti									;volta para o programa

inicio:		 mov  ie,#10000100b						;habilita a intex1
			 setb it1								;intex1 ativada por borda de descida
			 mov  state,#00h						;define state como sendo 0
			 mov  r1,#state							;r1 contém o endereço de state
			 mov  a,#11110111b						;joga essa valor no A
			 mov  p2,a								;apaga um led
			 
dado1:		 cjne @r1,#01h,dado1					;fica em um loop até a chamada da intex1
			 mov  state,#00h						;zera state para poder entrar em loop posteriormente
			 mov  r2,p1								;salva dado1 de p1 em r2
			 
dado2:		 cjne @r1,#01h,dado2					;fica em um loop até a chamada da intex1
			 mov  state,#00h						;zera state para poder entrar em loop posteriormente
			 mov  r3,p1								;salva dado1 de p1 em r3
			 
			 cjne r2,#00h,rotr						;dependendo do valor de dado1 a rotação vai ser para a esquerda ou direita

rotl:        rl   a									;rotaciona a para a esquerda
			 mov  p2,a								;joga novo valor de A nos leds
			 djnz r3,rotl							;decrementa o dado2 para definir se continua ou não a rotação
			 jmp  dado1								;volta para o primeiro loop de colheita de dado
			 
rotr:		 rr	  a									;rotaciona a para a direita							
			 mov  p2,a								;joga novo valor de A nos leds
			 djnz r3,rotr							;decrementa o dado2 para definir se continua ou não a rotação
			 jmp  dado1								;volta para o primeiro loop de colheita de dado
			 
			 end