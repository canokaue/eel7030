;Programa MOSTRA1.asm
CS EQU P0.7
END0 EQU P3.3;
END1 EQU P3.4;
ATRASO EQU 0FEH
VARIAVELATRASO EQU 22H

				ORG 0h
				CLR END0
				CLR END1
				CLR CS
				MOV R3,#0AH
VOLTA:		
				MOV A,#01H

CONTA:			
				MOV P1,A
				CALL CONVERTE
				MOV VARIAVELATRASO,#ATRASO
				CALL DELAY
				DJNZ R3,CONTA

				MOV VARIAVELATRASO,#ATRASO
				CALL DELAY

				JMP VOLTA
				
DELAY:			DJNZ VARIAVELATRASO,DELAY
				RET
				
CONVERTE:      RL A
				RET				
TABELA: DB 40H, 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H, 08H, 03H, 46H,21H, 06H, 0EH
END