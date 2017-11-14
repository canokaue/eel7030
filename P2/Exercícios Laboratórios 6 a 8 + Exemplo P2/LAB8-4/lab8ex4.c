//Programa que escreve números hexadecimais (0 a F) no display 3 do EDSIM51

#include <reg51.h>

void main (void)
{
	P0=0x00;			//P0 desativando o bit 7, que desliga o CS do decoder do Edsim
	IE=0x82;
	TMOD=0x02; 		//timer0 modo 2 conta de 0 a F
	TH0=0x00;			//recarga do timer 0 modo 2
	TL0=0x00;			//valor inicial timer 0 modo 2
	TR0=1;				//dispara timer
	P1=0x80;			//Led a ser rotacionado
	while (1) {		//loop infinito
		if((P1&0xFF) == 0x00){
			P1=0x80;		// quando o led passar pela ultima posição, retorna a inicial
		}
	} // end of while
 } // end of main 
 
 
 void c_timer0 (void) interrupt 1 {
//timer0 modo 2 conta de  a  timer (2bytes, BDBFh até FFFFh)
//cada interrupção, rotaciona 1 
//TH0=0xBD;
//TL0=0xBD;
P1=(P1>>1);
}
 
