;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: examen
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
;INTEGRANTES: 
 ;1.- Montero Alvaro
 
 ;Este programa transmite un potenciometro a la pc

;---------------------------------------------------------------------------------------------

 list p=16f877A;
  
 ;#include "c:\archivos de programa\microchip\mpasm suite\p16f877a.inc";
 #include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  

;Bits de configuración.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF; ALL 
;---------------------------------------------------------------------------------------------
;
;fosc = 3.579545 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1.11 µs.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms  ;// Tiempo de interrupcion.
;R=249,  P=128.
;frec int = 1/ t int = 874 Hz.
;
;Ideal
;fosc = 20 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
;
;---------------------------------------------------------------------------------------------
;
; Registros de proposito general Banco 0 de memoria RAM.
;
; Registros propios de estructura del programa
; 
;---------------------------------------------------------------------------------------------
;
;variable.
les	  		  equ   	 0x24;
serial_tx     equ        0x25;
contadorx     equ        0x26;
;
;
;---------------------------------------------------------------------------------------------
; 
;Asignaciòn de los bits de los puertos de I/O.
;Puerto A.
Ent_Señal     equ          .0; // Señal a digitalizar.
Sin_UsoRA1    equ          .1; // Sin Uso RA1.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111111'; // Programaciòn inicial del puerto A.

;Puerto B.
Sin_UsoRB0    equ          .0; // Sin Uso RB0.
Sin_UsoRB1    equ          .1; // Sin Uso RB1.
Sin_UsoRB2    equ          .2; // Sin Uso RB2.
Sin_UsoRB3    equ          .3; // Sin Uso RB3.
Sin_UsoRB4    equ          .4; // Sin Uso RB4.
int		      equ          .5; // pa la interrupcion
Bit_D0ADC     equ          .6; // Bit 0 de datos para el ADC.
Bit_D1ADC     equ          .7; // Bit 1 de datos para el ADC.

progb         equ b'11111111'; // Programaciòn inicial del puerto B.

;Puerto C.

Bit_D2ADC     equ          .0; // Bit 2 de datos para el ADC.
Bit_D3ADC     equ          .1; // Bit 3 de datos para el ADC.
Bit_D4ADC     equ          .2; // Bit 4 de datos para el ADC.
Bit_D5ADC     equ          .3; // Bit 5 de datos para el ADC.
Bit_D6ADC     equ          .4; // Bit 6 de datos para el ADC.
Bit_D7ADC     equ          .5; // Bit 7 de datos para el ADC.
tx_databit     equ          .6; // Bit 8 de datos para el ADC.
Bit_D9ADC     equ          .7; // Bit 9 de datos para el ADC.

progc         equ b'00000000'; // Programaciòn inicial del puerto C como entrada.

;Puerto D.
Com_Disp0   equ          .0; // Reservado LCD.
Com_Disp1   equ          .1; // Reservado LCD.
Com_Disp2   equ          .2; // Reservado LCD.
Com_Disp3   equ          .3; // Reservado LCD.
Com_Disp4   equ          .4; // Reservado LCD.
Com_Disp5   equ          .5; // Reservado LCD.
Com_Disp6   equ          .6; // Reservado LCD.
Com_Disp7   equ          .7; // Reservado LCD.

progd         equ b'00000000'; // Programaciòn inicial del puerto D como entradas.
 
;Puerto E.
res_LCD_RE0   equ          .0; // Reservado LCD.
res_LCD_RE1   equ          .1; // Reservado LCD.
led_op	      equ          .2; // Sin Uso RE2.

proge         equ      b'000'; // Programaciòn inicial del puerto E.
;---------------------------------------------------------------------------------------------
 
                 ;====================
                 ;==  Vector reset  ==
                 ;====================
                 org 0x0000;         
vec_reset        clrf pclath;  pclath <- 00h
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
                 ;==  subrutina de inicio  ==
                 ;===========================
                 org 0x0006;

                
;---------------------------------------------------------------------------------------------
				
prog_ini         bsf status,rp0;
                 movlw b'10000001';                      
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
                 movlw b'0001100'; Justificado a la izquierda, AN0 Analógico,                   
                 movwf adcon1 ^0x80;
                 bcf status,rp0; 
				movlw b'10001000';
				movwf intcon; 
			   
				 movlw b'10000001'; focs/32 - AN0 - Activa ADC
                 movwf adcon0;	
			     call delay_40us;	
				 
				 clrf portc;
				 bsf portc,tx_databit;
				 clrf portb;  
				
				

                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  programa principal  ==
                 ;==========================
prog_prin        call prog_ini;
				
                 

muestrea         call delay_40us;
                 bsf adcon0,go_done;arranca la conversión
