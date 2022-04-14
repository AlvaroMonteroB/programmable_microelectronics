;---------------------------------------------------------------------------------------------

 list p=16f877A;
  
 ;#include "c:\archivos de programa\microchip\mpasm suite\p16f877a.inc";
 #include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  

;Bits de configuraci�n.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF; ALL 
;---------------------------------------------------------------------------------------------
;
;fosc = 3.579545 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1.11 �s.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms  ;// Tiempo de interrupcion.
;R=249,  P=128.
;frec int = 1/ t int = 874 Hz.
;
;Ideal
;fosc = 20 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 �s.
;==================================================
;Este programa es el esclavo de otro pic, este ejecuta las funciones de "satelite", midiendo señales analógicas
;Y enviandolas al primer pic
;---------------------------------------------------------------------------------------------
;
; Registros de proposito general Banco 0 de memoria RAM.
;
; Registros propios de estructura del programa
contadorx   equ 0x26;
dato_rx     equ 0x27;
dato_tx     equ 0x28;
letra       equ 0x33;
tx_Data1     EQU 0X34;
temporal    equ 0x2a;
temp        equ 0x2b;temporal de la conversi�n
temp1       equ 0x2c;temporal de la letra de la variable
dato_1      equ 0x41
dato_2      equ 0x42
dato_3      equ 0x43
dato_4      equ 0x44
dato_5      equ 0x45
contadoraa  equ 0x46;
uni_med     equ 0x40;
c_millar    equ 0x71;
d_millar    equ 0x72;
u_millar    equ 0x73;
centenas    equ 0x74;
decenas     equ 0x75;
unidades    equ 0x76;
decimas     equ 0x77;
centesimas  equ 0x78;
mult        equ 0x79;
re_mult1    equ 0x7a;
re_mult2    equ 0x7b;
resad       equ 0x7c; entero
resdec      equ 0x7d; decimal
resco       equ 0x7e;
car_temp    equ 0x6f;
; 
;---------------------------------------------------------------------------------------------
;
;Constantes.
;
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
Car_C         equ b'00111001';
Car_P         equ b'01110011';
;
;---------------------------------------------------------------------------------------------
; 
;Asignaci�n de los bits de los puertos de I/O.
;Puerto A.
Ent_Se�al     equ          .0; // Se�al a digitalizar.
Sin_UsoRA1    equ          .1; // Sin Uso RA1.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111111'; // Programaci�n inicial del puerto A.

;Puerto B.
fun_en        equ          .0; // FUNCTION ENABLE.
Sin_UsoRB1    equ          .1; // Sin Uso RB1.
Sin_UsoRB2    equ          .2; // Sin Uso RB2.
Sin_UsoRB3    equ          .3; // Sin Uso RB3.
Sin_UsoRB4    equ          .4; // Sin Uso RB4.
Sin_UsoRB5    equ          .5; // Sin Uso RB5.
Bit_D0ADC     equ          .6; // Bit 0 de datos para el ADC.
Bit_D1ADC     equ          .7; // Bit 1 de datos para el ADC.

progb         equ b'00000000'; // Programaci�n inicial del puerto B.

;Puerto C.

Bit_D2ADC     equ          .0; // Bit 2 de datos para el ADC.
Bit_D3ADC     equ          .1; // Bit 3 de datos para el ADC.
Bit_D4ADC     equ          .2; // Bit 4 de datos para el ADC.
Bit_D5ADC     equ          .3; // Bit 5 de datos para el ADC.
Bit_D6ADC     equ          .4; // Bit 6 de datos para el ADC.
Bit_D7ADC     equ          .5; // Bit 7 de datos para el ADC.
tx_databit     equ          .6; // Bit 8 de datos para el ADC.
rx_databit     equ          .7; // Bit 9 de datos para el ADC.

progc         equ b'10000000'; // Programaci�n inicial del puerto C como salida

