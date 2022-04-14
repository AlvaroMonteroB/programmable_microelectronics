 ;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 5
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;

 ;Este programa ejecuta comunicación el pc con el pic
;---------------------------------------------------------------------------------------------
 list p=16f877A
  
;#include "c:\Archivos de programa\Microchip\MPSA Suite\p16f877a.inc";
;#include "c:\Archivos de Programa (x86)\microchip\mpasm suite\p16f877a.inc";  
#include<p16f877a.inc>

;Bits de configuración.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; ALL 
;---------------------------------------------------------------------------------------------
;
;fosc = 4 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms  ;// Tiempo de interrupcion.
;R=249,  P=128.
;frec int = 1/ t int = 874 Hz.
;---------------------------------------------------------------------------------------------
;
; Registros de proposito general Banco 0 de memoria RAM.
;
; Registros propios de estructura del programa
; Variables. 

unidades      equ        0x20;
decenas       equ        0x21;
contadorx     equ        0x22;
colum_1		  equ		 0x23;
colum_2	 	  equ		 0x24;
colum_3	 	  equ		 0x25;
colum_4	 	  equ		 0x26;
colum_5	 	  equ		 0x27;
car_temp      equ        0x28;
dato_rx       equ        0x29;


;---------------------------------------------------------------------------------------------
;
;Constantes.




;Constantes de caracteres en siete segmentos.
;                   PGFEDCBA


Car__         equ b'01000000'; Caracter _ en siete segmentos.
Car_null      equ b'00000000'; Caracter nulo en siete segmentos.
;---------------------------------------------------------------------------------------------
; 
;Asignaciòn de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0    equ          .0; // Sin Uso RA0.
Sin_UsoRA1    equ          .1; // Sin Uso RA1.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111111'; // Programaciòn inicial del puerto A.

;Puerto B.
col1         equ          .0; // Salida para controlar el segmento a.
col2              equ          .1; // Salida para controlar el segmento b.
col3         equ          .2; // Salida para controlar el segmento c.
col4              equ          .3; // Salida para controlar el segmento d.
col5               equ          .4; // Salida para controlar el segmento e.
sinusorb5         equ          .5; // Salida para controlar el segmento f.
sinusorb6         equ          .6; // Salida para controlar el segmento g.
sinusorb7         equ          .7; // Salida para controlar el segmento dp.

progb         equ b'00000000'; // Programaciòn inicial del puerto B.

;Puerto C.
seg_a     equ          .0; // Bit que controla el comun del display 0.
seg_b     equ          .1; // Bit que controla el comun del display 1.
seg_c     equ          .2; // Bit que controla el comun del display 2.
seg_d     equ          .3; // Bit que controla el comun del display 3.
seg_e     equ          .4; // Bit que controla el comun del display 4.
seg_f     equ    .5; // Bit que controla el comun del display 5.
tx_databit     equ     .6; // salida para transmitir
rx_databit     equ     .7; // entrada para recibir datos


progc         equ b'10111111'; // Programaciòn inicial del puerto C.

;Puerto D.
com_disp0   equ     .0; // Sin Uso RD2.
com_disp1   equ     .1; // Sin Uso RD3.
com_disp2   equ     .2; // Sin Uso RD2.
com_disp3   equ     .3; // Sin Uso RD3.
com_disp4   equ     .4
com_disp5   equ     .5; // Sin Uso RD5.
com_disp6   equ     .6; // Sin Uso RD6.
com_disp7    equ     .7; // Sin Uso RD7.

progd         equ b'00000000'; // Programaciòn inicial del puerto D como salidas
 
;Puerto E.
aa5           equ          .0; // Sin Uso RE0.
Most_num      equ          .1; // Sin Uso RE1.
Led_Op        equ          .2; // Led Op.

proge         equ      b'011'; // Programaciòn inicial del puerto E.
;---------------------------------------------------------------------------------------------
 
                 ;====================
                 ;==  Vector reset  ==
                 ;====================
                 org 0x0000;         
vec_reset        clrf pclath; Asegura la pagina cero de la mem: de prog.         
                 goto prog_prin; 
