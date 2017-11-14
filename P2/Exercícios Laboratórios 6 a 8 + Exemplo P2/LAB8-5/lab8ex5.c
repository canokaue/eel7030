//Programa que escreve números hexadecimais (0 a F) no display 3 do EDSIM51

#include <reg51.h>

unsigned char ledbarup (unsigned char);
unsigned char ledbardown (unsigned char);

unsigned char led=0x00;
short i=0;
bit invert=0;

void main (void)
{
	P0=0x00;			//P0 desativando o bit 7, que desliga o CS do decoder do Edsim
	IE=0x82;			//ativa interrupções gerais e timer 0
	TMOD=0x02; 		//timer0 modo 2 conta de 00 a FF
	TH0=0x00;			//recarga do timer 0 modo 2
	TL0=0x00;			//valor inicial timer 0 modo 2
	TR0=1;				//dispara timer
	P1=0x00;			//Led a ser rotacionado

	
	while (1) {		//loop infinito

		P1=led;
		
	} // end of while
 } // end of main 
 
 
 void c_timer0 (void) interrupt 1 {
//timer0 modo 2 conta de  a  timer (2bytes, BDBFh até FFFFh)
//cada interrupção, rotaciona 1 
//TH0=0xBD;
//TL0=0xBD;
if(invert==1){
	ledbardown(led);
	}
else{
	ledbarup(led);
	}
}
 /*
NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		
NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		
NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO
NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		
NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		NÃO ESTÁ FUNCIONANDO DIREITO		
*/

unsigned char ledbarup(unsigned char led){	
	
	ledup=~led;
		ledup>>1;
		ledup=~ledup
	//ledup=ledup|0x80;
		i++;
		if(i==8){
			invert=1
		}
	return ledup; 
}

unsigned char ledbardown (unsigned char led){
			
		leddown=led;
			leddown<<1;
			i--;
			if(i==0){
				invert=0
			}
	return leddown;
}



