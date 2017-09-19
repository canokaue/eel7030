;Programa  MOSTRA1.asm 
		   CS  		EQU  P0.7				;iguala o output P0.7 ao pino CS do decodificador
		   END0 	EQU P3.3; 				;iguala o P3.3 ao LSB da escolha do display a ser utilizado
		   END1 	EQU P3.4;  				;iguala o P3.4 ao MSB da escolha do display utilizado
		   ATRASO	EQU	0FEH				;define um endereço gigante para uso do delay
	
		   ORG  0h  						;começa programa no 00h
		   CLR	END0  						;LSB do display = 1
		   CLR  END1  						;MSB do display = 0
		   SETB CS  						;liga o decodificador
		   MOV R3,#0AH						;joga 0AH no para não ter que incremetar na subrotina converte
		   
VOLTA:	   MOV  A,R3						;joga n+1 no acumulador
		   CALL CONVERTE  					;chamada da subrotina de conversão
		   MOV  P1,A						;joga n em P1

		   MOV R2,#ATRASO					;põe o endereço gigante em R2
		   CALL DELAY						;chama delay

		   DJNZ	R3,VOLTA					;verifica se já não foram os 9 digitos
		   JMP  $							;em caso afirmativo, para de rodar
 
DELAY: 	   DJNZ	R2,DELAY					;fica decrementando R2 para ganhar/perder tempo
		   RET								;volta para o programa
 
CONVERTE:  MOVC A,@A+PC						;A é um número, e o dado do PC cai exatamente em RET, porém se forem somados o que está em A     
		   RET 								;ao que está em PC, vai cair em algum dos números da tabela de dados abaixo
		    
TABELA:    DB 40H, 79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H, 08H, 03H, 46H, 21H, 06H, 0EH    
			
		   END