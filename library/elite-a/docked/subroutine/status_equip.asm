\ ******************************************************************************
\
\       Name: status_equip
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

.status_equip

 STX CNT                \ AJD
 STA XX4
 JSR TT27
 LDX QQ11
 CPX #8
 BEQ status_keep
 LDA #21
 STA XC

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case, with the next
                        \ letter in capitals

 LDA #1
 STA QQ25

 JSR sell_yn            \ Call sell_yn to print a "SELL (Y/N)?" prompt and get a
                        \ number from the keyboard

 BEQ status_no
 BCS status_no
 LDA XX4
 CMP #107
 BCS status_over
 ADC #7

.status_over

 SBC #104
 JSR prx-3
 LSR A
 TAY
 TXA
 ROR A
 TAX
 JSR MCASH
 INC new_hold
 LDX CNT
 LDA #0
 STA LASER,X

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod

ENDIF

.status_no

 LDX #1

.status_keep

 STX XC
 LDA #10
 JMP TT27

