;Programa  MOSTRA1.asm 
		   CS  EQU  P0.7					;iguala o output P0.7 ao pino CS do decodificador
		   END0 EQU P3.3; 					;iguala o P3.3 ao MSB da escolha do display a ser utilizado
		   END1 EQU P3.4;  					;iguala o P3.4 ao LSB da escolha do display utilizado
  
		   ORG  0h  
		   CLR END0  						;MSB do display = 0
		   CLR END1  						;LSB do display = 0
		   SETB CS  						;liga o decodificador
		   
VOLTA:	   MOV A,P2							;as chaves de P2 s�o transferidas para A
		   CPL A							;complemento A pois chave aberta equivale � 1 e queremos chave aberta equivalente � 0
		   CALL CONVERTE  					;chamada da subrotina
		   MOV P1,A  						;move para P1, pois P1 que define a sa�da do display 7-seg
		   JMP VOLTA 						
 
CONVERTE:  INC A     						;A � incrementado para pular a instru��o RET na instru��o seguinte
		   MOVC A,@A+PC						;A � um n�mero, e o dado do PC cai exatamente em RET, por�m se forem somados o que est� em A     
		   RET 								;ao que est� em PC, vai cair em algum dos n�meros da tabela de dados abaixo
		   
TABELA: DB 40H, 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H, 08H, 03H, 46H, 21H, 06H, 0EH    
			
		   END