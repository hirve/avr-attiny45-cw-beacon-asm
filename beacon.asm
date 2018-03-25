; Controller ATtiny45 at 8 MHz internal RC oscillator
; Broun-out at 1.8V, Fuse CKDIV8 is ON

.include "tn45def.inc"


.equ BASE_PERIOD = 8
.equ CHAR_TABLE_BEGIN = 20


; R3:R2:R1:R0 - Timer counter

.def R5_ELEMENT_TIMEOUT = R5

.def R6_SYMBOL_TX_ON =    R6
.def R7_SYMBOL =          R7

.def R8_SYMBOL_BYTE =     R8
.def R9_TX_ELEMENT =      R9    ; 0:END, 1:DOT, 2:DASH, 3:OFF, 4:SPACE, 5:LONG
.def R10_ELEMENT_TX_ON =  R10


; ------------------
; Int table

.cseg

.org 0x000        RJMP Reset      ; Reset
.org 0x002        RETI            ; IRQ0
.org 0x004        RETI            ; PCINT0
.org 0x006        RJMP Timer      ; Timer1 Compare A
.org 0x008        RETI            ; Timer1 Overflow
.org 0x00A        RETI            ; Timer0 Overflow
.org 0x00C        RETI            ; EEPROM Ready
.org 0x00E        RETI            ; Analog Comparator
.org 0x010        RETI            ; ADC Conversion
.org 0x012        RETI            ; Timer1 Compare B
.org 0x014        RETI            ; Timer0 Compare A
.org 0x016        RETI            ; Timer0 Compare B
.org 0x018        RETI            ; Watchdog Time-out
.org 0x01A        RETI            ; USI Start
.org 0x01C        RETI            ; USI Overflow


; ------------------
; Data

Data:

    ; Reserved for special symbols

    .db 0,0,0,0,0,0,0,0        ;20
    .db 0,0,0,0,0,0,0,0        ;21
    .db 0,0,0,0,0,0,0,0        ;22
    .db 5,5,5,0,0,0,0,0        ;23 LONG3
    .db 5,5,5,5,0,0,0,0        ;24 LONG4
    .db 5,5,5,5,5,0,0,0        ;25 LONG5
    .db 5,5,5,5,5,5,0,0        ;26 LONG6
    .db 5,5,5,5,5,5,5,0        ;27 LONG7
    .db 0,0,0,0,0,0,0,0        ;28
    .db 5,5,4,4,5,5,0,0        ;29 LONG-SPACE-LONG
    .db 0,0,0,0,0,0,0,0        ;30
    .db 0,0,0,0,0,0,0,0        ;31

    ; Signs

    .db 4,0,0,0,0,0,0,0        ;32 [SPACE]
    .db 2,2,1,1,2,2,0,0        ;33 !
    .db 1,2,1,1,2,1,0,0        ;34 "
    .db 5,5,5,5,5,0,0,0        ;35 #[LONG]
    .db 0,0,0,0,0,0,0,0        ;36 
    .db 0,0,0,0,0,0,0,0        ;37 
    .db 0,0,0,0,0,0,0,0        ;38 
    .db 0,0,0,0,0,0,0,0        ;39 
    .db 2,1,2,2,1,2,0,0        ;40 (
    .db 2,1,2,2,1,2,0,0        ;41 )
    .db 0,0,0,0,0,0,0,0        ;42 
    .db 0,0,0,0,0,0,0,0        ;43 
    .db 1,2,1,2,1,2,0,0        ;44 ,
    .db 2,1,1,1,1,2,0,0        ;45 -
    .db 1,1,1,1,1,1,0,0        ;46 .
    .db 2,1,1,2,1,0,0,0        ;47 /

    ; Digits

    .db 2,2,2,2,2,0,0,0        ;48 0
    .db 1,2,2,2,2,0,0,0        ;49 1
    .db 1,1,2,2,2,0,0,0        ;50 2
    .db 1,1,1,2,2,0,0,0        ;51 3
    .db 1,1,1,1,2,0,0,0        ;52 4
    .db 1,1,1,1,1,0,0,0        ;53 5
    .db 2,1,1,1,1,0,0,0        ;54 6
    .db 2,2,1,1,1,0,0,0        ;55 7
    .db 2,2,2,1,1,0,0,0        ;56 8
    .db 2,2,2,2,1,0,0,0        ;57 9

    ; Signs

    .db 2,2,2,1,1,1,0,0        ;58 :
    .db 2,1,2,1,2,1,0,0        ;59 ;
    .db 0,0,0,0,0,0,0,0        ;60 
    .db 0,0,0,0,0,0,0,0        ;61
    .db 0,0,0,0,0,0,0,0        ;62
    .db 1,1,2,2,1,1,0,0        ;63 ?
    .db 1,2,2,1,2,1,0,0        ;64 @

    ; Letters

    .db 1,2,0,0,0,0,0,0        ;65 A
    .db 2,1,1,1,0,0,0,0        ;66 B
    .db 2,1,2,1,0,0,0,0        ;67 C
    .db 2,1,1,0,0,0,0,0        ;68 D
    .db 1,0,0,0,0,0,0,0        ;69 E
    .db 1,1,2,1,0,0,0,0        ;70 F
    .db 2,2,1,0,0,0,0,0        ;71 G
    .db 1,1,1,1,0,0,0,0        ;72 H
    .db 1,1,0,0,0,0,0,0        ;73 I
    .db 1,2,2,2,0,0,0,0        ;74 J
    .db 2,1,2,0,0,0,0,0        ;75 K
    .db 1,2,1,1,0,0,0,0        ;76 L
    .db 2,2,0,0,0,0,0,0        ;77 M
    .db 2,1,0,0,0,0,0,0        ;78 N
    .db 2,2,2,0,0,0,0,0        ;79 O
    .db 1,2,2,1,0,0,0,0        ;80 P
    .db 2,2,1,2,0,0,0,0        ;81 Q
    .db 1,2,1,0,0,0,0,0        ;82 R
    .db 1,1,1,0,0,0,0,0        ;83 S
    .db 2,0,0,0,0,0,0,0        ;84 T
    .db 1,1,2,0,0,0,0,0        ;85 U
    .db 1,1,1,2,0,0,0,0        ;86 V
    .db 1,2,2,0,0,0,0,0        ;87 W
    .db 2,1,1,2,0,0,0,0        ;88 X
    .db 2,1,2,2,0,0,0,0        ;89 Y
    .db 2,2,1,1,0,0,0,0        ;90 Z


