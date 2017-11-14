//Programa que escreve números hexadecimais (0 a F) no display 3 do EDSIM51

#include <reg51.h>

unsigned char converte_7seg (unsigned char);
unsigned char switchcounter (unsigned char );

void main (void)
{
	//short k = 0;
	unsigned char i;
	unsigned char j=0;		
	P0=0x80;		//P0 ativando o bit 7, que liga o CS do decoder do Edsim
	P3=0xEF;		//P3 usada para ligar os bits 3 e 4 definindo qual display de 7seg será usado (display 3)
	//display 1
	while (1) {		//loop infinito
		j=(~P2)&0x0F;		//j recebe valor de complemento de P2 e faz AND com 0F
//nao usado ->		//for (i = 0; i < 15000; i++); // atraso para Edsim 2.1.15 – Update freq=50000
		i=switchcounter(j);
		P1=converte_7seg(i);
	} // end of while
 } // end of main 
 
 unsigned char switchcounter (unsigned char entry){
 
	 unsigned char leftbit = 0;
	 unsigned char counter = 0;
	for (leftbit = 0; leftbit < 8; leftbit++){	//loop de leftbit de 0 a 8 (rotação completa)
		
		if((entry&0x01) == 0x01){
			counter++;		// toda vez que o carry for 1, aumenta counter(partindo do pressuposto que rotação usa carry)
		}
			entry=(entry>>1); //rotaciona entrada para a esquerda conforme valor de leftbit

	}
	  return counter;
 }
 
 unsigned char converte_7seg (unsigned char dado)	 // função que retorna valor a ser escrito…
{ 													//… nos displays para formar o caractere
 unsigned char led;

switch (dado) 								// *GFEDCBA
	{
	case  0: led = 0x40; break; // "1000000";		0
	case  1: led = 0x79; break; // "1111001";		1
	case  2: led = 0x24; break; // "0100100";		1
	case  3: led = 0x30; break; // "0110000";		2
	case  4: led = 0x19; break; // "0011001";		1
	case  5: led = 0x12; break; // "0010010";		2
	case  6: led = 0x02; break; // "0000010";		2
	case  7: led = 0x78; break; // "1111000";		3
	case  8: led = 0x00; break; // "0000000";		1
	case  9: led = 0x10; break; // "0010000";		2
	case 10: led = 0x08; break; // "0001000";		2
	case 11: led = 0x03; break; // "0000011";		3
	case 12: led = 0x46; break; // "1000110";		2
	case 13: led = 0x21; break; // "0100001";		3
	case 14: led = 0x06; break; // "0000110";		3
	case 15: led = 0x0E; break; // "0001110";		4
	default: led = 0x80;			  // "0000000";		
	}
 return led;
} // end converte 