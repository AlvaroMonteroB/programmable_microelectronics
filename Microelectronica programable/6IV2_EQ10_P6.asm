;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 6
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
 ;Este programa manda mensajes en comunicacion en serie usando un teclado matricial
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
contadorx     equ        0x21;
dato_tx       equ        0x22;
decenas       equ		 0x23;








;---------------------------------------------------------------------------------------------
;
;Constantes.

O			  equ      	  .79;
PP			  equ		   .3;
Q			  equ		   .4;



;Constantes de caracteres en siete segmentos.
;                   PONMLKJIHGFEDCBA
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
Ren1      equ          .0; // Pin de salida para activar el renglon 1 del teclado.
Ren2      equ          .1; // Pin de salida para activar el renglon 2 del teclado.
Ren3      equ          .2; // Pin de salida para activar el renglon 3 del teclado.
Ren4      equ          .3; // Pin de salida para activar el renglon 4 del teclado.
Col_1        equ          .4; // Pin de entrada para leer el codigo de la tecla oprimida.
Col_2         equ          .5; // Pin de entrada para leer el codigo de la tecla oprimida.
Col_3         equ          .6; // Pin de entrada para leer el codigo de la tecla oprimida.
Col_4         equ          .7; // Pin de entrada para leer el codigo de la tecla oprimida.

progb         equ b'11110000'; // Programaciòn inicial del puerto B.

;Puerto C.
seg_a     equ          .0; // Bit que controla el comun del display 0.
seg_b     equ          .1; // Bit que controla el comun del display 1.
seg_c     equ          .2; // Bit que controla el comun del display 2.
seg_d     equ          .3; // Bit que controla el comun del display 3.
seg_e     equ          .4; // Bit que controla el comun del display 4.
seg_f     equ          .5; // Bit que controla el comun del display 5.
tx_databit     equ     .6; // Bit que controla el comun del display 6.
seg_h     equ     .7; // Bit que controla el comun del display 7.


progc         equ b'00000000'; // Programaciòn inicial del puerto C.

;Puerto D.
seg_i   equ     .0; // Sin Uso RD2..
seg_j   equ     .1; // Sin Uso RD2.
seg_k   equ     .2; // Sin Uso RD3.
seg_l   equ     .3
seg_m   equ     .4; // Sin Uso RD5.
seg_n   equ     .5; // Sin Uso RD6.
seg_o    equ    .6; // Sin Uso RD7.
seg_p    equ    .7

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
				 clrf portb;
				 bsf portb,ren1;
				 bsf portb,ren2;
				 bsf portb,ren3;
				 bsf portb,ren4;
				 
                 clrf portd;
				 clrf portc;
                
			
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
				 bsf portc,tx_databit;
				
loop_prin
Barrido
				 bsf portb,ren1;
				 bsf portb,ren2;
				 bsf portb,ren3;
				 bsf portb,ren4;
			     nop;
bar_tec
		       
				 bsf portb,Ren4;
                 bcf portb,Ren1;
                 btfss portb,Col_1;
                 goto Fue_Tec1;
                 btfss portb,Col_2;
                 goto Fue_Tec2;
                 btfss portb,Col_3;
                 goto Fue_Tec3;
                 btfss portb,Col_4;
                 goto Fue_TecA;
                 
                 bsf portb,Ren1;
                 bcf portb,Ren2;
                 btfss portb,Col_1;
                 goto Fue_Tec4;
                 btfss portb,Col_2;
                 goto Fue_Tec5;
                 btfss portb,Col_3;
                 goto Fue_Tec6;
                 btfss portb,Col_4;
                 goto Fue_TecB;       

                 bsf portb,Ren2;
                 bcf portb,Ren3;
                 btfss portb,Col_1;
                 goto Fue_Tec7;
                 btfss portb,Col_2;
                 goto Fue_Tec8;
                 btfss portb,Col_3;
                 goto Fue_Tec9;
                 btfss portb,Col_4;
                 goto Fue_TecC;     

                 bsf portb,Ren3;
                 bcf portb,Ren4;
                 btfss portb,Col_1;
                 goto Fue_TecAster;
                 btfss portb,Col_2;
                 goto Fue_Tec0;
                 btfss portb,Col_3;
                 goto Fue_Tecgato;
                 btfss portb,Col_4;
                 goto Fue_TecD;      
      
                 goto bar_tec;

fue_tec0
				movlw '0';
				
protec_0
				btfss portb,col_2;
				goto protec_0;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec1
				movlw '1';
protec_1
				btfss portb,col_1;
				goto protec_1;
				movwf dato_tx;
				call tx_1;
				goto fin;

fue_tec2
				movlw '2';
protec_2
				btfss portb,col_2;
				goto protec_2;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec3
				movlw '3';
protec_3
				btfss portb,col_3;
				goto protec_3;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec4
				movlw '4';
protec_4
				btfss portb,col_1;
				goto protec_4;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec5
				movlw '5';
protec_5
				btfss portb,col_2;
				goto protec_5;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec6
				movlw '6';
protec_6
				btfss portb,col_3;
				goto protec_6;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec7
				movlw '7';
protec_7
				btfss portb,col_1;
				goto protec_7;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec8
				movlw '8';
protec_8
				btfss portb,col_2;
				goto protec_8;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tec9
				movlw '9';
protec_9
				btfss portb,col_3;
				goto protec_9;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_teca
				movlw 'A';
protec_a
				btfss portb,col_4;
				goto protec_a;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tecb
				movlw 'B';
protec_b
				btfss portb,col_4;
				goto protec_b;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tecc
				movlw 'C';
protec_c
				btfss portb,col_4;
				goto protec_c;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tecd
				movlw 'D';
protec_d
				btfss portb,col_4;
				goto protec_d;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tecaster
				movlw '*'
protec_aster
				btfss portb,col_1;
				goto protec_aster;
				movwf dato_tx;
				call tx_1;
				goto fin;
fue_tecGATO
				movlw '#';
protec_gato
				btfss portb,col_3;
				goto protec_GATO;
				movwf dato_tx;
				call tx_1;
				goto fin;


fin
				call ret_us
        		goto loop_prin;


     
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
;SUBRUTINA TX
tx_1
                        nop;                     
                        bcf portc,TX_dataBit;   
                        call retardo416;

                        bcf intcon,gie;   

                        movlw .8;
                        movwf Contadorx;
sig_TxDato              rrf Dato_tx,f;
                        btfss status,C;
                        goto bit_enCeroTX;
                        bsf portc,TX_dataBit;  
                        goto cont_TX;
bit_enCeroTX            bcf portc,TX_dataBit;
cont_TX                 call retardo416;
                        decfsz Contadorx,f;
                        goto sig_TxDato;

                        bsf intcon,gie;
                        
                        bsf portc,TX_dataBit;
						call retardo_milis;
                        return;


;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
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



ret_us
		movlw .255;
		movwf tmr0;
cont3   btfss intcon,t0if;
		goto cont3;
		bcf intcon,t0if;
		return;

 ;=====================================
                        ;== Subrutina de retardo de 40ms  ====
                        ;=====================================
retardo_milis           movlw .98;
						movwf tmr0;
milis_milis	
						btfss intcon,t0if;
						goto milis_milis;
						bcf intcon,t0if;

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

delayx

				movlw d'239';
				movwf tmr0;	
retr1

				btfss intcon,t0if;
				goto retr1;
				bcf intcon,t0if;
					
				return;


;------------------------------------------------------------------------
				end;