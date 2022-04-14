;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 1a
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
 ;Este programa ejecuta una cuenta de 0 a 1000 con el manejo del TMR0
;---------------------------------------------------------------------------------------------
 list p=16f877A
  
;#include "c:\Archivos de programa\Microchip\MPSA Suite\p16f877a.inc";
;#include "c:\Archivos de Programa (x86)\microchip\mpasm suite\p16f877a.inc";  
#include<p16f877a.inc>

;Bits de configuración.
 __config _HS_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; ALL 
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




;---------------------------------------------------------------------------------------------
;
;Constantes.

col_1       equ    b'00000001';
col_2       equ    b'00000010';
col_3       equ    b'00000100';
col_4       equ    b'00001000';
col_5       equ    b'00010000';
monito2     equ    b'00001101';  
monito3     equ    b'11110000';
monito4     equ    b'00001101';
manita1_1   equ    b'11111011';
manita1_2   equ    b'11111011';
manita2_1   equ    b'11111101';
manita2_2	equ    b'11111101';
manita3_1	equ    b'11111110';
manita3_2   equ    b'11111110';


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
cl5               equ          .4; // Salida para controlar el segmento e.
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
seg_g     equ     .6; // Bit que controla el comun del display 6.
seg_h     equ     .7; // Bit que controla el comun del display 7.


progc         equ b'11111111'; // Programaciòn inicial del puerto C.

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
				
loop_prin       
                 ;========================================
                 ;==  Subrutina para la matriz  ==
                 ;========================================

;---------------------------------------------------------------------------------------------

  

				movlw .25;
				movwf contadorx;    
monito1
				movlw manita1_1;
			    movwf portd;
				movlw col_1;
				movwf portb;
				call delayx;

				movlw monito2;
			    movwf portd;
				movlw col_2;
				movwf portb;
				call delayx;

				movlw monito3;
			    movwf portd;
				movlw col_3;
				movwf portb;
				call delayx;

				movlw monito4;
			    movwf portd;
				movlw col_4;
				movwf portb;
				call delayx;

				movlw manita1_2;
			    movwf portd;
				movlw col_5;
				movwf portb;
				call delayx;
	
				decfsz contadorx,f;
				goto monito1;

			    movlw .25;
				movwf contadorx;    
monito_2
				movlw manita2_1;
			    movwf portd;
				movlw col_1;
				movwf portb;
				call delayx;

				movlw monito2;
			    movwf portd;
				movlw col_2;
				movwf portb;
				call delayx;

				movlw monito3;
			    movwf portd;
				movlw col_3;
				movwf portb;
				call delayx;

				movlw monito4;
			    movwf portd;
				movlw col_4;
				movwf portb;
				call delayx;

				movlw manita2_2;
			    movwf portd;
				movlw col_5;
				movwf portb;
				call delayx;
	
				decfsz contadorx,f;
				goto monito_2;


			    movlw .25;
				movwf contadorx;    
monito_3
				movlw manita3_1;
			    movwf portd;
				movlw col_1;
				movwf portb;
				call delayx;

				movlw monito2;
			    movwf portd;
				movlw col_2;
				movwf portb;
				call delayx;

				movlw monito3;
			    movwf portd;
				movlw col_3;
				movwf portb;
				call delayx;

				movlw monito4;
			    movwf portd;
				movlw col_4;
				movwf portb;
				call delayx;

				movlw manita3_2;
			    movwf portd;
				movlw col_5;
				movwf portb;
				call delayx;
	
				decfsz contadorx,f;
				goto monito_3;

				movlw .25;
				movwf contadorx;    
monito_4
				movlw manita2_1;
			    movwf portd;
				movlw col_1;
				movwf portb;
				call delayx;

				movlw monito2;
			    movwf portd;
				movlw col_2;
				movwf portb;
				call delayx;

				movlw monito3;
			    movwf portd;
				movlw col_3;
				movwf portb;
				call delayx;

				movlw monito4;
			    movwf portd;
				movlw col_4;
				movwf portb;
				call delayx;

				movlw manita2_2;
			    movwf portd;
				movlw col_5;
				movwf portb;
				call delayx;
	
				decfsz contadorx,f;
				goto monito_4;


			

				goto loop_prin

            
                 ;=============================================
                 ;==  Subrutina de retardo de 4 ms         ==
                 ;=============================================
delayx
				movlw d'177';
				movwf tmr0;	
retr1
				btfss intcon,t0if;
				goto retr1;
				bcf intcon,t0if;
					
				return;
			




delayled
		movlw .38;
		movwf unidades;
ent
		movlw d'0'
		movwf tmr0;
cont2   btfss intcon,t0if;
		goto cont2;
		bcf intcon,t0if;
		decfsz unidades,f;
		goto ent;
		return;
;---------------------------------------------------------------------------------------------
   			end
