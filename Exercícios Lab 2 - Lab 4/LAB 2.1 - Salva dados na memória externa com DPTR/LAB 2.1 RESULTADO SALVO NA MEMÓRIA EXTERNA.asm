;Programa ADDVECT.asm
RESET			EQU 0H  ; INICIA O PROGRAMA NA POSIÇÃO ZERO DA MEMÓRIA 
VETOR 			EQU 60H  ; INICIA O VETOR NA POSIÇÃO 60H DA MEMORIA RAM
				ORG RESET ; PC = 0000H ao se resetar o 8051
				MOV DPTR,#NRO ; endereco nro parcelas a ser somado
				MOV A,#0
				MOVC A,@A+DPTR
				MOV R1,A ; R1 = nro parcelas a ser somado
				MOV DPTR,#DADOS ; end. vetor de dados a ser somado
				MOV R2,#0 ; guarda resultado das somas realizadas
				MOV R0,#0 ; especifica parcela a ser lida do vetor de dados
VOLTA: 			MOV A,R0
				MOVC A,@A+DPTR ; le parcela
				ADD A,R2
				MOV R2,A
				INC R0
				DJNZ R1,VOLTA ; SE R1 =! ZERO, DECREMENTA R1 E EXECUTA "VOLTA", SE R1==0 CONTINUA A EXECUÇÃO DO PROGRAMA E NÃO EXECUTA "VOLTA"
					
		        ; MOVX -> MOVER PARA MEMÓRIA EXTERNA USANDO DPTR ( POR QUE É UM REGISTRADOR  DE 16 BITS) 
				MOV DPTR,#0001H  
				MOVX @DPTR,A


FIM: 			JMP FIM
				ORG VETOR
NRO: 			DB 03H
DADOS:			DB 01H,03H,05H,06H,0AH,0E2H
				END
