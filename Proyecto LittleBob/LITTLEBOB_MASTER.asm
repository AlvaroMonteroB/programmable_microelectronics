;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ;   
 ;
 ;Este programa ejecuta comunicacion serial, siendo el master de otro pic
;---------------------------------------------------------------------------------------------
 list p=16f877A
  
;#include "c:\Archivos de programa\Microchip\MPSA Suite\p16f877a.inc";
;#include "c:\Archivos de Programa (x86)\microchip\mpasm suite\p16f877a.inc";  
#include<p16f877a.inc>

;Bits de configuraci�n.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; ALL 
;---------------------------------------------------------------------------------------------
;
;fosc = 4 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 �s.
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
dato_1		  equ		 0x23;
dato_2	 	  equ		 0x24;
dato_3	 	  equ		 0x25;
dato_4	 	  equ		 0x26;
dato_5	 	  equ		 0x27;
car_temp      equ        0x28;
dato_rx       equ        0x29;
dato_tx       equ        0x2a;
dato_1r       equ        0x2b;
dato_2r       equ        0x2c;
dato_3r       equ        0x2d;
dato_4r       equ        0x2e;
dato_5r       equ        0x2f;
con_milis     equ        0x30;
dato_tx2       equ       0x31;
resp_status    equ       0x32;
res_pclath	  equ        0x33;
res_fsr  		equ		 0x34;
barri         equ        0x35;



miau          equ        0x60;



;---------------------------------------------------------------------------------------------
;
;Constantes.

Car_C         equ b'00111001';
Car_P         equ b'01110011';
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


;Constantes de caracteres en siete segmentos.
;                   PGFEDCBA


Car__         equ b'01000000'; Caracter _ en siete segmentos.
Car_null      equ b'00000000'; Caracter nulo en siete segmentos.
;---------------------------------------------------------------------------------------------
; 
;Asignaci�n de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0    equ          .0; // Sin Uso RA0.
Sin_UsoRA1    equ          .1; // Sin Uso RA1.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111111'; // Programaci�n inicial del puerto A.

;Puerto B.
int         equ          .0; // Salida para controlar el segmento a.
col_1              equ          .1; // Salida para controlar el segmento b.
col_2         equ          .2; // Salida para controlar el segmento c.
col_3          equ          .3; // Salida para controlar el segmento d.
col_4             equ          .4; // Salida para controlar el segmento e.
ren1         equ          .5; // Salida para controlar el segmento f.
sinusorb6         equ          .6; // Salida para controlar el segmento g.
sinusorb7         equ          .7; // Salida para controlar el segmento dp.

progb         equ b'00011111'; // Programaci�n inicial del puerto B.

;Puerto C.
seg_a     equ          .0; // Bit que controla el comun del display 0.
seg_b     equ          .1; // Bit que controla el comun del display 1.
catodo4     equ          .2; // Bit que controla el comun del display 2.
catodo3    equ          .3; // Bit que controla el comun del display 3.
catodo2    equ          .4; // salida al pic esclavo
catodo1    equ    .5; // recepcion de datos que llegan del pic esclavo
tx_databit     equ     .6; // salida para transmitir
rx_databit     equ     .7; // entrada para recibir datos


progc         equ b'10000001'; // Programaci�n inicial del puerto C.

;Puerto D.
com_disp0   equ     .0; // Sin Uso RD2.
com_disp1   equ     .1; // Sin Uso RD3.
com_disp2   equ     .2; // Sin Uso RD2.
com_disp3   equ     .3; // Sin Uso RD3.
com_disp4   equ     .4
com_disp5   equ     .5; // Sin Uso RD5.
com_disp6   equ     .6; // Sin Uso RD6.
com_disp7    equ     .7; // Sin Uso RD7.

progd         equ b'00000000'; // Programaci�n inicial del puerto D como salidas
 
;Puerto E.
aa5           equ          .0; // Sin Uso RE0.
Most_num      equ          .1; // Sin Uso RE1.
Led_Op        equ          .2; // Led Op.

proge         equ      b'011'; // Programaci�n inicial del puerto E.
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
vec_int          call save_interrupt;
				 goto bar_tec;
			

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
				 movlw b'10010000';
				 movwf intcon;
				
				 ; Inicializaci�n de registros y/o variables.
                 clrf portd;
                 bsf portc,catodo1;
                 nop;
                 bsf portc,catodo2;
				 nop;
				 bsf portc,catodo3;
				 nop;
				 bsf portc,catodo4;
				 nop;
				
			
                 bsf porte,Led_Op; Apaga el LED.
                                                    
                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  Programa principal  ==
                 ;==========================
prog_prin        call prog_ini;

			     bsf portc,rx_databit;
				

bar_tec
		       
				 bcf intcon,gie;
				 bsf intcon,gie;
				 bcf portb,ren1;
                 btfss portb,Col_1;
                 goto Fue_Tecn;
                 btfss portb,Col_2;
                 goto Fue_Tecs;
                 btfss portb,Col_3;
                 goto Fue_Tecp;
                 btfss portb,Col_4;
                 goto Fue_Tect;
				 goto bar_tec;
fue_tecn;
				movlw 'n';
				movwf portd;
protec_n
				btfss portb,col_1;
				goto protec_n;
				goto fue_n;
			

fue_tecs

				call ret_1seg;
protec_s
				btfss portb,col_2;
				goto protec_s;
				goto fue_s;
			
