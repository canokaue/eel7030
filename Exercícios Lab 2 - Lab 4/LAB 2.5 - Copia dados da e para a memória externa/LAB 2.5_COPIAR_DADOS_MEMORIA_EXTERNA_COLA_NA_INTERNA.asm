RESET EQU 0H
					ORG RESET ; PC = 0000H ao se resetar o 8051
						
INICIO:				MOV A,#0
					MOV R3,#0FH
					
					
					MOV R0,#00H
					MOV R1,#00H
					
VOLTA:				
					MOV P2,#21H
					MOVX A,@R0
					
					MOV R2,P2
					MOV P2,#23H
					
					MOVX @R1,A
			
					INC R0
					INC R1					
					MOV P2,R2
					DJNZ R3,VOLTA
					JMP INICIO
					END
