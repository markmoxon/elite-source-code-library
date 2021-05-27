\ ******************************************************************************
\
\       Name: TT27
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token
\  Deep dive: Printing text tokens
\
\ ------------------------------------------------------------------------------
\
\ Print a text token (i.e. a character, control code, two-letter token or
\ recursive token). See variable QQ18 for a discussion of the token system
\ used in Elite.
\
\ Arguments:
\
\   A                   The text token to be printed
\
IF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\ Other entry points:
\
\   vdu_80              AJD
\
ENDIF
IF _ELITE_A_FLIGHT
\   vdu_00              AJD
\
ENDIF
\ ******************************************************************************

.TT27

 TAX                    \ Copy the token number from A to X. We can then keep
                        \ decrementing X and testing it against zero, while
                        \ keeping the original token number intact in A; this
                        \ effectively implements a switch statement on the
                        \ value of the token

 BEQ csh                \ If token = 0, this is control code 0 (current amount
                        \ of cash and newline), so jump to csh

 BMI TT43               \ If token > 127, this is either a two-letter token
                        \ (128-159) or a recursive token (160-255), so jump
                        \ to TT43 to process tokens

 DEX                    \ If token = 1, this is control code 1 (current galaxy
 BEQ tal                \ number), so jump to tal

 DEX                    \ If token = 2, this is control code 2 (current system
 BEQ ypl                \ name), so jump to ypl

 DEX                    \ If token > 3, skip the following instruction
 BNE P%+5

 JMP cpl                \ This token is control code 3 (selected system name)
                        \ so jump to cpl

 DEX                    \ If token = 4, this is control code 4 (commander
 BEQ cmn                \ name), so jump to cmm

 DEX                    \ If token = 5, this is control code 5 (fuel, newline,
 BEQ fwl                \ cash, newline), so jump to fwl

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA)

 DEX                    \ If token > 6, skip the following 3 instructions
 BNE P%+7

 LDA #%10000000         \ This token is control code 6 (switch to Sentence
 STA QQ17               \ Case), so set bit 7 of QQ17 to switch to Sentence Case
 RTS                    \ and return from the subroutine as we are done

 DEX                    \ If token > 8, skip the following 2 instructions
 DEX
 BNE P%+5

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 DEX                    \ AJD
 BEQ vdu_80

 DEX
 DEX
 BNE l_31d2

 EQUB &2C               \ AJD

.vdu_80

 LDX #&80

ELIF _ELITE_A_FLIGHT

 DEX                    \ AJD
 BNE l_33b9

.vdu_80

 LDX #&80
 EQUB &2C

.vdu_00

 LDX #&00

ENDIF

 STX QQ17               \ This token is control code 8 (switch to ALL CAPS), so
 RTS                    \ set QQ17 to 0 to switch to ALL CAPS and return from
                        \ the subroutine as we are done

IF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

.l_31d2

ENDIF

IF _ELITE_A_FLIGHT

.l_33b9

 DEX                    \ AJD
 DEX
 BEQ vdu_00

ENDIF

 DEX                    \ If token = 9, this is control code 9 (tab to column
 BEQ crlf               \ 21 and print a colon), so jump to crlf

 CMP #96                \ By this point, token is either 7, or in 10-127.
 BCS ex                 \ Check token number in A and if token >= 96, then the
                        \ token is in 96-127, which is a recursive token, so
                        \ jump to ex, which prints recursive tokens in this
                        \ range (i.e. where the recursive token number is
                        \ correct and doesn't need correcting)

 CMP #14                \ If token < 14, skip the following 2 instructions
 BCC P%+6

 CMP #32                \ If token < 32, then this means token is in 14-31, so
 BCC qw                 \ this is a recursive token that needs 114 adding to it
                        \ to get the recursive token number, so jump to qw
                        \ which will do this

                        \ By this point, token is either 7 (beep) or in 10-13
                        \ (line feeds and carriage returns), or in 32-95
                        \ (ASCII letters, numbers and punctuation)

 LDX QQ17               \ Fetch QQ17, which controls letter case, into X

 BEQ TT74               \ If QQ17 = 0, then ALL CAPS is set, so jump to TT27
                        \ to print this character as is (i.e. as a capital)

 BMI TT41               \ If QQ17 has bit 7 set, then we are using Sentence
                        \ Case, so jump to TT41, which will print the
                        \ character in upper or lower case, depending on
                        \ whether this is the first letter in a word

 BIT QQ17               \ If we get here, QQ17 is not 0 and bit 7 is clear, so
 BVS TT46               \ either it is bit 6 that is set, or some other flag in
                        \ QQ17 is set (bits 0-5). So check whether bit 6 is set.
                        \ If it is, then ALL CAPS has been set (as bit 7 is
                        \ clear) but bit 6 is still indicating that the next
                        \ character should be printed in lower case, so we need
                        \ to fix this. We do this with a jump to TT46, which
                        \ will print this character in upper case and clear bit
                        \ 6, so the flags are consistent with ALL CAPS going
                        \ forward

                        \ If we get here, some other flag is set in QQ17 (one
                        \ of bits 0-5 is set), which shouldn't happen in this
                        \ version of Elite. If this were the case, then we
                        \ would fall through into TT42 to print in lower case,
                        \ which is how printing all words in lower case could
                        \ be supported (by setting QQ17 to 1, say)