fue_tecp

protec_p
				btfss portb,col_3;
				goto protec_p;
				goto fue_p;
			
fue_tect

			
protec_t
				btfss portb,col_3;
				goto protec_t;
				goto fue_t;
			

;dependiendo que letra es, se va a otra subrutina

			




;--------------------------------------------------------------------------------------
;submen� de aplicaciones
;MODOS AUTOMATICOS
;Manda la se�al para medir presi�n al esclavo-----------------------------------------------------------
Medir_Presion	
				movlw 'P';
				movwf dato_tx2;
				movlw car_p;
				movwf portd;
				call tx_1;



modo_esp1
			call salvar_dato;
			call rx_rec;
		
			call mues_num;
			goto modo_esp1
			


			
;Manda la se�al para medir temperatura al esclavo--------------------------------------------------------------
Medir_temperatura
				movlw 'T';
				movwf dato_tx2;
				bsf miau,.0;
				call tx_1;solo manda una letra
				
modo_Esp2
				call salvar_dato;
				call rx_rec; recolector rx de este pic		
				bcf dato_2,.7;
				call mues_num;
				goto modo_esp2;
			
			
			
			
;MODOS MANUALES
;Mostrar el dato que estuvo antes------------------------------------------------------------------------
Most_datAnt


				call dat_ant
				call mues_num;






;mostrar dato aaaaaaaaaa-------------------------------------------------------------------------
most_datIn		
			btfss miau,.0;
			goto medir_temperatura;
			goto medir_presion;


salvar_dato
			movf dato_1,w;
			movwf dato_1r;
			movf dato_2,w;
			movwf dato_2r;
			movf dato_3,w;
			movwf dato_3r;
			movf dato_4,w;
			movwf dato_4r;

			return;
			
;-------------------------------------------------------------------------------------------------------------
dat_ant
		 movf dato_1r,w;
		 movwf dato_1;
		 movf dato_2r,w;
		 movwf dato_2;
		 movf dato_3r,w;
		 movwf dato_3;
		 movf dato_4r,w;
		 movwf dato_4;
 
		 
		 return;
dat_in
			btfsc miau,.0; cuando es 1 es temperatura
			goto medir_temperatura;
			goto medir_presion;
			
			
;---------------------------------------------------------------------------------------------------
;subrutina de rx de recepci�n de datos del pic esclavo
rx_rec			
				bcf portd,com_disp1;

				call rx2;		    
				movf dato_rx,w;
				movwf dato_1;
			

bitnum2			call rx2;
				movf dato_rx,w;
				movwf dato_2;
				

bitnum3			call rx2;
				movf dato_rx,w;
				movwf dato_3;
			


bitnum4			call rx2;
				movf dato_rx,w;
				movwf dato_4;
				movlw car_2;
				movwf portd;
	
			

ayno
				return;


;---------------------------------------------------------------------------
;esta subrutina tx solo mandara si se mide presion o temperatura al pic esclavo

tx_1
                        nop;                     
                        bcf portc,TX_dataBit;   
                        call retardo416;

                        bcf intcon,gie;   

                        movlw .8;
                        movwf Contadorx;
sig_TxDato              rrf Dato_tx2,f;
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

rx2
				nop;
				btfsc portc,rx_databit;
				goto rx2;
				call retardo624;subrutina de retardo de bit y medio de 624.9 useg
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
				return;
	



;esta subrutina muestra los resultados de la medici�n sean 4 o 5 caracteres hacia la terminal---------------------------------------------------------
mues_num	
			movlw .100;
			movwf barri;
barridoo
			movf dato_1,w;
			movwf portd;
			bcf portc,catodo1;
			nop;
			call delayx;
			nop;
			bsf portc,catodo1;
			movf dato_2,w;
			movwf portd;
			bcf portc,catodo2;
			nop;
			call delayx;
			nop;
			bsf portc,catodo2;
			movf dato_3,w;
			movwf portd;
			bcf portc,catodo3;
			nop;
			call delayx;
			nop;
			bsf portc,catodo3;
			movf dato_4,w;
			movwf portd;
			bcf portc,catodo4;
			nop;
			call delayx;
			nop;
			bsf portc,catodo4;
			decfsz barri,f;
			goto barridoo;
			
			return;
			
;--------------------------------------------------------------------------

                      ;===========================================
				;==========             SUBMENU             =================
					  ;===========================================


			
fue_n
				   goto most_datin;
		
				

fue_p
					movlw 'P';
					movwf dato_tx;
					goto medir_presion;
				


;mostrar dato guardado
fue_s
						goto most_datant;
					
fue_t
					movlw 'T';
					movwf dato_tx;
					goto medir_temperatura



;------------------------------------------------------------------------------------------
save_interrupt
                        swapf status,w;
                        movwf resp_status;
                        clrf status;
                        movf pclath,w;
                        movwf res_pclath;
                        clrf pclath;  
                        movf fsr,w;
                        movwf res_fsr;
						movf res_fsr,w;
                        movwf fsr;
                        movf res_pclath,w;
                        movwf pclath;
                        swapf resp_status,w;
                        movwf status;	
						bcf intcon,rbif;
						bcf intcon,intf;
						
			return;
;--------------------------------------------------------------------------
  				 ;=============================================
                 ;==  Subrutina de retardo de 4 ms         ==
                 ;=============================================
					
						




ret_1seg
		movlw .18;
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


   			end