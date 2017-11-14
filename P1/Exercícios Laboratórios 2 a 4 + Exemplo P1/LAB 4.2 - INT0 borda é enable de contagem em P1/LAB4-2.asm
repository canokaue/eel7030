RESET		EQU		00H								;início da memória de programa
INTEX0		EQU		03H								;local tratador intex0
STATE		EQU		20H								;local da variável de teste
VETOR		EQU		40H								;vetor para adicionar delay
ATRASO		EQU		0FFH

			ORG		RESET							;endereço da memória de programa
			JMP		INICIO							;vai para o início do programa
			
			ORG		INTEX0							;vai para o endereço do tratador
			JMP		HANDLER0						;chama o tratador
			
INICIO:		MOV		IE,#10000001B					;habilita intex0
			SETB	IT0								;define como ativada por borda de descida
			MOV		STATE,#00H						;define variável de teste como zero
			MOV		R0,#STATE						;joga em r0 o endereço da variável de teste
			MOV 	R2,#00H							;número que será movido para a porta p1
			MOV		A,R2							;joga no acumulador o valor de R2

VOLTA:		CJNE	@R0,#00H,VOLTA					;testa a variável de teste
			MOV		P1,A							;joga em p1
			MOV		VETOR,#ATRASO					;define vetor para delay
			CALL 	DELAY							;chama delay
			INC		R2								;incrementa o número
			MOV		A,R2							;põe no acumulador o número a ser exposto em p1
			CJNE	R2,#0FFH,VOLTA					;testa para ver se já atingiu ou não #0ffh
			JMP		INICIO							;caso afirmativo, volta para o início
			
HANDLER0:	CPL		STATE.0							;alterna um byte de state para passar ou não no loop (18)
			RETI									;retorna ao programa
			
DELAY:		DJNZ	VETOR,DELAY						;decrementa o vetor
			RET										;volta ao programa
			
			END	