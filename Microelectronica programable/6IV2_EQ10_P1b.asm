;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 1b
 ;Parte I: Aplicación para el manejo de una. 
 ;marquesina de 8 displays de 7 segmentos.
 ;
 ;GRUPO: 6IV2.  EQUIPO: 10
 ;
 
 
 
 ; ESTE PROGRAMA EJECUTA UNA MARQUESINA QUE MUESTRA
 ;UN REFRÁN CON TMR0
;---------------------------------------------------------------------------------------------
 list p=16f877A
  
;#include "c:\Archivos de programa\Microchip\MPSA Suite\p16f877a.inc";
;#include "c:\Archivos de Programa (x86)\microchip\mpasm suite\p16f877a.inc";  
#include<p16f877a.inc>

;Bits de configuración.
 __config _XS_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; ALL 
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
resp_w        equ        0x20; // 
resp_status   equ        0x21; // 
res_pclath    equ        0x22; // 
res_fsr	      equ        0x23;
les	  		  equ   	 0x24;
contadorb     equ        0x25;
contadorc     equ        0x26;
contadorx     equ        0x27;



;---------------------------------------------------------------------------------------------
;
;Constantes.

O			  equ      	  .80;
PP			  equ		   .3;
Q			  equ		   .1;
RR            equ         .125;


;Constantes de caracteres en siete segmentos.
;                   PGFEDCBA
Car_A         equ b'01110111'; Caracter A en siete segmentos.
Car_b         equ b'01111100'; Caracter b en siete segmentos.
Car_C         equ b'00111001'; Caracter C en siete segmentos.
Car_cc        equ b'01011000'; Caracter c en siete segmentos.
Car_d         equ b'01011110'; Caracter d en siete segmentos.
Car_E         equ b'01111001'; Caracter E en siete segmentos.
Car_F         equ b'01110001'; Caracter F en siete segmentos.
Car_G         equ b'01111101'; Caracter G en siete segmentos.
Car_gg        equ b'01101111'; Caracter g en siete segmentos.
Car_H         equ b'01110110'; Caracter H en siete segmentos.
Car_hh        equ b'01110100'; Caracter h en siete segmentos.
Car_i         equ b'00000110'; Caracter i en siete segmentos.
Car_J         equ b'00001110'; Caracter J en siete segmentos.
Car_L         equ b'00111000'; Caracter L en siete segmentos.
Car_n         equ b'01010100'; Caracter n en siete segmentos.
Car_o         equ b'01011100'; Caracter o en siete segmentos.
Car_P         equ b'01110011'; Caracter P en siete segmentos.
Car_q         equ b'01100111'; Caracter q en siete segmentos.
Car_r         equ b'01010000'; Caracter r en siete segmentos.
Car_S         equ b'01101101'; Caracter S en siete segmentos.
Car_t         equ b'01111000'; Caracter t en siete segmentos.
Car_U         equ b'00111110'; Caracter U en siete segmentos.
Car_uu        equ b'00011100'; Caracter u en siete segmentos.
Car_y         equ b'01101110'; Caracter y en siete segmentos.
Car_Z         equ b'01011011'; Caracter Z en siete segmentos.
Car_0         equ b'00111111'; Caracter 0 en siete segmentos.
Car_1         equ b'00000110'; Caracter 1 en siete segmentos.
Car_2         equ b'01011011'; Caracter 2 en siete segmentos.
Car_3         equ b'01001111'; Caracter 3 en siete segmentos.
Car_4         equ b'01100110'; Caracter 4 en siete segmentos.
Car_5         equ b'01101101'; Caracter 5 en siete segmentos.
Car_6         equ b'01111101'; Caracter 6 en siete segmentos.
Car_7         equ b'00000111'; Caracter 7 en siete segmentos.
Car_8         equ b'01111111'; Caracter 8 en siete segmentos.
Car_9         equ b'01100111'; Caracter 9 en siete segmentos.

Car__         equ b'00001000'; Caracter _ en siete segmentos.
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
int	          equ          .0; // Salida para controlar el segmento a.
Seg_b         equ          .1; // Salida para controlar el segmento b.
Seg_c         equ          .2; // Salida para controlar el segmento c.
Seg_d         equ          .3; // Salida para controlar el segmento d.
Seg_e         equ          .4; // Salida para controlar el segmento e.
Seg_f         equ          .5; // Salida para controlar el segmento f.
Seg_g         equ          .6; // Salida para controlar el segmento g.
Seg_dp        equ          .7; // Salida para controlar el segmento dp.

progb         equ b'11111111'; // Programaciòn inicial del puerto B.

;Puerto C.
seg_a      equ          .0; // Salida para controlar el display 1.
seg_b      equ          .1; // Salida para controlar el display 2
seg_c      equ          .2; // Salida para controlar el display 3
seg_d      equ          .3; // Salida para controlar el display 4
seg_e      equ          .4; // Salida para controlar el display 5
seg_f      equ          .5; // Salida para controlar el display 6
seg_g     equ          .6; // Salida para controlar el display 7
seg_dp      equ          .7; // Salida para controlar el display 8

