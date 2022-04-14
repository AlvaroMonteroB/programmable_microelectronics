;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 2b parte 1
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
 ;
 ;Este programa ejecuta un pwm automatico que sube y baja gradualmente la velocidad de un motor
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





;---------------------------------------------------------------------------------------------
;





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
sinusorb0         equ          .0; // Salida para controlar el segmento a.
sinusorb1         equ          .1; // Salida para controlar el segmento b.
sinusorb2         equ          .2; // Salida para controlar el segmento c.
sinusorb3         equ          .3; // Salida para controlar el segmento d.
sinusorb4         equ          .4; // Salida para controlar el segmento e.
sinusorb5         equ          .5; // Salida para controlar el segmento f.
sinusorb6         equ          .6; // Salida para controlar el segmento g.
sinusorb7         equ          .7; // Salida para controlar el segmento dp.

progb         equ b'11111111'; // Programaciòn inicial del puerto B.

;Puerto C.
seg_a     equ          .0; // Bit que controla el comun del display 0.
sal_pwm2     equ          .1; // Bit que controla el comun del display 1.
sal_pwm1     equ          .2; // Bit que controla el comun del display 2.
seg_d     equ          .3; // Bit que controla el comun del display 3.
seg_e     equ          .4; // Bit que controla el comun del display 4.
seg_f     equ    .5; // Bit que controla el comun del display 5.
seg_g     equ     .6; // Bit que controla el comun del display 6.
seg_h     equ     .7; // Bit que controla el comun del display 7.


progc         equ b'00000000'; // Programaciòn inicial del puerto C.

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
				 movlw .255;
				 movwf pr2 ^0x80; periodo tmr2
                 bcf status,rp0; reg. bc0. ram.
	
				 movlw b'00001111'; pwm lsb 00
			     movwf ccp1con;
				 movwf ccp2con;
				 movlw .255; ini pwm
				 movwf ccpr1l;
				 movlw b'01111111'; postcaler 16, tmr2 on, preescaler 16
				 movwf t2con; timer2
				 bsf intcon,gie;
				 bcf intcon,t0if;
				
				
				
				 ; Inicialización de registros y/o variables.
               
                                                    
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
						
baja_vel
				      	call ret25ms;
                        decfsz ccpr1l,f;
						goto baja_vel;
                       
						
sube_vel				
						
						incf ccpr1l,f;
						call ret25ms;
						movlw .255;
						xorwf ccpr1l,w;
						btfss status,z;
						goto sube_vel;
						goto loop_prin;
						

;----------------------------------------------------------------------
;retardos

ret25ms
		movlw d'159'
		movwf tmr0;
cont1   btfss intcon,t0if;
		goto cont1;
		bcf intcon,t0if;
		return;



delayled
		movlw .8;
		movwf unidades;
ent
		movlw d'16'
		movwf tmr0;
cont2   btfss intcon,t0if;
		goto cont2;
		bcf intcon,t0if;
		decfsz unidades,f;
		goto ent;
		return;


  end;
