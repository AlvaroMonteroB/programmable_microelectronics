;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: EXAMEN PARCIAL
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
 ;INTEGRANTES: 
 ;1.- Montero Alvaro .

 
 ; 
 ;
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
temporal      equ        0x22;
Uni_7seg      equ        0x23;
miau          equ		 0x24;

Contador1     equ        0x25; // 
Contador2     equ        0x26; // 
Contador3     equ        0x27; // 
Contador4     equ        0x28;






;---------------------------------------------------------------------------------------------
;
;Constantes.

O			  equ  		 	  .4;
PP			  equ		   .220;
Q			  equ		   .233;



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
Seg_a         equ          .0; // Salida para controlar el segmento a.
Seg_b         equ          .1; // Salida para controlar el segmento b.
Seg_c         equ          .2; // Salida para controlar el segmento c.
Seg_d         equ          .3; // Salida para controlar el segmento d.
Seg_e         equ          .4; // Salida para controlar el segmento e.
Seg_f         equ          .5; // Salida para controlar el segmento f.
Seg_g         equ          .6; // Salida para controlar el segmento g.
Seg_dp        equ          .7; // Salida para controlar el segmento dp.

progb         equ b'00000000'; // Programaciòn inicial del puerto B.

;Puerto C.
Com_Disp0     equ          .0; // Bit que controla el comun del display 0.
Com_Disp1     equ          .1; // Bit que controla el comun del display 1.
Com_Disp2     equ          .2; // Bit que controla el comun del display 2.
Com_Disp3     equ          .3; // Bit que controla el comun del display 3.
Com_Disp4     equ          .4; // Bit que controla el comun del display 4.
Com_Disp5     equ          .5; // Bit que controla el comun del display 5.
Com_Disp6     equ          .6; // Bit que controla el comun del display 6.
Com_Disp7     equ          .7; // Bit que controla el comun del display 7.


progc         equ b'00000000'; // Programaciòn inicial del puerto C.

;Puerto D.
bit0_num    equ          .0; // Sin Uso RD2.
bit1_num    equ          .1; // Sin Uso RD3.
bit2_num    equ          .2; // Sin Uso RD2.
bit3_num    equ          .3; // Sin Uso RD3.
bit4_num    equ          .4; // Sin Uso RD4.
bit5_num    equ          .5; // Sin Uso RD5.
bit6_num    equ          .6; // Sin Uso RD6.
bit7_num    equ          .7; // Sin Uso RD7.

progd         equ b'11111111'; // Programaciòn inicial del puerto D como entradas.
 
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
vec_int          
				 nop;

                 retfie;               
;---------------------------------------------------------------------------------------------
                 
                 ;===========================
                 ;==  Subrutina de inicio  ==
                 ;===========================
prog_ini         bsf status,rp0; selec. el bco. 1 de ram.
                 movlw 0x81;                       
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
                 clrf portc;
                 
                 bsf porte,Led_Op; Apaga el LED.
                                                    
                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  Programa principal  ==
                 ;==========================
prog_prin        call prog_ini;

				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2; 
				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2;
				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2;
				
loop_prin        call cuenta;
                 
                 goto loop_prin;
;---------------------------------------------------------------------------------------------

                 ;===========================
                 ;==  Subrutina de cuenta  ==
                 ;===========================
cuenta           
				movlw car_1;
				movwf portc;
				call retardo;
				movlw car_5;
				movwf portc;
				call retardo;
				movlw car_9;
			 	movwf portc;
				call retardo;
				movlw car_8;
				movwf portc;
				call retardo;
		        movlw car_7;
				movwf portc;
				call retardo;
				movlw car_3;
				movwf portc;
				call retardo;
				movlw car_2;
				movwf portc;
				call retardo;
				movlw car_4;
				movwf portc;
				call retardo;
				movlw car_6;
				movwf portc;
				call retardo;
				movlw car_0; 
				movwf portc;
				call retardo; 
            
                 
                

             return;   
;---------------------------------------------------------------------------------------------  
				 ;=============================================
                 ;==  Subrutina de retardo de medio segundo  ==
                 ;=============================================
retardo2         movlw .41;
                 movwf Contador3;
Loop32           movlw .167;
                 movwf Contador2;
Loop22           movlw .23;                   
                 movwf Contador1;   
Loop12           decfsz Contador1,f;  
                 goto Loop12;
                 decfsz Contador2,f;
                 goto Loop22; 
                 decfsz Contador3,f;
                 goto Loop32;

                 return;
                  


					;===========
                 ;==  Subrutina de retardo de 2 milisegs  ==
                 ;=============================================
retardo          movlw O;
                 movwf Contador3;
Loop33           movlw PP;
                 movwf Contador2;
Loop23 	         movlw Q;                   
                 movwf Contador1;   
Loop13           decfsz Contador1,f;  
                 goto Loop13;
                 decfsz Contador2,f;
                 goto Loop23; 
                 decfsz Contador3,f;
                 goto Loop33;

                 return;
;---------------------------------------------------------------------------------------------
   			end   