Text:

    .db "VVV DE QRPP BCN TEST"
    .db "   "
    .db 0

; ------------------
; Init

Reset:

; Stack

    LDI  R16, Low(RAMEND)
    OUT  SPL, R16

    LDI  R16, High(RAMEND)
    OUT  SPH, R16

; Timer 0 on

    LDI  R16, 0b00000011
    OUT  TCCR0B, R16

; Timer Int

    LDI  R16, 0b00000010
    OUT  TIMSK, R16

; Port B

    LDI R16, 0b00001000
    OUT DDRB, R16

    LDI R16, 0b00000000
    OUT PORTB, R16

; Int ON

    SEI



; ------------------
Main:

    ; Background tasks here

    TX_Letter:

        LDI  ZL, Low(Text*2)
        LDI  ZH, High(Text*2)

    Main_Loop:

        MOV  R16, R6_SYMBOL_TX_ON
        CPI  R16, 0
        BRNE Main_Loop

            LPM  R16, Z
            CPI  R16, 0
            BREQ Main

                RCALL Symbol_TX

                LDI  R16, 1
                CLR  R17
                ADD  ZL, R16
                ADC  ZH, R17

                RJMP Main_Loop


; ------------------
; Realtime

Timer:

        PUSH ZL
        PUSH ZH
        PUSH R19
        PUSH R18
        PUSH R17
        PUSH R16
        IN   R16, 0x3F
        PUSH R16

        ; Realtime tasks here

            RCALL Symbol_Pause
            RCALL Symbol_Element


    Frame_256_CALL:

        MOV  R16, R0
        CPI  R16, 0
        BRNE Frame_256_CALL_END

        ; Tasks on each 256th int here

    Frame_256_CALL_END:

    Cnt_0123:

        LDI  R16, 1
        LDI  R17, 0
        ADD  R0, R16
        ADC  R1, R17
        ADC  R2, R17
        ADC  R3, R17

    Cnt_0123_END:

    Timer_RET:

        POP  R16
        OUT  0x3F, R16
        POP  R16
        POP  R17
        POP  R18
        POP  R19
        POP  ZH
        POP  ZL

        RETI



; ------------------
; Tasks

Symbol_Element:

        MOV  R16, R10_ELEMENT_TX_ON
        CPI  R16, 1
        BRNE Symbol_Element_END

    Symbol_Element_TIMEOUT:

        MOV  R16, R5_ELEMENT_TIMEOUT
        CPI  R16, 0
        BRNE Symbol_Element_END

    Symbol_Element_Get_Byte:

        LDI  ZL, Low(Data*2)
        LDI  ZH, High(Data*2)

        MOV  R18, R7_SYMBOL
        LDI  R19, CHAR_TABLE_BEGIN
        SBC  R18, R19
        CLR  R19

        CLC
        ROL  R18
        ROL  R19
        ROL  R18
        ROL  R19
        ROL  R18
        ROL  R19

        ADD  ZL, R18
        ADC  ZH, R19

        MOV  R18, R8_SYMBOL_BYTE
        CLR  R19
        ADD  ZL, R18
        ADC  ZH, R19

        LPM  R16, Z
        MOV  R9_TX_ELEMENT, R16

    Symbol_Element_Last:

        MOV  R16, R9_TX_ELEMENT
        CPI  R16, 0
        BRNE Symbol_Element_Last_END

            LDI  R16, BASE_PERIOD * 3
            MOV  R5_ELEMENT_TIMEOUT, R16

            RJMP Symbol_Element_END

    Symbol_Element_Last_END:

    Symbol_Element_Space:

        MOV  R16, R9_TX_ELEMENT
        CPI  R16, 4
        BRNE Symbol_Element_Space_END

            LDI  R16, BASE_PERIOD * 1
            MOV  R5_ELEMENT_TIMEOUT, R16

            RJMP Symbol_Element_END

    Symbol_Element_Space_END:

    Symbol_Element_Dot:

        MOV  R16, R9_TX_ELEMENT
        CPI  R16, 1
        BRNE Symbol_Element_Dot_END

            LDI  R16, BASE_PERIOD * 1
            MOV  R5_ELEMENT_TIMEOUT, R16
            RCALL  TX_ON

            RJMP Symbol_Element_END

    Symbol_Element_Dot_END:

    Symbol_Element_Dash:

        MOV  R16, R9_TX_ELEMENT
        CPI  R16, 2
        BRNE Symbol_Element_Dash_END

            LDI  R16, BASE_PERIOD * 3
            MOV  R5_ELEMENT_TIMEOUT, R16
            RCALL  TX_ON

            RJMP Symbol_Element_END

    Symbol_Element_Dash_END:

    Symbol_Element_Long:

        MOV  R16, R9_TX_ELEMENT
        CPI  R16, 5
        BRNE Symbol_Element_Long_END

            LDI  R16, BASE_PERIOD * 4
            MOV  R5_ELEMENT_TIMEOUT, R16
            RCALL  TX_ON

            RJMP Symbol_Element_END

    Symbol_Element_Long_END:

    Symbol_Element_END:

        RET



