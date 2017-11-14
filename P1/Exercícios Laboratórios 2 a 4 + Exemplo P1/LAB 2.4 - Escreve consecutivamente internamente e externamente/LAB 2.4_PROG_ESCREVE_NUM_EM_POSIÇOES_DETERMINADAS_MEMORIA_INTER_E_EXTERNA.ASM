;Programa ADDVECT.asm
RESET 			EQU 0H
				ORG RESET ; PC = 0000H ao se resetar o 8051
				
				MOV A,#00H
				
				MOV P2,#22H
				MOV R0,#00H
				MOV R1,#50H
				
VOLTA:			INC A
				INC R1
				INC R0
				MOVX @R0,A
				MOV @R1,A
				CJNE A,#05H,VOLTA
				JMP $
				
END
