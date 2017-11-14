;Programa  MOSTRA1.asm 
	
	RESET	  EQU		00H 							;define o in�cio do programa em c:00h
	INTEX0	  EQU   	03H								;local do tratador de intex0
	INTEX1	  EQU  		13H								;local do tratador de intex1
	STATE0	  EQU		20H								;mem�ria a ser alterada nas interrup��es 0
	STATE1	  EQU		22H								;mem�ria a ser alterada nas interrup��es 1
	VETOR	  EQU		30H
	ATRASO	  EQU		01H	
		
			  ORG	RESET								;origem do programa
			  JMP	INICIO								;pula para o in�cio
			  
			  ORG	INTEX0								;origem do intex0
			  JMP	HANDLER0							;pula para o tratador de interrup��o 0
			  
			  ORG	INTEX1								;origem do intex1
			  JMP   HANDLER1							;pula para o tratador de interrup��o 1
			  
INICIO:		  MOV IE,#10000101B							;habilita interrup��es externas 0 e 1
			  SETB IT0									;intex0 por borda de descida
			  SETB IT1									;intex1 por borda de descida
			  
			  MOV STATE0,#0H							;define vari�vel da intex0 como sendo 0
			  MOV R0,#STATE0							;faz r0 apontar para o endere�o dela
			  
			  MOV STATE1,#0H							;define vari�vel da intex1 como sendo 0
			  MOV R1,#STATE1							;faz r1 apontar para o endere�o dela
			  
			  MOV R2,#10000000B							;para deixar branco apenas o led mais � esquerda, come�a-se com esse valor					
			  MOV A,R2									;joga o valor em A para manuse�-lo
			  
VOLTA:		  CJNE @R1,#0,VOLTA							;teste para intex1
			  MOV P1,A	  								;joga o valor de A para os leds
			  MOV VETOR,#ATRASO	 		  				;define um valor gigante para um endere�o de mem�ria, visando o delay
			  CALL DELAY								;chama delay
			  CALL RLRA									;chama rota��o � esquerda ou direita
			  JMP VOLTA 								;volta para jogar novo valor nos leds
					
DELAY:		  DJNZ VETOR,DELAY							;fica decrementando o num gigante para ganhar tempo					
			  RET										;volta
			  
RLRA:		  CJNE @R0,#0,RLA							;teste da intex0 para rotacionar para esquerda ou direita
			  RR	A									;rotaciona A para a direita
			  JMP RETU									;pula para o fim da subrotina
RLA:		  RL	A									;rotaciona A para a esquerda
RETU:		  RET										;termina a subrotina

HANDLER0:	  CPL 20H.0									;alterna o byte de teste entre 0 e 1 a cada chamada da interrup��o
			  RETI										;fim do tratador

HANDLER1:	  CPL 22H.0									;alterna o byte de teste entre 0 e 1 a cada chamada da interrup��o
			  RETI										;fim do tratador
			  
			  END 