Symbol_Pause:

        MOV  R16, R5_ELEMENT_TIMEOUT
        CPI  R16, 0
        BREQ Symbol_Pause_END

            DEC  R5_ELEMENT_TIMEOUT
            MOV  R16, R5_ELEMENT_TIMEOUT
            CPI  R16, 0
            BRNE Symbol_Pause_END

    Symbol_Pause_After_Dot:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 1
                BRNE Symbol_Pause_After_Dot_END

                    RCALL TX_OFF

                    CLR  R10_ELEMENT_TX_ON
                    LDI  R16, BASE_PERIOD * 1
                    MOV  R5_ELEMENT_TIMEOUT, R16
                    LDI  R16, 3
                    MOV  R9_TX_ELEMENT, R16

                    RJMP Symbol_Pause_END

    Symbol_Pause_After_Dot_END:

    Symbol_Pause_After_Dash:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 2
                BRNE Symbol_Pause_After_Dash_END

                    RCALL TX_OFF

                    CLR  R10_ELEMENT_TX_ON
                    LDI  R16, BASE_PERIOD * 1
                    MOV  R5_ELEMENT_TIMEOUT, R16
                    LDI  R16, 3
                    MOV  R9_TX_ELEMENT, R16

                    RJMP Symbol_Pause_END

    Symbol_Pause_After_Dash_END:

    Symbol_Pause_After_Long:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 5
                BRNE Symbol_Pause_After_Long_END

                    RCALL TX_OFF

                    CLR  R10_ELEMENT_TX_ON
                    LDI  R16, 0
                    MOV  R5_ELEMENT_TIMEOUT, R16
                    LDI  R16, 3
                    MOV  R9_TX_ELEMENT, R16

    Symbol_Pause_After_Long_END:

    Symbol_Pause_After_Space:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 4
                BRNE Symbol_Pause_After_Space_END

                    CLR  R10_ELEMENT_TX_ON
                    LDI  R16, BASE_PERIOD * 1
                    MOV  R5_ELEMENT_TIMEOUT, R16
                    LDI  R16, 3
                    MOV  R9_TX_ELEMENT, R16

                    RJMP Symbol_Pause_END

    Symbol_Pause_After_Space_END:

    Symbol_Pause_After_Pause:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 3
                BRNE Symbol_Pause_After_Pause_END

                    INC  R8_SYMBOL_BYTE
                    LDI  R16, 1
                    MOV  R10_ELEMENT_TX_ON, R16

                    RJMP Symbol_Pause_END

    Symbol_Pause_After_Pause_END:

    Symbol_Pause_After_Last:

                MOV  R16, R9_TX_ELEMENT
                CPI  R16, 0
                BRNE Symbol_Pause_After_Last_END

                    CLR  R10_ELEMENT_TX_ON
                    CLR  R6_SYMBOL_TX_ON

                    RJMP Symbol_Pause_END

    Symbol_Pause_After_Last_END:

    Symbol_Pause_END:

        RET

; ------------------
; Functions

Symbol_TX:

        MOV  R17, R6_SYMBOL_TX_ON
        CPI  R17, 0
        BRNE Symbol_TX_END

            MOV  R7_SYMBOL, R16
            CLR  R5_ELEMENT_TIMEOUT
            CLR  R8_SYMBOL_BYTE
            LDI  R16, 1
            MOV  R6_SYMBOL_TX_ON, R16
            MOV  R10_ELEMENT_TX_ON, R16

Symbol_TX_END:

        RET

TX_ON:

        LDI  R16, 0b00001000
        OUT  PORTB, R16
        RET

TX_OFF:

        LDI  R16, 0b00000000
        OUT  PORTB, R16
        RET

