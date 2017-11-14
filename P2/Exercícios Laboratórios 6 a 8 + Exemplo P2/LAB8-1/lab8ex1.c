//Programa que escreve números hexadecimais (0 a F) no display 3 do EDSIM51

#include <reg51.h>

unsigned char converte_7seg (unsigned char);

void main (void)
{
	short i;
	signed char j=9;
	P0=0x80;//P0 ativando o bit 7, que liga o CS do decoder do Edsim
	P3=0xFF;//P3 usada para ligar os bits 3 e 4 definindo qual display de 7seg será usado (display 3)
	
	while (1) {

		if ( j == -1) j=9;
		for (i = 0; i < 15000; i++); // atraso para Edsim 2.1.15 – Update freq=50000
		P1=converte_7seg(j);
		j--;
	} // end of while
 } // end of main 
 
 unsigned char converte_7seg (unsigned char dado)	 // função que retorna valor a ser escrito…
{ 													//… nos displays para formar o caractere
 unsigned char led;

switch (dado) 					// GFEDCBA
	{
	case 0: led = 0x40; break; // "1000000";
	case 1: led = 0x79; break; // "1111001";
	case 2: led = 0x24; break; // "0100100";
	case 3: led = 0x30; break; // "0110000";
	case 4: led = 0x19; break; // "0011001";
	case 5: led = 0x12; break; // "0010010";
	case 6: led = 0x02; break; // "0000010";
	case 7: led = 0x78; break; // "1111000";
	case 8: led = 0x00; break; // "0000000";
	case 9: led = 0x10; break; // "0010000";
	case 10: led = 0x08; break; // "0001000";
	case 11: led = 0x03; break; // "0000011";
	case 12: led = 0x46; break; // "1000110";
	case 13: led = 0x21; break; // "0100001";
	case 14: led = 0x06; break; // "0000110";
	case 15: led = 0x0E; break; // "0001110";
	default: led = 0x80; // "0000000";
	}
 return led;
} // end converte 