;******************************************************************************
;
; Title:
;
;      div01.asm
;
;
;
; Function:
;
;   This program implements a digital frequency divider: the external
;   input clock is divided by a factor of 1 thousand (1e3), 1 million (1e6) and 10 million (1e7).
;   For example, if the input clock is 10 MHz then the output clocks will be 10 kHz, 10Hz and 1 Hz.
;
;
; Diagram:
;                                ---__---
;                              o|1      8|+++++  5V (Vdd)
;             input clock  ---->|2      7|---->  output clock 1Hz
;                              o|3      6|---->  output clock 10Hz
;            Ground (Vss)  =====|4      5|---->  output clock 10kHz
;                                --------
;                                ATtiny85
;
; Version:
;
;   Created: 06.07.2020 18:12:57
;   Author : sv
;
;******************************************************************************


;******************************************************************************
;* Definitionen
;******************************************************************************

.def temp       = r16       ; temp ist symbolischer Name für Register 16
                            ; wird als temporäre Variable verwendet
.def delay_0    = r17       ; delay_0 ist symbolischer Name für Register 17 
;.def delay_1    = r18       ; delay_1 ist symbolischer Name für Register 18
;.def delay_2    = r19       ; delay_2 ist symbolischer Name für Register 19

.def count_0    = r20       ; 10000 Stelle eines BDC-Zählers
.def count_1    = r21       ; 1000 Stelle
.def count_2    = r22       ; 100 Stelle
.def count_3    = r23       ; 10 Stelle
.def count_4    = r24       ; 1 Stelle
.def prep       = r25       ; Ausgaberegister

;******************************************************************************
;*  Programm Start nach Reset
;* 
;*  der Stackpointer wird initialisiert
;*  Register werden gesetzt
;******************************************************************************

RESET:                          ; hier startet der Code nach einem Reset
    ldi     temp,high(RAMEND)    ; $04 wird in Register 16 geladen 
    out     SPH,temp             ; SPH, oberes Byte des Stackpointers wird $04 
    ldi     temp,low(RAMEND)     ; $5F wird in Register 16 geladen 
    out     SPL,temp             ; SPL, unteres Byte des Stackpointers wird $5F
    ldi     temp,0b00000111
    out     DDRB,temp           ; setzt PB0 bis PB2 von PORTB als Ausgang
    clr     prep

    ldi     count_0, 10
    ldi     count_1, 10
    ldi     count_2, 10
    ldi     count_3, 10
    ldi     count_4, 10

;******************************************************************************
;*  Hauptprogramm
;* 
;*  eine endlose Schleife
;******************************************************************************

LOOP:
    out     PORTB,prep          ; PORTB wird gesetzt
    nop
    ldi     delay_0, 2
    rcall   SUB_DELAY
    dec     count_0             ; 10KHz Zähler
    brne    label1

    ldi     count_0, 10
    ldi     temp,0x01           ; PB0 toggeln
    eor     prep,temp
    dec     count_1
    rjmp    label2

label1:
    nop
    nop
    nop
    nop
    nop
label2:
    brne    label3              ; 1KHz Zähler

    ldi     count_1, 10
    ldi     temp,0x00           ; nix ändern
    eor     prep,temp
    dec     count_2
    rjmp    label4

label3:
    nop
    nop
    nop
    nop
    nop
label4:
    brne    label5              ; 100Hz Zähler

    ldi     count_2, 10
    ldi     temp,0x00           ; nix ändern
    eor     prep,temp
    dec     count_3
    rjmp    label6

label5:
    nop
    nop
    nop
    nop
    nop
label6:
    brne    label7              ; 10Hz Zähler

    ldi     count_3, 10
    ldi     temp,0x02           ; PB1 toggeln
    eor     prep,temp
    dec     count_4
    rjmp    label8

label7:
    nop
    nop
    nop
    nop
    nop
label8:
    brne    label9              ; 1Hz Zähler

    ldi     count_4, 10
    ldi     temp,0x04           ; PB2 toggeln
    eor     prep,temp
    rjmp    LOOP

label9:
    nop
    nop
    rjmp    LOOP
    
;*******************************************************************************
;* Unterprogramm SUB_DELAY
;* 
;* erzeugt eine Verzögerung von 3*n + 7 Takten
;* 
;*******************************************************************************

SUB_DELAY:
    dec     delay_0
    brne    SUB_DELAY
    ret