;Puerto D.
Com_Disp0   equ          .0; // Reservado LCD.
Com_Disp1   equ          .1; // Reservado LCD.
Com_Disp2   equ          .2; // Reservado LCD.
Com_Disp3   equ          .3; // Reservado LCD.
Com_Disp4   equ          .4; // Reservado LCD.
com_disp5   equ          .5; // Reservado LCD.
Com_Disp6   equ          .6; // Reservado LCD.
Com_Disp7   equ          .7; // Reservado LCD.

progd         equ b'00000000'; // Programaci�n inicial del puerto D como salida
 
;Puerto E.
res_LCD_RE0   equ          .0; // Reservado LCD.
res_LCD_RE1   equ          .1; // Reservado LCD.
led_op	      equ          .2; // Sin Uso RE2.

proge         equ      b'000'; // Programaci�n inicial del puerto E.
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
                 movlw b'00001100'; Justificado a la izquierda, AN0 Anal�gico,                   
                 movwf adcon1 ^0x80;
                 bcf status,rp0;  
			   
				 movlw b'10000001'; focs/32 - AN0 - 
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
loop_prin				
rx_data
				nop;
				btfsc portc,rx_databit;
				goto rx_data;
RX2				call retardo624;subrutina de retardo de bit y medio de 624.9 useg
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
				movwf portb;
				movwf car_temp;

mod_analog		 
				 movlw 'P';
				 xorwf car_temp,w;
				 btfsc status,z;
				 goto fue_an0;
				 

			     movlw 'T';
				 xorwf car_temp,w;
				 btfsc status,z;
				 goto fue_an1;
				 goto loop_prin;
				 


				 
				 

fue_an0
				 movlw b'10000001';configuraci�n del adcon
				 movwf adcon0;
				 movlw .65;mueve configuraci�n de la conversi�n para sensor de presi�n
				 movwf temp;
				 movlw b'01110011';
				 movwf temp1;
				 movlw car_p;
				 movwf dato_4;
				 goto muestrea;
fue_an1
				 movlw b'10001001';
				 movwf adcon0;
				 movlw .39; configuraci�n 2 para el sensor de temperatura
				 movwf temp;
				 movlw b'00111001';
				 movwf temp1;
				 movlw car_c;
				 movwf dato_4;
				 goto muestrea;
				
				 
				                 

muestrea         call delay_40us;
                 bsf adcon0,go_done;arranca la conversi�n
esp_conver       nop;
				 btfss portc,tx_databit;
				 goto rx2;
                 btfsc adcon0,go_done;
                 goto esp_conver;        esp a que termine la conversi�n
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
                 ;==  Subrutina de conversion binario a ASCII  ==
                 ;===================================================
conv_varascii  
			
			     movf d_millar,w;
                 movwf temporal;
                 call conv_ASCII;
                 movf temporal,w;
                 movwf dato_1;
					btfss portc,rx_databit;
					goto rx2;

                 movf u_millar,w;
                 movwf temporal;
                 call conv_ASCII;
                 movf temporal,w;
                 movwf dato_2; 
			   	btfss portc,rx_databit;
					goto rx2;

				 movf centenas,w;
				 movwf temporal;
				 call conv_ASCII;
				 movf temporal,w;
				 movwf dato_3;
				btfss portc,rx_databit;
					goto rx2;

			 	 	

                 
;---------------------------------------------------------------------------------------------
Config_tx	
				btfss letra,.0;letra,0 en uno para presi�n
				goto config_temp;
				goto config_press;
config_press
				goto tx_datatemp;
config_temp
				bcf dato_2,.7;
				goto tx_datatemp;


