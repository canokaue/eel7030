//loop 7segm 4 display on -> processo principal

#include <reg51.h>

unsigned char converte_7seg (unsigned char);
void c_timer0 (void);
void c_timer1 (void);

unsigned char seg=0;
unsigned char min0=0;			//display 0 7seg
unsigned char min1=0;			//display 1 7seg
unsigned char hora0=0;		//display 2 7seg
unsigned char hora1=0;		//display 3 7seg

void main (void){
	
	P0=0x80;			//P0 ativando o bit 7, que liga o CS do decoder do Edsim
	TMOD=0x61; 		//timer0 modo 1 conta de 0 a 4240h timer (2bytes)
								//timer1 modo 2 conta de 0 a F		contador
								
	//definir portas, TMOD e outros
	TR0=1;
	TR1=1;
	while(1){		//loop do microcontrolador
	
	//implementar loop 7segm 4 display on, sincronizando dado ao display
	//chamada para conversão e envio para os displays
		P1=~seg;
		P3=0xE7;
		P1=converte_7seg(min0);
		P3=0xEF;
		P1=converte_7seg(min1);
		P3=0xF7;
		P1=converte_7seg(hora0);
		P3=0xFF;
		P1=converte_7seg(hora1);
	
		//conv hora, min, seg

		if(seg==60){
			min0++ ;
			seg=0 ;
		}
	
		if(min0==10){
			min1++ ;
			min0=0 ;
		}

		if(min1==6){
			hora0++ ;
			min1=0 ;
		}
		if(hora0==10){
			hora1++ ;
			hora0=0 ;
		}

		if(hora1==2 & hora0==4){
			hora0=0 ;
			hora1=0 ;
		}
		
		//end conv hora, min, seg
	}//while
}	//void



//conv clock 1MHz -> 1Hz, rotina de interrupção via timer

//1MHz = 0F4240h -> 3 bytes
void c_timer0 (void) interrupt 1 {
//timer0 modo 1 conta de 0 a 4240h timer (2bytes, BDBFh até FFFFh)
//cada interrupção, gera 1 para contador no timer 1 (Byte mais significativo do 1MHz)
TH0=0xBD;
TL0=0xBF;
T1=0;
T1=1;		//Onda quadrada no pino 3.5 para contar no timer 1
T1=0;
}
void c_timer1 (void) interrupt 3{
//timer1 modo 3 conta de 0 a F		contador
//cada interrupção incrementa seg, seg++
seg++;
}
//fim conv clock 1MHz -> 1Hz

//conv num -> 7seg

unsigned char converte_7seg (unsigned char dado){	 
	// função que retorna valor a ser escrito nos displays para formar o caractere
 unsigned char led;

switch (dado) 					// GFEDCBA
	{
	case  0: led = 0x40; break; // "1000000";
	case  1: led = 0x79; break; // "1111001";
	case  2: led = 0x24; break; // "0100100";
	case  3: led = 0x30; break; // "0110000";
	case  4: led = 0x19; break; // "0011001";
	case  5: led = 0x12; break; // "0010010";
	case  6: led = 0x02; break; // "0000010";
	case  7: led = 0x78; break; // "1111000";
	case  8: led = 0x00; break; // "0000000";
	case  9: led = 0x10; break; // "0010000";
/*case 10: led = 0x08; break; // "0001000";		a
	case 11: led = 0x03; break; // "0000011";		b
	case 12: led = 0x46; break; // "1000110";		c
	case 13: led = 0x21; break; // "0100001";		d
	case 14: led = 0x06; break; // "0000110";		e
	case 15: led = 0x0E; break; // "0001110";		f  */
	default: led = 0x80; 				// "0000000";
	}
 return led;
} // end conv num -> 7seg 


//Dificuldades: relacionar funções conhecidas em Assembly para C, implementar rotinas paralelas sem que uma atrapalhe a execução da outra, Pensar em como o EDSIM está interpretando e executando o código(arquitetura)
