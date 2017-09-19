;Fazer um programa que atenda a interrup��o externa 1. A solicita��o deste tratador deve
;proporcionar a leitura de dado da porta P1. Ao final da leitura de 2 dados da porta P1 (UM
;POR VEZ), o programa deve rotacionar um led apagado (todos acesos, a exce��o de um) na
;porta P2. O primeiro dado deve especificar a dire��o de rota��o (0 - Esquerda / 1 - Direita).
;O segundo dado deve especificar o n�mero de casas a serem rotacionadas (Ex: 1,2,3..).
;Ap�s procedimento, voltar a aguardar novas solicita��es de interrup��o.


reset equ 00h
ltint1 equ 13h ; local tratador <--------------------------
state equ 20h	
	
	
ATRASO EQU 0FEH
VARIAVELATRASO EQU 22H
	
	
;--------------------------------------------------------------------------------------	
;inicia o programa, por�m como o programa tem tratadores ent�o os tratadores tem que ser declarados no inicio do programa 
; em posi��es de mem�ria especifica como 03h e 13h, para o tratador 0 e para o tratador 1 respectivamente 
				org reset ;PC=0 depois de reset
				jmp inicio1; pula para o inicio ali em baixo, por que vc nao precisa compilar o tratador, eke s� vai ser compilado 
				          ; quando tiver uma interrup��o externa acontecendo 
; inicializa o tratador na posi��o que � definida como --ltint1 equ 13h-- l� em cima -- o valor 13h n�o � uma valor arbitr�rio
; esse valor est� definido na apostila para o tratador um, tbm como 03h est� definido para o tratador 0
				org ltint1
				jmp handler
				
;------------------------------------------------------------------------------------------				
; o progeama de fato come�a aqui



inicio1:				MOV R4,#0FEH  ; colocou-se dois inicios, por que o "INICIO" � UM LA�O, E O "INICIO1" N�O PPE UM LA�o
inicio:    
				mov ie,#10000100b ; habilita A INTERRUP��O 1 --- VEJA NA APOSTILA QUE PARA VOCE HABILITAR A INTERRUP��O
								  ; VC TER� QUE JOGAR UM CERTO VALOR PARA "ie" - interrup��o externa-
								  ; no caso de "10000100b"  o oitavo "1" habilita EA "ENABLE ALL" e o "1" na terceira posi��o
								  ; habilita a interru~��o externa 1
								  ; por exemplo, caso eu queira habilitar somente a interrrup��o 0 eu faria "mov ie,#10000001b"
								  ; caso eu tivesse que habilitar as duas seria "mov ie,#10000101b"
								  
				setb it1 ; DEFINIE QUE A INTERRUP��o VAI ACONTECER S� QUANDO HOUVER BORDA
						 ; essa fun��o s� define isso para a interrup��o 1, se quiseres fazer isso para interrup��o 0 tbm, vc tem que 
						 ; colocar no prog "setb it0" para acontecer para a interrrujp��o 0
						 ;Os flip-flops IT1 e IT0 em n�vel l�gico �1� especificam se as interrup��es externas 1 e 0 (respectivamente) s�o solicitadas por borda de descida.
				mov state,#00h ;inicializa��o
				mov r0,#state
				MOV P1,R4
				mov r7,#00h
				
volta:
				cjne @r0,#01h,volta
				
;PRIMEIRA INTERRUP��O				
; VERIFICA O VALOR SETADO NA PORTA P2	E JOGA PARA R7
				CALL VARREP2

;SEGUNDA INTERRUP��O
;VERIFICA P2 DEPOIS DA SEGUNDA INTERRUP��O


volta2:
				cjne @r0,#02h,volta2
				
				MOV A,P2
				CJNE R7,#00H,DIREITA
				CALL VARREP2
	


ESQUERDA:      
				MOV @R0,#00H
				MOV A,R4
ESQUERDA1:
				MOV P1,A
				RLC A
				DJNZ R7,ESQUERDA1
				MOV R4,P1
				JMP inicio
				
DIREITA:		CALL VARREP2
				MOV @R0,#00H
				MOV A,R4
DIREITA1:		
				MOV P1,A
                RRC A
				DJNZ R7,DIREITA1 
				MOV R4,P1
				JMP inicio
				jmp $
					
				handler: inc state
				         reti

DELAY:			DJNZ VARIAVELATRASO,DELAY
				RET	
				
VARREP2:    MOV R5,#08H

			MOV A,P2
			CPL A
VAI:		RLC A ;ROTACIONA O CONTEUDO DO ACUMULADOR PARA A ESQUERDA,ATRAVES DO CARRY
			; OU SEJA DA O NUMERO DE CHAVES APERTADAS PARA O CARRY 
		    JNC SALTA ; Desvia se o flag carry estiver em 0
		    INC R7 ; INCREMENTA R7 QUE INICIALMENTE � 0	
			
SALTA:		DJNZ R5,VAI ; DECREMENTA R5, E SALTA SE N�O � ZERO
			RET
end