;---------------------------------------------------------------------------------------------

                 ;============================== 
                 ;==  Vector de interrupcion  ==
                 ;==============================
                 org 0x0004;                  
vec_int          nop;

                 retfie;               
;---------------------------------------------------------------------------------------------
                 
                 ;===========================
                 ;==  Subrutina de inicio  ==
                 ;===========================
prog_ini         bsf status,rp0; selec. el bco. 1 de ram.
                 movlw b'00000111';                       
                 movwf option_reg ^0x80;
                 movlw proga;                                 
                 movwf trisa ^0x80;
                 movlw progb;                       
                 movwf trisb ^0x80;
                 movlw progc;                       
                 movwf trisc ^0x80;
                 movlw progd;                       
                 movwf trisd ^0x80;
                 movlw proge;                        
                 movwf trise ^0x80;
                 movlw 0x06;                       
                 movwf adcon1 ^0x80;conf. el pto. a como salidas i/o.
                 bcf status,rp0; reg. bc0. ram.
				
				 ; Inicialización de registros y/o variables.
                 clrf portd;
                 bsf portd,com_disp0;
                 nop;
                 bsf portd,com_disp1;
				 nop;
				 bsf portd,com_disp2;
				 nop;
				 bsf portd,com_disp3;
				 nop;
				 bsf portd,com_disp4;
				 nop;
				 bsf portd,com_disp5;
				 nop;
				 bsf portd,com_disp6;
				 nop;
				 bsf portd,com_disp7;
			
                 bsf porte,Led_Op; Apaga el LED.
                                                    
                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  Programa principal  ==
                 ;==========================
prog_prin        call prog_ini;

				 bcf porte,Led_Op;
                 call delayled; 
                 bsf porte,Led_Op;
   				 call delayled; 
				 bcf porte,Led_Op;
                 call delayled; 
                 bsf porte,Led_Op;
   				 call delayled;
				 bcf porte,Led_Op;
                 call delayled; 
                 bsf porte,Led_Op;
   				 call delayled;
			     bsf portc,rx_databit;
				
loop_prin   
rx_data
				nop;
				btfsc portc,rx_databit;
				goto rx_data;
miau			call retardo624;subrutina de retardo de bit y medio de 624.9 useg
				bcf intcon,gie;
				movlw .8;
				movwf contadorx;
sig_rxdato	
				btfss portc,rx_databit;aaaaaaaaaaaaaaaaaaaaaaaaa
				goto bit_clr;
				bsf status,c;
				
				goto rota_bit;
bit_clr
				bcf status,c;
				
rota_bit
				rrf dato_rx,f;
				call retardo416;416.6usegs
				decfsz contadorx,f;
				goto sig_rxdato;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				bsf intcon,gie;
				call retardo416;el mimsmo de arriba
				
	
				movf dato_rx,w;
			
				movwf car_temp;

				call ascii_matrix;

				call most_numm;

				goto loop_prin









;--------------------------------------------------------------------------

                      ;===========================================
				;==========Conversion ascii a matriz=================
					  ;===========================================
ascii_matrix
					movlw .65;
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_A;
						
					movlw 'a';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_aa;
					movlw .66;
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_B;
					movlw 'b';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_BB;
					movlw .67;
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_C;
					movlw 'c';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_CC;
					movlw .68;
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_D;
					movlw 'd';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_DD;
					movlw 'E';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_e;
					movlw 'e';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_ee;
					movlw 'F';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_f;
					movlw 'f';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_ff;
					movlw 'G';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_G;
					movlw 'g';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_gg;
					movlw 'H';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_h;
					movlw 'h';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_hh;
					movlw 'I';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_i;
					movlw 'i';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_ii;
					movlw 'J';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_j;
					movlw 'j';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_jj;
					movlw 'K';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_K;
					movlw 'k';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_KK;
					movlw 'L';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_L;
					movlw 'l';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_Ll;
					movlw 'M';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_m;
					movlw 'm';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_mm;
					movlw 'N';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_N;
					movlw 'n';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_nn;
					movlw 'O';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_o;
					movlw 'o';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_oo;
					movlw 'P';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_p;
					movlw 'p';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_pp;
					movlw 'Q';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_q;
					movlw 'q';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_qq;
					movlw 'R';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_r;
					movlw 'r';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_rr;
					movlw 'S';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_s;
					movlw 's';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_ss;
					movlw 'T';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_T;
					movlw 't';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_tt;
					movlw 'U';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_u;
					movlw 'u';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_uu;
					movlw 'V';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_v;
					movlw 'v';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_vv;
					movlw 'W';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_w;
					movlw 'w';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_ww;
					movlw 'X';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_x;
					movlw 'x';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_xx;
					movlw 'Y';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_y;
					movlw 'y';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_yy;
					movlw 'Z';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_z;
					movlw 'z';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_zz;
					movlw '0';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_0;
					movlw '1';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_1;
					movlw '2';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_2;
					movlw '3';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_3;
					movlw '4';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_4;
					movlw '5';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_5;
					movlw '6';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_6;
					movlw '7';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_7;
					movlw '8';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_8;
					movlw '9';
					xorwf car_temp,w;
					btfsc status,z;
					goto fue_9;
					goto no_cod;
