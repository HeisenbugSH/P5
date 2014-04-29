#INCLUDE<P16F84A.INC>
        __CONFIG _XT_OSC & _CP_OFF & _PWRTE_ON & _WDT_OFF
        
        CBLOCK  0CH
        D1				;para conteo(CENTENA)
        D2				;para conteo(DECENA)
        D3				;para conteo(UNIDAD)
        CX				;para tiempo
        CY				;para tiempo
        CZ				;para tiempo
        ENDC
        
        ORG     00H
        GOTO    CONF
        GOTO    START
  
        ORG     04H
        GOTO    INTE
        
CONF:   BSF     STATUS,RP0
        MOVLW   00H
        MOVWF   TRISA
        MOVLW   01H
        MOVWF   TRISB
        BCF     STATUS,RP0
        RETURN

START:	CLRF	PORTB
		CLRF	PORTA
		RETURN
		CALL	MUX
		GOTO	$-1

						;TIEMPOS
TIME1:  MOVLW   D'49'
        MOVWF   CX
        MOVLW   D'33'
        MOVWF   CY
        NOP
        DECFSZ  CY,1
        GOTO    $-2
        DECFSZ  CX,1
        GOTO    $-6
        RETURN
        
TIME2:  MOVLW   06H
        MOVWF   CZ
        NOP
        DECFSZ  CZ,1
        GOTO    $-2
        RETURN

						;MULTIPLEXADO
MUX:    CLRF    PORTB
        CLRF    PORTA
        
        MOVF    D1,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,0
        CALL    TIME1
        CALL    TIME2
        
        BCF     PORTA,1
        MOVF    D2,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,1
        CALL    TIME1
        CALL    TIME2
        
        BCF     PORTA,1
        MOVF    D3,W
        CALL    TABLA
        MOVWF   PORTB
        BSF     PORTA,2
        CALL    TIME1
        CALL    TIME2
        RETURN

							;INTERRUPCIÓN
INTE:   BTFSS   INTCON,INTF
        RETFIE
        INCF    D3,1
        MOVF    D3,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        
        CLRF    D3
        INCF    D2,1
        MOVF    D2,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        
        CLRF    D2
        INCF    D1,1
        MOVF    D1,W
        SUBLW   09H
        BTFSC   STATUS,C
        GOTO    FIN
        
        CLRF    D1
        
FIN:    BCF INTCON,INTF
        RETFIE

TABLA:	ADDWF	PCL,1
		DT	3FH,06H,5BH,4FH,66H,2DH,7DH,47H,7FH,67H
		END
