;librería pic16f877a
#include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  

;variables

temporal    equ 0x2a;
temporal    equ 0x2a;
temp        equ 0x2b;temporal de la conversión
temp1       equ 0x2c;temporal de la letra de la variable
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
; ........................subrutinas de conversión binario - decimal..................................

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

; ........................subrutinas de conversión binario - voltaje..................................

bin_voltaje clrf unidades;
            clrf decenas;
            clrf centenas;
            clrf u_millar;
            clrf d_millar;
            clrf c_millar;
            clrf re_mult1;
            clrf re_mult2;
            movf temp,w;mueve la configuración que se le puso a w
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
;=======================BINARIO A ASCII==============================================
   ;===================================================================================		    