no_cod;
					clrw;
					movwf colum_1;
					movwf colum_2;
					movwf colum_3;
					movwf colum_4;
					movwf colum_5;
					goto sal_matrix;

fue_a
					movlw b'00000001';
					movwf colum_1;
					movlw b'01110110';
					movwf colum_2;
					movlw b'01110110';
					movwf colum_3;
					movlw b'01110110';
					movwf colum_4;
					movlw b'000000001';
					movwf colum_5;

					goto sal_matrix
					
					

fue_aa
					movlw b'00001011';
					movwf colum_1;
					movlw b'00101011';
					movwf colum_2;
					movlw b'00101011';
					movwf colum_3;
					movlw b'00101011';
					movwf colum_4;
					movlw b'00000011';
					movwf colum_5;
					goto sal_matrix;
fue_b
					movlw b'0';
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'001001001';
					movwf colum_5;
					goto sal_matrix;
fue_bb
					movlw .0;
					movwf colum_1;
					movlw b'00110111';
					movwf colum_2;
					movlw b'00110111';
					movwf colum_3;
					movlw b'00110111';
					movwf colum_4;
					movlw b'01001111';
					movwf colum_5;
					goto sal_matrix;
fue_c
					movlw b'0';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'0111110';
					movwf colum_3;
					movlw b'0111110';
					movwf colum_4;
					movlw b'0111110';
					movwf colum_5;
					goto sal_matrix;
fue_cc
					movlw b'00000011';
					movwf colum_1;
					movlw b'00111011';
					movwf colum_2;
					movlw b'00111011';
					movwf colum_3;
					movlw b'00111011';
					movwf colum_4;
					movlw b'00111011';
					movwf colum_5;
					goto sal_matrix;
fue_d
					movlw .0;
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00111110';
					movwf colum_3;
					movlw b'00111110';
					movwf colum_4;
					movlw b'01000001';
					movwf colum_5;
					goto sal_matrix;
fue_dd
					movlw b'01001111';
					movwf colum_1;
					movlw b'00110111';
					movwf colum_2;
					movlw b'00110111';
					movwf colum_3;
					movlw b'00110111';
					movwf colum_4;
					movlw .0;
					movwf colum_5;
					goto sal_matrix;
fue_e
					movlw .0;
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'00110110';
					movwf colum_5;
					goto sal_matrix;
fue_ee
					movlw b'01000111';
					movwf colum_1;
					movlw b'00101011';
					movwf colum_2;
					movlw b'00101011';
					movwf colum_3;
					movlw b'00101011';
					movwf colum_4;
					movlw b'00100011';
					movwf colum_5;
					goto sal_matrix;
fue_f
					movlw .0;
					movwf colum_1;
					movlw b'11111010';
					movwf colum_2;
					movlw b'11111010';
					movwf colum_3;
					movlw b'11111010';
					movwf colum_4;
					movlw b'11111010';
					movwf colum_5;
					goto sal_matrix;