;---------------------------------------------------------------------------------------------
;se mueve los datos en tx----------------------------------------------------------------
tx_dataTemp				
		    		    movlw b'10000000';
						iorwf dato_2,1;
						call retardo_demilis
						movf dato_1,w;
						movwf tx_data1; 
						call tx_data;
						btfss portc,rx_databit;
						goto rx2;
						movf dato_2,w;
						movwf tx_data1;
						call tx_data;
						btfss portc,rx_databit;
						goto rx2;
						movf dato_3,w;
						movwf tx_data1;
						call tx_data;
						btfss portc,rx_databit;
						goto rx2;
						movf dato_4,w;
						movwf tx_data1;
						call tx_data;
						btfss portc,rx_databit;
						goto rx2;




                        

	
		
				
                                  
               
                 
ayno  	
			   call retardo_1seg;
               goto muestrea;
;-------------------------------------------------------------------------------------
conv_ASCII        movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cero;
                 movlw .1;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_uno; 
                 movlw .2;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_dos; 
                 movlw .3;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_tres; 
                 movlw .4;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cuatro;
                 movlw .5;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cinco; 
                 movlw .6;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_seis; 
                 movlw .7;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_siete; 
                 movlw .8;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ocho; 
                 movlw .9;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_nueve; 

fue_cero         movlw car_0;
                 movwf temporal;
                 goto sal_conv;

fue_uno          movlw car_1;
                 movwf temporal;
                 goto sal_conv;

fue_dos          movlw car_2;
                 movwf temporal;
                 goto sal_conv;

fue_tres         movlw car_3;
                 movwf temporal;
                 goto sal_conv;  

fue_cuatro       movlw car_4;
                 movwf temporal;
                 goto sal_conv;  

fue_cinco        movlw car_5;
                 movwf temporal;
                 goto sal_conv; 

fue_seis         movlw car_6;
                 movwf temporal;
                 goto sal_conv; 

fue_siete        movlw car_7;
                 movwf temporal;
                 goto sal_conv;  

fue_ocho         movlw car_8;
                 movwf temporal;
                 goto sal_conv; 

fue_nueve        movlw car_9;
                 movwf temporal;
                                  
sal_conv         return;
;--------------------------------------------------------------
bin_dec
	        clrf unidades;
            clrf decenas;
            clrf centenas;
            clrf decimas;
            clrf centesimas;	
            
            clrw;
            xorwf resad,w;
            btfsc status,z;
            goto cents1;

bin_dec1    incf	unidades			;incrementa unidades
			movlw	0x0a				;ya se cumplieron 10
			xorwf	unidades,w;			
			btfss	status,z			;	
			goto	dec_resad1			;no, entonces decrementa "resad"
			clrf	unidades			;vuelve a "0" las unidades

			incf	decenas				;incrementa decenas
			movlw	0x0a				;ya se cumplieron 10
			xorwf	decenas,w;			
			btfss	status,z;
			goto	dec_resad1			;no, entonces decrementa "resad"
			clrf	decenas				;vuelve a "0" las decenas

			incf	centenas			;incrementa centenas
			movlw	0x0a				;ya se cumplieron 10
			xorwf	centenas,w			
			btfss	status,z
			goto	dec_resad1			;no, entonces decrementa "resad"
			clrf	centenas			;vuelve a "0" las centenas

dec_resad1 	decfsz	resad,f				;decrementa "resad" y verifica si es "0"
			goto	bin_dec1		    ;no, entonces vuelve a inc. valores
			
cents1 		btfss	resdec,7
			goto	dosbajos1
			btfss	resdec,6
			goto	caso_10
			goto 	caso_11
			return

dosbajos1 	btfss	resdec,6
			goto	caso_00
			goto 	caso_01

caso_00 	movlw	0x00
			movwf	centesimas
			movlw	0x00
			movwf	decimas
			return

caso_01 	movlw	0x02
			movwf	centesimas
			movlw	0x05
			movwf	decimas
			return

caso_10  	movlw	0x05
			movwf	centesimas
			movlw	0x00
			movwf	decimas
			return

caso_11 	movlw	0x07
			movwf	centesimas
			movlw	0x05
			movwf	decimas
			return

