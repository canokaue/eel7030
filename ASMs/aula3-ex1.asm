;Programa MOSTRA1.asm
CS EQU P0.7
END0 EQU P3.3;
END1 EQU P3.4;
ORG 0h
CLR END0
CLR END1
SETB CS
LER: MOV A, P2
CPL A
CALL CONVERTE
MOV P1,A
JMP LER

CONVERTE: INC A
 MOVC A,@A+PC
 RET
TABELA: DB 40H, 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H, 08H, 03H, 46H, 21H, 06H, 0EH
END