fue_ff
					movlw b'00000000';
					movwf colum_1;
					movlw b'11110110';
					movwf colum_2;
					movlw b'11110110';
					movwf colum_3;
					movlw b'11110110';
					movwf colum_4;
					movlw b'11110101';
					movwf colum_5;
					goto sal_matrix;
fue_g
					movlw b'01000011';
					movwf colum_1;
					movlw b'00111101';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'01000110';
					movwf colum_5;
					goto sal_matrix;
fue_gg
					movlw b'0110011';
					movwf colum_1;
					movlw b'00101101';
					movwf colum_2;
					movlw b'00101101';
					movwf colum_3;
					movlw b'00101101';
					movwf colum_4;
					movlw b'00000001';
					movwf colum_5;
					goto sal_matrix;
fue_h
					movlw .0;
					movwf colum_1;
					movlw b'01110111';
					movwf colum_2;
					movlw b'01110111';
					movwf colum_3;
					movlw b'01110111';
					movwf colum_4;
					movlw .0;
					movwf colum_5;
					goto sal_matrix;
fue_hh
					movlw .0;
					movwf colum_1;
					movlw b'01110111';
					movwf colum_2;
					movlw b'01110111';
					movwf colum_3;
					movlw b'01110111';
					movwf colum_4;
					movlw b'00001111';
					movwf colum_5;
					goto sal_matrix;
fue_i
					movlw b'00111110';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'0';
					movwf colum_3;
					movlw b'00111110';
					movwf colum_4;
					movlw b'00111110';
					movwf colum_5;
					goto sal_matrix;
fue_ii
					movlw .255;
					movwf colum_1;
					movlw .255;
					movwf colum_2;
					movlw b'00000101';
					movwf colum_3;
					movlw .255;
					movwf colum_4;
					movlw .255;
					movwf colum_5;
					goto sal_matrix;
fue_j
					movlw b'01011111';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00111110';
					movwf colum_3;
					movlw b'00111110';
					movwf colum_4;
					movlw b'01000000';
					movwf colum_5;
					goto sal_matrix;
fue_jj
					movlw b'11111111';
					movwf colum_1;
					movlw b'11001111';
					movwf colum_2;
					movlw b'00111111';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'11000000';
					movwf colum_5;
					goto sal_matrix;
fue_k
					movlw b'0';
					movwf colum_1;
					movlw b'01110111';
					movwf colum_2;
					movlw b'11101011';
					movwf colum_3;
					movlw b'11011101';
					movwf colum_4;
					movlw b'00111110';
					movwf colum_5;
					goto sal_matrix;
fue_kk
					movlw b'00000001';
					movwf colum_1;
					movlw b'11101111';
					movwf colum_2;
					movlw b'11010111';
					movwf colum_3;
					movlw b'00111011';
					movwf colum_4;
					movlw b'11111101';
					movwf colum_5;
					goto sal_matrix;
fue_l
					movlw b'0';
					movwf colum_1;
					movlw b'00111111';
					movwf colum_2;
					movlw b'00111111';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'00111111';
					movwf colum_5;
					goto sal_matrix;
fue_ll
					movlw .255;
					movwf colum_1;
					movlw .255;
					movwf colum_2;
					movlw b'000000011';
					movwf colum_3;
					movlw b'11111111';
					movwf colum_4;
					movlw b'11111111';
					movwf colum_5;
					goto sal_matrix;
fue_m
					movlw .0;
					movwf colum_1;
					movlw b'11111101';
					movwf colum_2;
					movlw b'11111011';
					movwf colum_3;
					movlw b'11111101';
					movwf colum_4;
					movlw .0;
					movwf colum_5;
					goto sal_matrix;
fue_mm
					movlw b'00000111';
					movwf colum_1;
					movlw b'11110111';
					movwf colum_2;
					movlw b'01000111';
					movwf colum_3;
					movlw b'11110111';
					movwf colum_4;
					movlw b'00000111';
					movwf colum_5;
					goto sal_matrix;
fue_n
					movlw b'0';
					movwf colum_1;
					movlw b'11111101';
					movwf colum_2;
					movlw b'11111011';
					movwf colum_3;
					movlw b'11110111';
					movwf colum_4;
					movlw b'0';
					movwf colum_5;
					goto sal_matrix;
