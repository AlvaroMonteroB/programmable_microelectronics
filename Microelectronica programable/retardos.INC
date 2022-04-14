;Librería de retardos

;Librería PIC16F877A
#include "c:\program files (x86)\microchip\mpasm suite\p16f877a.inc";  

;registros
cuenta		equ	0x60
cuenta_2	equ	0x61
cuentaxx    equ 0x20
cuentaa     equ 0x21

;configuración de tmr0 para 32

config_timer1   bsf 	status,rp0;
		    	movlw	b'10000100'
		    	movwf 	option_reg ^0x80;
                bcf 	status,rp0	

                ;bsf		intcon,gie
			    bcf		intcon,t0if

                return


delay_1600us	    call	config_timer1    
					movlw	d'6';       
			        movwf  	tmr0;

retr16	        btfss   intcon,t0if;
		        goto 	retr16;
		        bcf		intcon,t0if;
		         	
			        return;


delay_160us	        call	config_timer1
					movlw	d'231';       
			        movwf  	tmr0;
	 	

retr19	        btfss   intcon,t0if;
		       	goto 	retr19;
		        bcf		intcon,t0if;
		         	
			        return;



delay_40us	      	call	config_timer1
					movlw	d'250';       
			        movwf  	tmr0;
	 	

retr20	        btfss   intcon,t0if;
		        goto 	retr20;
		        bcf		intcon,t0if;
		         	
			        return;


;configuración de tmr0 para 256

config_timer2	bsf 	status,rp0;
				movlw	b'10000111'
				movwf 	option_reg ^0x80;
            	bcf 	status,rp0	

				;bsf		intcon,gie
				bcf		intcon,t0if

				return

delay_10ms	        call	config_timer2
					movlw	d'61';       
			        movwf  	tmr0;
	 	

retr17	        btfss   intcon,t0if;
		        goto 	retr17;
		        bcf		intcon,t0if;
		         	
			        return;

	   
delay_5ms	        call	config_timer2
					movlw	d'159';       
			        movwf  	tmr0;
	 	
retr30	        btfss   intcon,t0if;
		        goto 	retr30;
		        bcf		intcon,t0if;
		         	
			        return;

delay_1ms	        call	config_timer2
					movlw	d'237';       
			        movwf  	tmr0;
	 	
retr31	        btfss   intcon,t0if;
		        goto 	retr31;
		        bcf		intcon,t0if;
				return;
			     ;=============================================
                 ;==  Subrutina de retardo de medio segundo  ==
                 ;=============================================
;


retardo2 
				movlw .38;
				movwf cuentaxx
ter
		      	call config_timer1;
				 movlw d'0';
				 movwf tmr0;
retrxxx
				btfss intcon,t0if;
				goto retrxxx;
				bcf intcon,t0if;
				decfsz cuentaxx,f;
				goto ter;
			        return;
;retardo de 2ms
retardo2ms
			call config_timer2
			movlw .216;
			movwf tmr0;
retrrrr
			btfss intcon,t0if;
			goto retrrrr;
			bcf intcon,t0if;
			return;


                     

delay_2s	clrf	cuenta;			limpia este registro
			clrf	cuenta_2;		limpia este registro

esp1		call	delay_10ms;		llama retardo
			incf	cuenta_2,f;		inicia cuenta
			movlw	d'200';			carga 250 a w
			subwf	cuenta_2,w;		compara cuenta_2
			btfss	status,z;		ya llego cuenta_2 a 250
			goto	esp1;			regresa a esp1
			clrf	cuenta_2;		limpia cuenta_2			
			incf	cuenta,f;		inicia segunda cuenta
			movlw	d'1';			carga 4 w
			subwf	cuenta,w;		compara cuenta
			btfss	status,z;		ya llego a 4?
			goto	esp1;			no, regresa a esp1
			clrf	cuenta;			luimpia cuenta

	return

delay_250ms	clrf	cuenta;			limpia este registro
			clrf	cuenta_2;		limpia este registro

esp10		call	delay_10ms;		llama retardo
			incf	cuenta_2,f;		inicia cuenta
			movlw	d'25';			carga 250 a w
			subwf	cuenta_2,w;		compara cuenta_2
			btfss	status,z;		ya llego cuenta_2 a 250
			goto	esp10;			regresa a esp1
			clrf	cuenta_2;		limpia cuenta_2			
			incf	cuenta,f;		inicia segunda cuenta
			movlw	d'1';			carga 4 w
			subwf	cuenta,w;		compara cuenta
			btfss	status,z;		ya llego a 4?
			goto	esp10;			no, regresa a esp1
			clrf	cuenta;			luimpia cuenta

	return

delay_1s	clrf	cuenta;			limpia este registro
			clrf	cuenta_2;		limpia este registro

esp100		call	delay_10ms;		llama retardo
			incf	cuenta_2,f;		inicia cuenta
			movlw	d'25';			carga 250 a w
			subwf	cuenta_2,w;		compara cuenta_2
			btfss	status,z;		ya llego cuenta_2 a 250
			goto	esp100;			regresa a esp1
			clrf	cuenta_2;		limpia cuenta_2			
			incf	cuenta,f;		inicia segunda cuenta
			movlw	d'4';			carga 4 w
			subwf	cuenta,w;		compara cuenta
			btfss	status,z;		ya llego a 4?
			goto	esp100;			no, regresa a esp1
			clrf	cuenta;			luimpia cuenta

	return
