;Fazer um programa que atenda a interrupção externa 1. A solicitação deste tratador deve
;proporcionar a leitura de dado da porta P1. Ao final da leitura de 2 dados da porta P1 (UM
;POR VEZ), o programa deve rotacionar um led apagado (todos acesos, a exceção de um) na
;porta P2. O primeiro dado deve especificar a direção de rotação (0 - Esquerda / 1 - Direita).
;O segundo dado deve especificar o número de casas a serem rotacionadas (Ex: 1,2,3..).
;Após procedimento, voltar a aguardar novas solicitações de interrupção.


reset equ 00h
ltint1 equ 13h ; local tratador <--------------------------
state equ 20h	
	
	
ATRASO EQU 0FEH
VARIAVELATRASO EQU 22H
	
	
;--------------------------------------------------------------------------------------	
;inicia o programa, porém como o programa tem tratadores então os tratadores tem que ser declarados no inicio do programa 
; em posições de memória especifica como 03h e 13h, para o tratador 0 e para o tratador 1 respectivamente 
				org reset ;PC=0 depois de reset
				jmp inicio1; pula para o inicio ali em baixo, por que vc nao precisa compilar o tratador, eke só vai ser compilado 
				          ; quando tiver uma interrupção externa acontecendo 
; inicializa o tratador na posição que é definida como --ltint1 equ 13h-- lá em cima -- o valor 13h não é uma valor arbitrário
; esse valor está definido na apostila para o tratador um, tbm como 03h está definido para o tratador 0
				org ltint1
				jmp handler
				
;------------------------------------------------------------------------------------------				
; o progeama de fato começa aqui



inicio1:				MOV R4,#0FEH  ; colocou-se dois inicios, por que o "INICIO" É UM LAÇO, E O "INICIO1" NÃO PPE UM LAÇo
inicio:    
				mov ie,#10000100b ; habilita A INTERRUPÇÃO 1 --- VEJA NA APOSTILA QUE PARA VOCE HABILITAR A INTERRUPÇÃO
								  ; VC TERÁ QUE JOGAR UM CERTO VALOR PARA "ie" - interrupção externa-
								  ; no caso de "10000100b"  o oitavo "1" habilita EA "ENABLE ALL" e o "1" na terceira posição
								  ; habilita a interru~ção externa 1
								  ; por exemplo, caso eu queira habilitar somente a interrrupção 0 eu faria "mov ie,#10000001b"
								  ; caso eu tivesse que habilitar as duas seria "mov ie,#10000101b"
								  
				setb it1 ; DEFINIE QUE A INTERRUPÇão VAI ACONTECER SÓ QUANDO HOUVER BORDA
						 ; essa função só define isso para a interrupção 1, se quiseres fazer isso para interrupção 0 tbm, vc tem que 
						 ; colocar no prog "setb it0" para acontecer para a interrrujpção 0
						 ;Os flip-flops IT1 e IT0 em nível lógico ‘1’ especificam se as interrupções externas 1 e 0 (respectivamente) são solicitadas por borda de descida.
				mov state,#00h ;inicialização
				mov r0,#state
				MOV P1,R4
				mov r7,#00h
				
volta:
				cjne @r0,#01h,volta
				
;PRIMEIRA INTERRUPÇÃO				
; VERIFICA O VALOR SETADO NA PORTA P2	E JOGA PARA R7
				CALL VARREP2

;SEGUNDA INTERRUPÇÃO
;VERIFICA P2 DEPOIS DA SEGUNDA INTERRUPÇÃO


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
		    INC R7 ; INCREMENTA R7 QUE INICIALMENTE É 0	
			
SALTA:		DJNZ R5,VAI ; DECREMENTA R5, E SALTA SE NÃO É ZERO
			RET
end
