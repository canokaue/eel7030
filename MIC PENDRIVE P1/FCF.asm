;Felipe Castro de Freitas, Matrícula 14209569, turma 04235A


;SETUP
reset 			equ 00h
ltint0 			equ 03h ; local tratador ext0
overflow		equ	psw.2
CS 			EQU P0.7;
END0 		EQU P3.3;		
END1 		EQU P3.4;			
	

				org reset
				jmp setup
				org ltint0
				jmp	enablekeypad
				
Setup:			CLR END0
				CLR END1
				SETB CS	;Permite escrita no display 0 de 7segmentos do EDSIM

				mov ie,#10000001b 		;habilita interrupções, geral ext 1 e ext0
				mov tcon,#00000001b 	;controle de interrupção - borda de descida it0 e it1
				mov r7, #00h			;zera condição de interrupção 

;FUNÇÃO PRINCIPAL
			
			
showresult:	jnb overflow, ok
error:		mov p1,#00000110b ; mostra 'e' no display							
			
ok:			mov p1, a; mostra resultado no display
			cjne r7,#01h, showresult
			
			mov r1,00h; salva numero keypad			
			
readkeypad:	call keypad			
			mov a, r6
			call converte
			mov r0,a
			;mov a,r1 ; poe antigo valor em acc
			add a,r1 ; soma com novo valor			
			mov r7,#00h			
			jmp showresult	
				
;INTERRUPÇÕES e subrotinas


enablekeypad: 	mov r7,#01h
				reti
								
KEYPAD:
		ORL P0,#7Fh ; escreve ‘1’ em 7 pinos da porta P0
		CLR F0 ; limpa flag que identifica tecla pressionada
		MOV R6, #0 ; limpa R6 – retorna o número da tecla foi pressionada
	; varre primeira linha
		CLR P0.3 ; coloca ‘0’ na linha P0.3
		CALL colScan ; chama rotina para varredura de coluna
		JB F0, finish ; se flag F0 = ‘1’, tecla identificada => retorna
	; varre segunda linha
		SETB P0.3 ; seta linha P0.3
		CLR P0.2 ; coloca ‘0’ na linha P0.2
		CALL colScan ; chama rotina para varredura de coluna
		JB F0, finish ; se flag F0 = ‘1’, tecla identificada => retorna
	; varre terceira linha
		SETB P0.2 ; seta linha P0.2
		CLR P0.1 ; coloca ‘0’ na linha P0.1
		CALL colScan ; chama rotina para varredura de coluna
		JB F0, finish ; se flag F0 = ‘1’, tecla identificada => retorna
	; varre quarta linha
		SETB P0.1 ; seta linha P0.1
		CLR P0.0 ; coloca ‘0’ na linha P0.0
		CALL colScan ; chama rotina para varredura de coluna
		JB F0, finish ; se flag F0 = ‘1’, tecla identificada => retorna
		;JMP KEYPAD ; se flag F0 = ‘0’, tecla não identificada => repete varredura
finish:
		RET
; Subrotina que varre as colunas para identificar a qual pertence a tecla pressionada
; o registrador R0 é incrementado a cada insucesso de forma a conter o nro. da tecla
; pressionada
colScan:
		JNB P0.6, gotKey ; tecla pressionada pertence a esta coluna – retornar
		INC R6
		JNB P0.5, gotKey ; tecla pressionada pertence a esta coluna – retornar
		INC R6
		JNB P0.4, gotKey ; tecla pressionada pertence a esta coluna – retornar
		INC R6
		RET ; tecla pressionada não pertence a esta linha – retornar
gotKey:
		SETB F0 ; faz flag F0 = ‘1’ => tecla identificada
		RET
; Subrotina converte com tabela modificada para o exercício solicitado

CONVERTE:	INC A
			MOVC A,@A+PC
			RET
TABELA: 	DB 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H,08H,40H, 46H
	
	
	
	END