fue_nn
					movlw b'00000011';
					movwf colum_1;
					movlw b'11110111';
					movwf colum_2;
					movlw b'11110111';
					movwf colum_3;
					movlw b'11110111';
					movwf colum_4;
					movlw b'00001111';
					movwf colum_5;
					goto sal_matrix;
fue_o
					movlw b'11000001';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00111110';
					movwf colum_3;
					movlw b'00111110';
					movwf colum_4;
					movlw b'11000001';
					movwf colum_5;
					goto sal_matrix;
fue_oo
					movlw b'11000111';
					movwf colum_1;
					movlw b'00111011';
					movwf colum_2;
					movlw b'00111011';
					movwf colum_3;
					movlw b'00111011';
					movwf colum_4;
					movlw b'11000111';
					movwf colum_5;
					goto sal_matrix;
fue_p
					movlw b'0';
					movwf colum_1;
					movlw b'11110110';
					movwf colum_2;
					movlw b'11110110';
					movwf colum_3;
					movlw b'11110110';
					movwf colum_4;
					movlw b'11111001';
					movwf colum_5;
					goto sal_matrix;
fue_pp
					movlw b'00000001';
					movwf colum_1;
					movlw b'11101101';
					movwf colum_2;
					movlw b'11101101';
					movwf colum_3;
					movlw b'11101101';
					movwf colum_4;
					movlw b'11110011';
					movwf colum_5;
					goto sal_matrix;
fue_q
					movlw b'11000001';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00111110';
					movwf colum_3;
					movlw b'00011110';
					movwf colum_4;
					movlw b'00000001';
					movwf colum_5;
					goto sal_matrix;
fue_qq
					movlw b'11110011';
					movwf colum_1;
					movlw b'11101101';
					movwf colum_2;
					movlw b'11101101';
					movwf colum_3;
					movlw b'11101101';
					movwf colum_4;
					movlw b'00000001';
					movwf colum_5;
					goto sal_matrix;
fue_r
					movlw b'0';
					movwf colum_1;
					movlw b'11110110';
					movwf colum_2;
					movlw b'11110110';
					movwf colum_3;
					movlw b'11100110';
					movwf colum_4;
					movlw b'00011001';
					movwf colum_5;
					goto sal_matrix;
fue_rr
					movlw b'00000001';
					movwf colum_1;
					movlw b'11110111';
					movwf colum_2;
					movlw b'11111011';
					movwf colum_3;
					movlw b'11111011';
					movwf colum_4;
					movlw b'11111011';
					movwf colum_5;
					goto sal_matrix;
fue_s
					movlw b'00111001';
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'11001110';
					movwf colum_5;
					goto sal_matrix;
fue_ss
					movlw b'00110111';
					movwf colum_1;
					movlw b'00101011';
					movwf colum_2;
					movlw b'00101011';
					movwf colum_3;
					movlw b'00101011';
					movwf colum_4;
					movlw b'11011011';
					movwf colum_5;
					goto sal_matrix;
fue_t
					movlw b'11111110';
					movwf colum_1;
					movlw b'11111110';
					movwf colum_2;
					movlw b'0';
					movwf colum_3;
					movlw b'11111110';
					movwf colum_4;
					movlw b'11111110';
					movwf colum_5;
					goto sal_matrix;
fue_tt
					movlw .255;
					movwf colum_1;
					movlw b'11111011';
					movwf colum_2;
					movlw b'0';
					movwf colum_3;
					movlw b'11111011';
					movwf colum_4;
					movlw .255;
					movwf colum_5;
					goto sal_matrix;
fue_u
					movlw b'10000111';
					movwf colum_1;
					movlw b'00111111';
					movwf colum_2;
					movlw b'00111111';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'10000111';
					movwf colum_5;
					goto sal_matrix;
fue_uu
					movlw b'11000111';
					movwf colum_1;
					movlw b'00111111';
					movwf colum_2;
					movlw b'00111111';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'11000111';
					movwf colum_5;
					goto sal_matrix;
