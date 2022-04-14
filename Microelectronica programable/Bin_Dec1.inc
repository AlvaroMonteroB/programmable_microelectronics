;librería pic16f877a
#include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  

;variables
temporal    equ 0x2a;
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



;caracteres en 7 segmentos
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
; ........................subrutinas de conversión binario - decimal..................................

bin_dec     clrf unidades;
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
			xorwf	unidades,w			
			btfss	status,z			;	
			goto	dec_resad1			;no, entonces decrementa "resad"
			clrf	unidades			;vuelve a "0" las unidades

			incf	decenas				;incrementa decenas
			movlw	0x0a				;ya se cumplieron 10
			xorwf	decenas,w			
			btfss	status,z
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

; ........................subrutinas de conversión binario - voltaje..................................

bin_voltaje clrf unidades;
            clrf decenas;
            clrf centenas;
            clrf u_millar;
            clrf d_millar;
            clrf c_millar;
            clrf re_mult1;
            clrf re_mult2;
            movlw d'118';
            movwf mult;
 
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


   ;===================================================================================
;=======================BINARIO A 7 SEGMENTOS==============================================
   ;===================================================================================		    
            conv_7seg        movlw .0;
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

fue_cero         movlw Car_0;
                 movwf temporal;
                 goto sal_conv;

fue_uno          movlw Car_1;
                 movwf temporal;
                 goto sal_conv;

fue_dos          movlw Car_2;
                 movwf temporal;
                 goto sal_conv;

fue_tres         movlw Car_3;
                 movwf temporal;
                 goto sal_conv;  

fue_cuatro       movlw Car_4;
                 movwf temporal;
                 goto sal_conv;  

fue_cinco        movlw Car_5;
                 movwf temporal;
                 goto sal_conv; 

fue_seis         movlw Car_6;
                 movwf temporal;
                 goto sal_conv; 

fue_siete        movlw Car_7;
                 movwf temporal;
                 goto sal_conv;  

fue_ocho         movlw Car_8;
                 movwf temporal;
                 goto sal_conv; 

fue_nueve        movlw Car_9;
                 movwf temporal;
                                  
sal_conv         return;