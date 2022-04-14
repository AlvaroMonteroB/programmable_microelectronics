;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: 2a
 ;
 ;
 ;
 ;GRUPO: 6IV2.  
 ;
 ;Este programa convierte una señal analógica a digital

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
;Constantes.
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
Sin_UsoRB5    equ          .5; // Sin Uso RB5.
Bit_D0ADC     equ          .6; // Bit 0 de datos para el ADC.
Bit_D1ADC     equ          .7; // Bit 1 de datos para el ADC.

progb         equ b'00111111'; // Programaciòn inicial del puerto B.

;Puerto C.

Bit_D2ADC     equ          .0; // Bit 2 de datos para el ADC.
Bit_D3ADC     equ          .1; // Bit 3 de datos para el ADC.
Bit_D4ADC     equ          .2; // Bit 4 de datos para el ADC.
Bit_D5ADC     equ          .3; // Bit 5 de datos para el ADC.
Bit_D6ADC     equ          .4; // Bit 6 de datos para el ADC.
Bit_D7ADC     equ          .5; // Bit 7 de datos para el ADC.
Bit_D8ADC     equ          .6; // Bit 8 de datos para el ADC.
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
			   
				 movlw b'10000001'; focs/32 - AN0 - Activa ADC
                 movwf adcon0;	
			     call delay_40us;	
				 
				 clrf portc;
				 clrf portb;  
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
                 ;==  Subrutina de conversion binario 7 segmentos  ==
                 ;===================================================
conv_var7seg   
			
			     movf d_millar,w;
                 movwf temporal;
                 call conv_7seg;
                 movf temporal,w;
                 movwf d_millar; 

                 movf u_millar,w;
                 movwf temporal;
                 call conv_7seg;
                 movf temporal,w;
                 movwf u_millar; 

				 movf centenas,w;
				 movwf temporal;
				 call conv_7seg;
				 movf temporal,w;
				 movwf centenas;

			 	 
		
				
		
				
                                  
                
				movlw .16;
				movwf cuentaa;
men
				movf d_millar,w;
				movwf portc;
				bcf portd,com_disp0;
				bsf portc,Bit_D9ADC;
				nop;
				call retardo2ms;
				call retardo2ms;
				bsf portd,com_disp0;
				bcf portd,Bit_D9ADC;
				nop;
			
				movf u_millar,w;
				movwf portc;
				bcf portd,com_disp1;
				nop;
				call retardo2ms;
				call retardo2ms;
				bsf portd,com_disp1;
				nop;
			
				movf centenas,w;
				movwf portc;
				bcf portd,com_disp2;
				nop;
				call retardo2ms;
				call retardo2ms;
				bsf portd,com_disp2;
				nop;

				movlw b'00011100';
				movwf portc;
				bcf portd,com_disp3;
				nop;
				call retardo2ms;
				call retardo2ms;
				bsf portd,com_disp3;
				nop;
				decfsz cuentaa;
				goto men;
                 
                 goto muestrea;
                 
;---------------------------------------------------------------------------------------------

                



;---------------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------------

                 ;================
                 ;==  librerías ==
                 ;================

#include <retardos.inc>
#include <Bin_Dec1.inc>

;---------------------------------------------------------------------------------------------

	end