fue_v
					movlw b'11100000';
					movwf colum_1;
					movlw b'11011111';
					movwf colum_2;
					movlw b'10111111';
					movwf colum_3;
					movlw b'11011111';
					movwf colum_4;
					movlw b'11100000';
					movwf colum_5;
					goto sal_matrix;
fue_vv
					movlw b'11101111';
					movwf colum_1;
					movlw b'11011111';
					movwf colum_2;
					movlw b'10111111';
					movwf colum_3;
					movlw b'11011111';
					movwf colum_4;
					movlw b'11101111';
					movwf colum_5;
					goto sal_matrix;
fue_w
					movlw b'0';
					movwf colum_1;
					movlw b'11011111';
					movwf colum_2;
					movlw b'11101111';
					movwf colum_3;
					movlw b'11011111';
					movwf colum_4;
					movlw b'0';
					movwf colum_5;
					goto sal_matrix;
fue_ww
					movlw b'00000111';
					movwf colum_1;
					movlw b'00111111';
					movwf colum_2;
					movlw b'00011111';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'00000111';
					movwf colum_5;
					goto sal_matrix;
fue_x
					movlw b'00011100';
					movwf colum_1;
					movlw b'11101011';
					movwf colum_2;
					movlw b'11110111';
					movwf colum_3;
					movlw b'11101011';
					movwf colum_4;
					movlw b'00011100';
					movwf colum_5;
					goto sal_matrix;
fue_xx
					movlw b'00111011';
					movwf colum_1;
					movlw b'11010111';
					movwf colum_2;
					movlw b'11101111';
					movwf colum_3;
					movlw b'11010111';
					movwf colum_4;
					movlw b'00111011';
					movwf colum_5;
					goto sal_matrix;
fue_y
					movlw b'11111100';
					movwf colum_1;
					movlw b'11111011';
					movwf colum_2;
					movlw b'00000111';
					movwf colum_3;
					movlw b'11111011';
					movwf colum_4;
					movlw b'11111100';
					movwf colum_5;
					goto sal_matrix;
fue_yy
					movlw b'00111011';
					movwf colum_1;
					movlw b'11010111';
					movwf colum_2;
					movlw b'11101111';
					movwf colum_3;
					movlw b'11110111';
					movwf colum_4;
					movlw b'11111011';
					movwf colum_5;
					goto sal_matrix;
fue_z
					movlw b'00011110';
					movwf colum_1;
					movlw b'00101110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00111010';
					movwf colum_4;
					movlw b'00111100';
					movwf colum_5;
					goto sal_matrix;
fue_zz
					movlw b'00111011';
					movwf colum_1;
					movlw b'00011011';
					movwf colum_2;
					movlw b'00101011';
					movwf colum_3;
					movlw b'00110011';
					movwf colum_4;
					movlw b'00111011';
					movwf colum_5;
					goto sal_matrix;
fue_0
					movlw b'11000001';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00111110';
					movwf colum_3;
					movlw b'00111110';
					movwf colum_4;
					movlw b'11000001';
					movwf colum_5;
					goto sal_matrix;
fue_1
					movlw b'11111111';
					movwf colum_1;
					movlw b'00111101';
					movwf colum_2;
					movlw b'0';
					movwf colum_3;
					movlw b'00111111';
					movwf colum_4;
					movlw b'11111111';
					movwf colum_5;
					goto sal_matrix;
fue_2
					movlw b'00011101';
					movwf colum_1;
					movlw b'00101110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00111010';
					movwf colum_4;
					movlw b'00111100';
					movwf colum_5;
					goto sal_matrix;
fue_3
					movlw b'11011101';
					movwf colum_1;
					movlw b'00111110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'11001001';
					movwf colum_5;
					goto sal_matrix;
fue_4
					movlw b'11100111';
					movwf colum_1;
					movlw b'11101011';
					movwf colum_2;
					movlw b'11101101';
					movwf colum_3;
					movlw .0;
					movwf colum_4;
					movlw b'11101111';
					movwf colum_5;
					goto sal_matrix;
fue_5
					movlw b'00110000';
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'11001110';
					movwf colum_5;
					goto sal_matrix;
