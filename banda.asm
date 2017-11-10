; **** Encabezado ****
list p=16F84a
#include P16F84a.inc
__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _RC_OSC

;**** Definicion de variables ****
Contador1 equ 0x0C ; Seleccionamos posicionoria RAM (GPR) para guardar
Contador2 equ 0x0D ; Registro utilizado en demora.-
Led equ 0 ; Definimos Led como el bit cero de un registro,caso PORTB.-
Pulsador1 equ 0 ; Definimos Pulsador como el bit 0, este será para PORTA S1
Pulsador2 equ 1 ; Definimos Pulsador como el bit 1, este será para PORTA S2
Pulsador3 equ 2 ; Definimos Pulsador como el bit 2, este será para PORTA Start
Pulsador4 equ 3 ; Definimos Pulsador como el bit 3, este será para PORTA Stop
Pulsador5 equ 4 ; Definimos Pulsador como el bit 4, este será para PORTA Emergencia

;**** Configuracion de puertos ***
Reset org 0x00 ; Aqui comienza el micro.-
goto Start ; Salto a inicio de mi programa.-
org 0x05 ; Origen del codigo de programa.-
Start  btfsc PORTA,Pulsador3 ; Preguntamos si esta en 0 logico.-
	   goto Inicio 
	   goto Start
Inicio bsf STATUS,RP0 ; Pasamos de Banco 0 a Banco 1.-
movlw b'11111' ; Muevo 11111 a W.-
movwf TRISA ; Cargo en TRISA.-
movlw b'00010000' 
movwf TRISB
bcf STATUS,RP0 ; Paso del Banco 1 al Banco 0
bcf PORTB,Led ; Comienza apagado.-

;**** Secuencia de Led ****
Bucle1 btfsc PORTA,Pulsador1 ; Preguntamos si esta en 0 logico.-
	   goto Secuencia1 
	   goto Bucle1
   	;bcf PORTB,Led ; Apagamos Led
		
Secuencia1  btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
			btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
            movlw b'00100001' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			movlw b'00100011' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			movlw b'00100111' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			goto Bucle2

; *********aqui puede copiar y pegar la secuencia de Led que quiera programar
;********* con el mismo formato del codigo de las lineas anteriores *****

goto Bucle1 ; permanecemos en un bucle infinito

Apagar1 bcf PORTB,Led ;Apagamos Led.-
goto Bucle2 ; Regresamos al bucle

Bucle2 btfsc PORTA,Pulsador2 ; Preguntamos si esta en 0 logico.-
	   goto Secuencia2 
   	   goto Bucle2
   	;bcf PORTB,Led ; Apagamos Led
		
Secuencia2  btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
            movlw b'00100111' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
			btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			movlw b'00100011' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			movlw b'00100001' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			movlw b'00100000' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
			btfsc PORTA,Pulsador4 ; Preguntamos si esta en 0 logico.-
			call  stop
            btfsc PORTA,Pulsador5 ; Preguntamos si esta en 0 logico.-
			call  emergencia
			;return
			goto Bucle1
			

; *********aqui puede copiar y pegar la secuencia de Led que quiera programar
;********* con el mismo formato del codigo de las lineas anteriores *****

goto Bucle2 ; permanecemos en un bucle infinito

Apagar2 bcf PORTB,Led ;Apagamos Led.-
goto Bucle1 ; Regresamos al bucle

;**** Demora ****
Demora_150ms
movlw 0xFF ; 02
movwf Contador1 ; Iniciamos contador1.-
Repeticion1
movlw 0xC3 ; 01
movwf Contador2 ; Iniciamos contador2
Repeticion2
decfsz Contador2,1 ; Decrementa Contador2 y si es 0 sale.- 
goto Repeticion2 ; Si no es 0 repetimos ciclo.-
decfsz Contador1,1 ; Decrementa Contador1.-
goto Repeticion1 ; Si no es cero repetimos ciclo.-
return ; Regresa de la subrutina.-
;******fin demora******
;****Stop*****
stop btfsc PORTA,Pulsador3 ; Preguntamos si esta en 0 logico.-
	return
	goto stop
;***stop****


;****Emergencia*****
emergencia 
            movlw b'00001000' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
            movlw b'00000000' 
			movwf PORTB
			call Demora_150ms ; Mantenemos prendido 150 milisegundos
        	goto emergencia
;***fin emergencia****

end