;Programa ADDVECT.asm
RESET 			EQU 0H
VETOR 			EQU 60H
				ORG RESET ; PC = 0000H ao se resetar o 8051
				MOV DPTR,#NRO ; endereco nro parcelas a ser somado
				MOV A,#0
				MOVC A,@A+DPTR
				JZ FIM ; JZ -> JUMP CONDICIONAL, SE A==0, SALTA PARA INSTRUÇÃO DADA DEPOIS DO COMANDO NO CASO "FIM" 
				MOV R1,A ; R1 = nro parcelas a ser somado
				MOV DPTR,#DADOS ; end. vetor de dados a ser somado
				MOV R2,#0 ; guarda resultado das somas realizadas
				MOV R0,#0 ; especifica parcela a ser lida do vetor de dados
VOLTA:			MOV A,R0
				MOVC A,@A+DPTR ; le parcela
				ADD A,R2
				MOV R2,A
				INC R0
				DJNZ R1,VOLTA
FIM: 			JMP FIM
ORG VETOR
NRO:		 DB 00H  ; NOTA-SE QUE NO PROGRAMA DADO PELO PROFESSOR, O VALOR ORIGINAL ERA "DB 03H", POREM PARA VERIFICAR JZ, PÕEM-SE "DB 00H"
DADOS:		 DB 01H,03H,05H,06H,0AH,0E2H
END