progc         equ b'00000000'; // Programaciòn inicial del puerto C.

;Puerto D.
clk_pto0    equ          .0; // Sin Uso RD2.
clk_pto1    equ          .1; // Sin Uso RD3.
clk_pto2    equ          .2; // Sin Uso RD2.
clk_pto3    equ          .3; // Sin Uso RD3.
clk_pto4    equ          .4; // Sin Uso RD4.
clk_pto5    equ          .5; // Sin Uso RD5.
clk_pto6    equ          .6; // Sin Uso RD6.
clk_pto7    equ          .7; // Sin Uso RD7.

progd         equ b'00000000'; // Programaciòn inicial del puerto D como entradas.
 
;Puerto E.
led_rojo      equ          .0; // 
led_azul      equ          .1; // 
Led_Op        equ          .2; // Led Op.

proge         equ      b'000'; // Programaciòn inicial del puerto E.
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
vec_int          call rut_int
	 

                 retfie;               
;---------------------------------------------------------------------------------------------
                 
                 ;===========================
                 ;==  Subrutina de inicio  ==
                 ;===========================
prog_ini         bsf status,rp0; selec. el bco. 1 de ram.
                 movlw b'10000111';                       
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
				 movlw b'10011000';
				 movwf intcon;
				
				 ; Inicialización de registros y/o variables.
                 clrf portc;
                 bsf portd,clk_pto0;
                 nop;
                 bsf portd,clk_pto1;
				 nop;
				 bsf portd,clk_pto2;
				 nop;
				 bsf portd,clk_pto3;
				 nop;
				 bsf portd,clk_pto4;
				 nop;
				 bsf portd,clk_pto5;
				 nop;
				 bsf portd,clk_pto6;
				 nop;
    			 bsf portd,clk_pto7;
				 nop;
                 bsf porte,Led_Op; Apaga el LED.
				 nop;
				 bsf porte,led_rojo;
				 nop;
				 bsf porte,led_azul;
				 nop;
                                                    
                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  Programa principal  ==
                 ;==========================
prog_prin        call prog_ini;

				 bcf porte,Led_Op;
                 call retardo2;
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;

                 bsf porte,Led_Op;
   				 call retardo2; 
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;

				 bcf porte,Led_Op;
                 call retardo2; 
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;
                 bsf porte,Led_Op;
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;
				 bcf porte,Led_Op;
                 call retardo2; 
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;
                 bsf porte,Led_Op;
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;
   				 call retardo2;

loop_prin    

				movlw RR;
				movwf contadorx;    
retardohierba
			
				movlw car_H;hierba
				movwf portc;
 			    bcf portd,clk_pto0;
				nop;
				call retardo3;
				bsf portd,clk_pto0;
				nop;
				
				movlw car_I;
				movwf portc;
				bcf portd,clk_pto1;
				nop;
				call retardo3;
      			bsf portd,clk_pto1;
				nop;

				movlw car_E;
				movwf portc;
				bcf portd,clk_pto2;
				nop;
				call retardo3;
      			bsf portd,clk_pto2;
				nop;
				
				movlw car_r;
				movwf portc;
				bcf portd,clk_pto3;
				nop;
				call retardo3;
      			bsf portd,clk_pto3;
				nop;
		
				movlw car_b;
				movwf portc;
				bcf portd,clk_pto4;
				nop;
				call retardo3;
      			bsf portd,clk_pto4;
				nop;
				
				movlw car_a;
				movwf portc;
				bcf portd,clk_pto5;
				nop;
				call retardo3;
      			bsf portd,clk_pto5;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto6;
				nop;
				call retardo3;
      			bsf portd,clk_pto6;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto7;
				nop;
				call retardo3;
      			bsf portd,clk_pto7;
				nop;


;loop de palabra


				
				decfsz contadorx,f;
				goto retardohierba;



   		    movlw RR	;
			movwf contadorx;
retardomala
				
				movlw car_n;
				movwf portc;
 			    bcf portd,clk_pto0;
				nop;
				call retardo3;
				bsf portd,clk_pto0;
				nop;
	
				movlw car_n;
				movwf portc;
				bcf portd,clk_pto1;
				nop;
				call retardo3;
      			bsf portd,clk_pto1;
				nop;

     			movlw car_A;
				movwf portc;
				bcf portd,clk_pto2;
				nop;
				call retardo3;
      			bsf portd,clk_pto2;
				nop;

				movlw car_l;
				movwf portc;
				bcf portd,clk_pto3;
				nop;
				call retardo3;
      			bsf portd,clk_pto3;
				nop;

				movlw car_a;
				movwf portc;
				bcf portd,clk_pto4;
				nop;
				call retardo3;
      			bsf portd,clk_pto4;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto5;
				nop;
				call retardo3;
      			bsf portd,clk_pto5;
				nop;
	
				movlw car_null;
				movwf portc;
				bcf portd,clk_pto6;
				nop;
				call retardo3;
      			bsf portd,clk_pto6;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto7;
				nop;
				call retardo3;
      			bsf portd,clk_pto7;
				nop;

				
