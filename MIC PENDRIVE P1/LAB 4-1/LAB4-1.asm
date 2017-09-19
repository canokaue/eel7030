reset 	equ 00h										;endere�o da mem�ria de programa
intex0 	equ 03h 									;local tratador de intex0
intex1	equ 13h										;local tratador de intex1
state0 	equ 20h										;endere�o de vari�vel de teste

		org 	reset 								;PC=0 depois de reset
		jmp 	inicio								;vai para o in�cio do programa

		org 	intex0								;PC=endere�o do tratador de intex0
		jmp 	handler0							;salta para o tratador
	
		org		intex1								;PC=endere�o do tratador de intex1
		jmp		handler1							;salta para o tratador
		
inicio: mov ie,#10000100b 							;habilita intex1		
		setb it0 									;intex0 por borda
		setb it1									;intex1 por borda
		
		mov state0,#0h 								;inicializa��o da vari�vel
		mov r0,#state0								;salva o endere�o dela em r0
		mov dptr,#tabela							;salva no dptr o endere�o da tabela de dados
		mov r2,#0									;contador de interrup��es
	
volta:	cjne @r0,#1,volta							;fica em loop at� que intex0 seja executada
		mov state0,#0h								;retorna state0 para poder ficar em loop depois novamente
		mov a,r2									;joga o n�mero da vez no acumulador
		movc a,@a+dptr								;joga em A a letra da vez
		mov p1,a									;joga nos leds
		inc r2										;incrementa o n�mero da vez
		cjne r2,#16,volta							;verifica se j� n�o foram as 16 letras
		jmp $										;caso afirmativo, entra em um loop maroto

handler0:		mov state0,#1h						;muda state para sair do loop
				reti								;volta ao programa
	
handler1:       cpl ex0								;muda o byte que habilita intex0
				clr	ie0								;limpa o byte de pend�ncia de atendimento de intex0
				reti								;volta ao programa
				
tabela: 		db 'Microcontrolador'
				end