; ........................subrutinas de conversi�n binario - voltaje..................................

bin_voltaje clrf unidades;
            clrf decenas;
            clrf centenas;
            clrf u_millar;
            clrf d_millar;
            clrf c_millar;
            clrf re_mult1;
            clrf re_mult2;
            movf temp,w;mueve la configuraci�n que se le puso a w
            movwf mult;
				btfss portc,rx_databit;
					goto rx2;
 
multiplica  movf resco,w;
            addwf re_mult1,f;
            btfsc status,c;
            incf re_mult2;
            decfsz mult;
            goto multiplica;

            clrw;
            xorwf re_mult1,w;
            btfss status,z;
            goto ini_con;

            clrw;
            xorwf re_mult2,w;
            btfss status,z;
            goto ini_con;
            goto fin;     

ini_con     decf re_mult1;
            movlw 0xff;
            xorwf re_mult1,w;
            btfsc status,z;
            decf re_mult2;   
			btfss portc,rx_databit;
					goto rx2;    

bin_volt    incf	unidades			;incrementa unidades
			movlw	0x0a				;ya se cumplieron 10
			xorwf	unidades,w			
			btfss	status,z			;	
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	unidades			;vuelve a "0" las unidades

			incf	decenas				;incrementa decenas
			movlw	0x0a				;ya se cumplieron 10
			xorwf	decenas,w			
			btfss	status,z
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	decenas				;vuelve a "0" las decenas

			incf	centenas			;incrementa centenas
			movlw	0x0a				;ya se cumplieron 10
			xorwf	centenas,w			
			btfss	status,z
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	centenas			;vuelve a "0" las centenas

			incf	u_millar			;incrementa cu_millar
			movlw	0x0a				;ya se cumplieron 10
			xorwf	u_millar,w			
			btfss	status,z
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	u_millar			;vuelve a "0" las u_millar

			incf	d_millar			;incrementa cu_millar
			movlw	0x0a				;ya se cumplieron 10
			xorwf	d_millar,w			
			btfss	status,z
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	d_millar			;vuelve a "0" las u_millar

			incf	c_millar			;incrementa cu_millar
			movlw	0x0a				;ya se cumplieron 10
			xorwf	c_millar,w			
			btfss	status,z
			goto	dec_resad2			;no, entonces decrementa "resad"
			clrf	c_millar			;vuelve a "0" las u_millar

dec_resad2 	decf	re_mult1
            movlw   0xff;
            xorwf   re_mult1,w
            btfss   status,z
			goto	bin_volt

            decf    re_mult2
            movlw   0xff;
            xorwf   re_mult2,w
            btfss   status,z
            goto    bin_volt;
fin         return

;-------------------------------------------------------------------------------------------------------------------------------------------------
;SUBUTINA TX;
TX_Data                 nop;                     
                        bcf portc,TX_dataBit;   
                        call retardo416;

                        bcf intcon,gie;   

                        movlw .8;
                        movwf Contadorx;
sig_TxDato              rrf tx_data1,f;
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

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;vale 4 en realidad
retardo_1seg
			
			call config_timer2;
			movlw .80;
			movwf contadoraa;
unseg       movlw .59;
			movwf tmr0;
uyno  
			btfss portc,rx_databit;
			goto rx2;      
			btfss intcon,t0if;
			goto uyno;
			bcf intcon,t0if;
			DECFSZ contadoraa,f;
			goto unseg;

			return;

retardo_demilis
				movlw .140;
				movwf tmr0;
ayayay
				btfss portc,rx_databit;
				goto rx2;
				btfss intcon,t0if;
				goto ayayay;
				bcf intcon,t0if;
				return;



                 ;================
                 ;==  librer�as ==
                 ;================
#include <retardos.inc>
#include <Bin_Dec1.inc>

;---------------------------------------------------------------------------------------------

	end