;loop de palabra

             
				decfsz contadorx,f;
				goto retardomala;


				movlw RR;
				movwf contadorx;

retardonunca
				movlw car_n;
				movwf portc;
 			    bcf portd,clk_pto0;
				nop;
				call retardo3;
				bsf portd,clk_pto0;
				nop;
	
				movlw car_uu;
				movwf portc;
				bcf portd,clk_pto1;
				nop;
				call retardo3;
      			bsf portd,clk_pto1;
				nop;

 				movlw car_n;
				movwf portc;
				bcf portd,clk_pto2;
				nop;
				call retardo3;
      			bsf portd,clk_pto2;
				nop;
		
				movlw car_cc;
				movwf portc;
				bcf portd,clk_pto3;
				nop;
				call retardo3;
      			bsf portd,clk_pto3;
				nop;

				movlw car_a;
				movwf portc;
				bcf portd,clk_pto4;
				nop;
				call retardo3;
      			bsf portd,clk_pto4;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto5;
				nop;
				call retardo3;
      			bsf portd,clk_pto5;
				nop;
	
				movlw car_null;
				movwf portc;
				bcf portd,clk_pto6;
				nop;
				call retardo3;
      			bsf portd,clk_pto6;
				nop;


				movlw car_null;
				movwf portc;
				bcf portd,clk_pto7;
				nop;
				call retardo3;
      			bsf portd,clk_pto7;
				nop;



;loop de palabra

 			
				decfsz contadorx,f;
				goto retardonunca;


	
			    movlw RR;
				movwf contadorx;
				
retardomuere

				movlw car_n;
				movwf portc;
 			    bcf portd,clk_pto0;
				nop;
				call retardo3;
				bsf portd,clk_pto0;
				nop;
	
				movlw car_n;
				movwf portc;
				bcf portd,clk_pto1;
				nop;
				call retardo3;
      			bsf portd,clk_pto1;
				nop;

				movlw car_uu;
				movwf portc;
				bcf portd,clk_pto2;
				nop;
				call retardo3;
      			bsf portd,clk_pto2;
				nop;

				movlw car_e;
				movwf portc;
				bcf portd,clk_pto3;
				nop;
				call retardo3;
      			bsf portd,clk_pto3;
				nop;

				movlw car_r;
				movwf portc;
				bcf portd,clk_pto4;
				nop;
				call retardo3;
      			bsf portd,clk_pto4;
				nop;

				movlw car_e;
				movwf portc;
				bcf portd,clk_pto5;
				nop;
				call retardo3;
      			bsf portd,clk_pto5;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto6;
				nop;
				call retardo3;
      			bsf portd,clk_pto6;
				nop;

				movlw car_null;
				movwf portc;
				bcf portd,clk_pto7;
				nop;
				call retardo3;
      			bsf portd,clk_pto7;
				nop;


;loop de palabra

			   
				decfsz contadorx,f;
				goto retardomuere;

			
				goto loop_prin;
				
				 
;---------------------------------------------------------------------------------------------
 				 ;=================
                 ;==  subrutinas ==
                 ;=================
rut_int
				        movwf resp_w; w -> resp_w
                        swapf status,w;
                        movwf resp_status;
                        clrf status;
                        movf pclath,w;
                        movwf res_pclath;
                        clrf pclath;  
                        movf fsr,w;
                        movwf res_fsr;

						btfss intcon,intf;
						goto int_rbi;
						goto int_rb0;
						
					


int_rb0					movlw .16;
						movwf contadorc;

men1					
						bcf porte,led_rojo;
						call retardo2;
						decfsz contadorc,f;
						goto men1;	
						goto prestas;

int_rbi				
						movlw .16;
						movwf contadorb;
						bcf porte,led_azul;
equisde
						call retardo2;
						decfsz contadorb,f;
						goto equisde;
					
						goto prestas;
		
prestas
						bsf porte,led_azul;
						bsf porte,led_rojo;
					    movf res_fsr,w;
                        movwf fsr;
                        movf res_pclath,w;
                        movwf pclath;
                        swapf resp_status,w;
                        movwf status;
                        swapf resp_w,f;	
			            swapf resp_w,w;	
						bcf intcon,rbif;
						bcf intcon,intf;
					


 						return;
                 ;=============================================
                 ;==  Subrutina de retardo de medio segundo  ==
                 ;=============================================
;
retardo2       	 movlw d'11';
				 movwf tmr0;
retr2
				btfss intcon,t0if;
				goto retr2;
				bcf intcon,t0if;

                 return;


  					 ;=============================================
                 ;==  Subrutina de retardo de 2 milisegs  ==
                 ;=============================================
retardo3         
				 movlw d'247';
				 movwf tmr0;
retr3
				btfss intcon,t0if;
				goto retr3;
				bcf intcon,t0if;

                 return;
;---------------------------------------------------------------------------------------------
   			end