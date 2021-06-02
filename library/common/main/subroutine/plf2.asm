\ ******************************************************************************
\
\       Name: plf2
\       Type: Subroutine
\   Category: Text
\    Summary: Print text followed by a newline and indent of 6 characters
\
\ ------------------------------------------------------------------------------
\
\ Print a text token followed by a newline, and indent the next line to text
\ column 6.
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.plf2

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA)

 JSR plf                \ Print the text token in A followed by a newline

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STX &93                \ AJD
 STA &96
 JSR TT27
 LDX &87
 CPX #&08
 BEQ status_keep
 LDA #&15
 STA XC
 JSR vdu_80
 LDA #&01
 STA &03AB
 JSR sell_yn
 BEQ status_no
 BCS status_no
 LDA &96
 CMP #&6B
 BCS status_over
 ADC #&07

.status_over

 SBC #&68
 JSR prx-3
 LSR A
 TAY
 TXA
 ROR A
 TAX
 JSR MCASH
 INC new_hold
 LDX &93
 LDA #&00
 STA LASER,X

ENDIF

IF _ELITE_A_6502SP_PARA

 JSR update_pod

ENDIF

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

.status_no

 LDX #&01

.status_keep

 STX XC
 LDA #&0A
 JMP TT27

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Tube

 LDX #6                 \ Move the text cursor to column 6
 STX XC

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 LDA #6                 \ Move the text cursor to column 6
 STA XC

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA #6                 \ Move the text cursor to column 6 and return from the
 JMP DOXC               \ subroutine using a tail call

ENDIF