fue_6
					movlw b'11000001';
					movwf colum_1;
					movlw b'10110110';
					movwf colum_2;
					movlw b'10110110';
					movwf colum_3;
					movlw b'10110110';
					movwf colum_4;
					movlw b'11001111';
					movwf colum_5;
					goto sal_matrix;
fue_7
					movlw b'11111110';
					movwf colum_1;
					movlw b'00001110';
					movwf colum_2;
					movlw b'11110110';
					movwf colum_3;
					movlw b'11111010';
					movwf colum_4;
					movlw b'11111100';
					movwf colum_5;
					goto sal_matrix;
fue_8
					movlw b'11001001';
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'11001001';
					movwf colum_5;
					goto sal_matrix;
fue_9
					movlw b'11011001';
					movwf colum_1;
					movlw b'00110110';
					movwf colum_2;
					movlw b'00110110';
					movwf colum_3;
					movlw b'00110110';
					movwf colum_4;
					movlw b'11001001';
					movwf colum_5;
				 




sal_matrix				return;
;------------------------------------------------------------------------------------------
;subrutina del mostrado de los numeros, estos permaneceran un segundo debido a que es un barrido
most_numm				
				
miau
					movf colum_1,w;
					movwf portd;
					bsf portb,col1;
					call delayx;
					bcf portb,col1;
					btfss portc,rx_databit;
					goto rx2;

					movf colum_2,w;
					movwf portd;
					bsf portb,col2;
					call delayx;
					bcf portb,col2;

					movf colum_3,w;
					movwf portd;
					bsf portb,col3;
					call delayx;
					bcf portb,col3;
					btfss portc,rx_databit;
					goto rx2;

					movf colum_4,w;
					movwf portd;
					bsf portb,col4;
					call delayx;
					bcf portb,col4;
					btfss portc,rx_databit;
					goto rx2;

					movf colum_5,w;
					movwf portd;
					bsf portb,col5;
					call delayx;
					bcf portb,col5;
					btfss portc,rx_databit;
					goto rx2;
					goto most_num;

					

					


;--------------------------------------------------------------------------
  				 ;=============================================
                 ;==  Subrutina de retardo de 4 ms         ==
                 ;=============================================
delayx

				movlw d'239';
				movwf tmr0;	
retr1
				btfss portc,rx_databit;
				goto rx2;
				btfss intcon,t0if;
				goto retr1;
				bcf intcon,t0if;
					
				return;
			




delayled
		movlw .9;
		movwf unidades;
ent
		movlw d'38'
		movwf tmr0;
cont2   btfss intcon,t0if;
		goto cont2;
		bcf intcon,t0if;
		decfsz unidades,f;
		goto ent;
		return;

;--------------------------------------------------------------------------------------------------

                      
;--------------------------------------------------------------------------------------------------

                        ;=====================================
                        ;== Subrutina de retardo de 40ms  ====
                        ;=====================================
retardo_milis           
                        return;
;---------------------------------------------------------------------------------------------




                        ;====================================================================
                        ;== Subrutina de retardo de 416.6 useg. para un baud rate de 2400  ==
                        ;====================================================================
retardo416                movlw .137;   137     ts.         ts = (1/fo)4 = (1/4000000)4 = 1 us.
                        movwf decenas;      ts.         tr = ts + ts + (ts + 2ts)M + 2ts
loop1                   decfsz decenas,f;   ts o 2ts.   tr = 4ts + 3Mts
                        goto loop1;           2ts.        tr = (4 + 3M)ts     M = 137 
                                  ;                       tr = 415 us.
                        return;
;--------------------------------------------------------------------------------------------------

                        ;=========================================================
                        ;== Subrutina de retardo de bit y medio de 624.9 useg.  ==
                        ;=========================================================
retardo624               movlw .206;           ts.         ts = (1/fo)4 = (1/4000000)4 = 1 us.
                        movwf decenas;      ts.         tr = ts + ts + (ts + 2ts)M + 2ts
loop11                  decfsz decenas,f;   ts o 2ts.   tr = 4ts + 3Mts
                        goto loop11;          2ts.        tr = (4 + 3M)ts     M = 206 

                        return;


   			end