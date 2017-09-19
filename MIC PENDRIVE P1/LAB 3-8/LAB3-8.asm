CS		EQU		P0.7							;define o enable do decodificador
END0	EQU		P3.4							;define o MSB da escolha do display
END1	EQU		P3.3							;define o LSB da escolha do display
	
		CLR		END0							;P3.4=0
		CLR		END1							;P4.4=0

KEYPAD: 
		ORL  P0,#7Fh 							;escreve ‘1’ em 7 pinos da porta P0, aqui também é acionado o enable do decodificador 
		CLR  F0  								;limpa flag que identifica tecla pressionada  
		MOV  R0,#0  							;limpa R0 – retorna o número da tecla foi pressionada  
												;varre primeira linha   
		CLR  P0.3  								;coloca ‘0’ na linha P0.3  
		CALL  colScan  							;chama rotina para varredura de coluna 
		JB  F0, finish 							;se flag F0 = ‘1’, tecla identificada => retorna        
												;varre segunda linha  
		SETB  P0.3  							;seta linha P0.3 
		CLR  P0.2  								;coloca ‘0’ na linha P0.2  
		CALL  colScan  							;chama rotina para varredura de coluna  
		JB  F0, finish  						;se flag F0 = ‘1’, tecla identificada => retorna 
												;varre terceira linha  
		SETB  P0.2   							;seta linha P0.2  
		CLR  P0.1   							;coloca ‘0’ na linha P0.1  
		CALL  colScan  							;chama rotina para varredura de coluna  
		JB  F0, finish  						;se flag F0 = ‘1’, tecla identificada => retorna 
												;varre quarta linha  
		SETB P0.1   							;seta linha P0.1  
		CLR P0.0   								;coloca ‘0’ na linha P0.0  
		CALL colScan   							;chama rotina para varredura de coluna  
		JB F0, finish   						;se flag F0 = ‘1’, tecla identificada => retorna 
 
		JMP KEYPAD  							;se flag F0 = ‘0’, tecla não identificada => repete varredura   

finish: MOV A,R0								;joga a tecla pressionada no acumulador
		CALL CONVERTE							;chama a conversão da tecla pressionada
		MOV P1,A								;joga nos leds
		JMP KEYPAD								;volta ao começo
		
 
 
; Subrotina que varre as colunas para identificar a qual pertence a tecla pressionada 
; o registrador R0 é incrementado a cada insucesso de forma a conter o nro. da tecla 
; pressionada  

colScan:
JNB P0.6, gotKey 							;tecla pressionada pertence a esta coluna – retornar  
INC R0     
JNB P0.5, gotKey 							;tecla pressionada pertence a esta coluna – retornar  
INC R0   
JNB P0.4, gotKey 							;tecla pressionada pertence a esta coluna – retornar  
INC R0     
RET   										;tecla pressionada não pertence a esta linha – retornar 

gotKey:  
SETB F0  									;faz flag F0 = ‘1’ => tecla identificada   
RET      

; Subrotina converte com tabela modificada para o exercício solicitado 
CONVERTE:  INC A     
		   MOVC A,@A+PC     
		   RET 
TABELA:  DB  79H, 24H, 30H, 19H, 12H, 02H, 78H, 00H, 10H,08H,40H, 46H
	
		 END