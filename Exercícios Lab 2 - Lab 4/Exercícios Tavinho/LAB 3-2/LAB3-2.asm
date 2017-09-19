;Programa  MOSTRA1.asm 
		   CS  EQU  P0.7					;iguala o output P0.7 ao pino CS do decodificador
		   END0 EQU P3.3; 					;iguala o P3.3 ao LSB da escolha do display a ser utilizado
		   END1 EQU P3.4;  					;iguala o P3.4 ao MSB da escolha do display utilizado
  
		   ORG  0h  
		   SETB	END0  						;LSB do display = 1
		   CLR  END1  						;MSB do display = 0
		   SETB CS  						;liga o decodificador
		   
VOLTA:	   MOV  A,P2						;as chaves de P2 s�o transferidas para A
		   MOV  R2,#08H						;usar� a R2 para testar os 8 bytes de P2
		   MOV  R3,#00H						;usar� R3 como contador de chaves pressionadas
		   
CONTA:	   RLC  A							;rot A jogando o MSB no carry
		   JNC 	SOMA 						;se carry=1, ele desvia para "soma"
		   DJNZ R2,CONTA					;se carry!=1, ele testa se j� n�o foram os 8 bytes de P2
		   JMP  CCONV						;se j� forem os 8 bytes ele desvia para o c�digo de convers�o
		   		   
SOMA:	   INC  R3							;incrementa o contador de chaves pressionadas
		   DJNZ R2,CONTA					;testa se os 8 bytes j� n�o foram averiguados
		   JMP  CCONV						;caso afirmativo, desvia para o c�digo de convers�o

CCONV:	   MOV  A,R3						;joga o n�mero de chaves pressionadas em A
		   CALL CONVERTE  					;chamada da subrotina de convers�o
		   MOV  P1,A  						;move para P1, pois P1 que define a sa�da do display 7-seg
		   JMP  VOLTA 						;volta para testar as chaves de P2 de novo
 
CONVERTE:  INC A     						;A � incrementado para pular a instru��o RET na instru��o seguinte
		   MOVC A,@A+PC						;A � um n�mero, e o dado do PC cai exatamente em RET, por�m se forem somados o que est� em A     
		   RET 								;ao que est� em PC, vai cair em algum dos n�meros da tabela de dados abaixo
		    
TABELA:    DB 40H, 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H, 08H, 03H, 46H, 21H, 06H, 0EH    
			
		   END