esp_conver       nop;
                 btfsc adcon0,go_done;
                 goto esp_conver;        esp a que termine la conversión
                 bsf status,RP0;
                 movf ADRESL ^0x80,w;
                 bcf status,RP0;
				 movwf resdec;
                 movf ADRESH,w;
                 movwf resad; 
                 movwf resco;
                 call bin_dec; 
                 call bin_voltaje;
				 ;===================================================
                 ;==  Subrutina de conversion binario L,E,H ==
                 ;===================================================
CONV_LEH  
			
			     movf d_millar,w;
                 movwf temporal;
                 movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ceroa;
                 movlw .1;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_unoa; 
                 movlw .2;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_dosa; 
                 movlw .3;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_tresa; 
                 movlw .4;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cuatroa;
                 movlw .5;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cincoa; ;
                 movf temporal,w;
                 movwf d_millar;




fue_ceroa         
                 goto verif_dec1;

fue_unoa          
                 goto fue_e;

fue_dosa         movlw Car_2;
                 movwf temporal;
                 goto verif_dec2	;

fue_tresa         movlw Car_3;
                 movwf temporal;
                 goto fue_h;  

fue_cuatroa       movlw Car_4;
                 movwf temporal;
                 goto fue_h;  

fue_cincoa        movlw Car_5;
                 movwf temporal;
                 goto fue_h; 











 

verif_dec1      
	             movf u_millar,w; aqui se verifica el decimal de low a E
				 movwf temporal; 
			     movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cerob;
                 movlw .1;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_unob; 
                 movlw .2;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_dosb; 
                 movlw .3;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_tresb; 
                 movlw .4;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cuatrob;
                 movlw .5;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cincob; 
                 movlw .6;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_seisb; 
                 movlw .7;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_sieteb; 
                 movlw .8;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ochob; 
                 movlw .9;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_nueveb; 

fue_cerob        
                 goto fue_l;

fue_unob          
                 goto fue_l

fue_dosb         
                 goto fue_l;

fue_tresb         
                 goto fue_l;  

fue_cuatrob      
                 goto fue_l;  

fue_cincob       
                 goto fue_l; 

fue_seisb        
                 goto fue_l; 

fue_sieteb        
                 goto verif_cent1;  

fue_ochob         
                 goto fue_e; 

fue_nueveb        
				 goto fue_e
                                  




verif_cent1
;se verifica de e a h
				movf centenas,w;
				movwf temporal;
      			 movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ceroc;
                 goto fue_e;

fue_ceroc        
                 goto fue_l;

    


                 

verif_dec2	
				 movf u_millar,w;
				 movwf temporal
			       movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cerod;
                 movlw .1;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_unod; 
                 movlw .2;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_dosd; 
                 movlw .3;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_tresd; 
                 movlw .4;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cuatrod;
                 movlw .5;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cincod; 
                 movlw .6;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_seisd; 
                 movlw .7;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_sieted; 
                 movlw .8;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ochod; 
                 movlw .9;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_nueved; 

fue_cerod         
                 goto fue_e;

fue_unod          
                 goto fue_e;

fue_dosd          
                 goto fue_e;

fue_tresd         
                 goto verif_cent2;  

fue_cuatrod       
                 goto fue_h;  

fue_cincod        
                 goto fue_h; 

fue_seisd         
                 goto fue_h; 

fue_sieted        
                 goto fue_h;  

fue_ochod         
                 goto fue_h; 

fue_nueved        
				 goto fue_h;
                                  
 


verif_cent2
				movf centenas,w;
				movwf temporal;
      			 movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ceroe;
				 goto fue_h;
                

fue_ceroe        
                 goto fue_e;

				 
				 

			 	 
fue_l
			movlw 'L';
			movwf portc;
			goto mues_num;

fue_e
			movlw 'I';
			movwf portc;
			goto mues_num;

fue_h		
		movlw 'H';
		movwf portc;
				
		
				
                                  
mues_num
		 bcf portd,com_disp0;
		 nop;
		 call calculo;
		 bsf portd,com_disp0;
		 nop;
	     goto muestrea
		                 
				
                 
                 
                 
;---------------------------------------------------------------------------------------------
 
;SUBRUTINA TX
tx_1
                        nop;                     
                        bcf portc,TX_dataBit;   
                        call retardo416;

                        bcf intcon,gie;   

                        movlw .8;
                        movwf Contadorx;
sig_TxDato              rrf serial_tx,f;
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


;---------------------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------------

                 ;================
                 ;==  librerías ==
                 ;================



#include <Bin_Dec1.inc>
#include <retardos.inc>

;---------------------------------------------------------------------------------------------

	end