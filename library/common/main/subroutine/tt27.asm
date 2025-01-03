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
\ recursive token).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to be printed
\
IF _ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   vdu_80              Switch standard tokens to Sentence Case
\
ENDIF
IF _ELITE_A_FLIGHT
\   vdu_00              Switch standard tokens to ALL CAPS
\
ENDIF
\ ******************************************************************************

IF _NES_VERSION

.TT27S

 JMP PrintCtrlCode_b0   \ We jump here from below if the character to print is
                        \ in the range 0 to 9, so jump to PrintCtrlCode to print
                        \ the control code and return from the subroutine using
                        \ a tail call

ENDIF

.TT27

IF _NES_VERSION

 PHA                    \ Store A on the stack, so we can retrieve it below

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 PLA                    \ Restore A from the stack

ENDIF

 TAX                    \ Copy the token number from A to X. We can then keep
                        \ decrementing X and testing it against zero, while
                        \ keeping the original token number intact in A; this
                        \ effectively implements a switch statement on the
                        \ value of the token

IF NOT(_NES_VERSION)

 BEQ csh                \ If token = 0, this is control code 0 (current amount
                        \ of cash and newline), so jump to csh to print the
                        \ amount of cash and return from the subroutine using
                        \ a tail call

ENDIF

 BMI TT43               \ If token > 127, this is either a two-letter token
                        \ (128-159) or a recursive token (160-255), so jump
                        \ to TT43 to process tokens

IF NOT(_NES_VERSION)

 DEX                    \ If token = 1, this is control code 1 (current galaxy
 BEQ tal                \ number), so jump to tal to print the galaxy number and
                        \ return from the subroutine using a tail call

 DEX                    \ If token = 2, this is control code 2 (current system
 BEQ ypl                \ name), so jump to ypl to print the current system name
                        \ and return from the subroutine using a tail call

 DEX                    \ If token > 3, skip the following instruction
 BNE P%+5

 JMP cpl                \ This token is control code 3 (selected system name)
                        \ so jump to cpl to print the selected system name
                        \ and return from the subroutine using a tail call

 DEX                    \ If token = 4, this is control code 4 (commander
 BEQ cmn                \ name), so jump to cmn to print the commander name
                        \ and return from the subroutine using a tail call

 DEX                    \ If token = 5, this is control code 5 (fuel, newline,
 BEQ fwl                \ cash, newline), so jump to fwl to print the fuel level
                        \ and return from the subroutine using a tail call

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _NES_VERSION)

 DEX                    \ If token > 6, skip the following three instructions
 BNE P%+7

 LDA #%10000000         \ This token is control code 6 (switch to Sentence
 STA QQ17               \ Case), so set bit 7 of QQ17 to switch to Sentence Case
 RTS                    \ and return from the subroutine as we are done

 DEX                    \ If token > 8, skip the following two instructions
 DEX
 BNE P%+5

 STX QQ17               \ This token is control code 8 (switch to ALL CAPS), so
 RTS                    \ set QQ17 to 0 to switch to ALL CAPS and return from
                        \ the subroutine as we are done

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 DEX                    \ If token = 6, this is control code 6 (switch to
 BEQ vdu_80             \ Sentence Case), so jump to vdu_80 to do just that

 DEX                    \ If token <> 8, jump to l_31d2 to skip the following
 DEX                    \ four instructions
 BNE l_31d2

                        \ If we get here, then token = 8 (switch to ALL CAPS)
                        \ and X = 0, which we now use to set the value of QQ17
                        \ below

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &80, or BIT &80A2, which does nothing apart
                        \ from affect the flags

.vdu_80

 LDX #%10000000         \ Set bit 7 of X, so when we set QQ17 below, we switch
                        \ standard tokens to Sentence Case

 STX QQ17               \ This token is control code 8 (switch to ALL CAPS), so
 RTS                    \ set QQ17 to 0 to switch to ALL CAPS and return from
                        \ the subroutine as we are done

.l_31d2

ELIF _ELITE_A_FLIGHT

 DEX                    \ If token > 6, jump to l_33b9 to skip the following
 BNE l_33b9             \ five instructions

.vdu_80

 LDX #%10000000         \ Set bit 7 of X, so when we set QQ17 below, we switch
                        \ standard tokens to Sentence Case

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A2 &00, or BIT &00A2, which does nothing apart
                        \ from affect the flags

.vdu_00

 LDX #0                 \ Clear bit 7 of X, so when we set QQ17 below, we switch
                        \ standard tokens to ALL CAPS

 STX QQ17               \ This token is control code 8 (switch to ALL CAPS), so
 RTS                    \ set QQ17 to 0 to switch to ALL CAPS and return from
                        \ the subroutine as we are done

.l_33b9

 DEX                    \ If token = 8, this is control code 8 (switch to ALL
 DEX                    \ CAPS), so jump up to vdu_00 to set QQ17 to 0 to switch
 BEQ vdu_00             \ to ALL CAPS and return from the subroutine

ENDIF

IF NOT(_NES_VERSION)

 DEX                    \ If token = 9, this is control code 9 (tab to column
 BEQ crlf               \ 21 and print a colon), so jump to crlf

ELIF _NES_VERSION

 CMP #10                \ If token < 10 then this is a control code, so jump to
 BCC TT27S              \ PrintCtrlCode via TT27S to print it

ENDIF

 CMP #96                \ By this point, token is either 7, or in 10-127.
 BCS ex                 \ Check token number in A and if token >= 96, then the
                        \ token is in 96-127, which is a recursive token, so
                        \ jump to ex, which prints recursive tokens in this
                        \ range (i.e. where the recursive token number is
                        \ correct and doesn't need correcting)

 CMP #14                \ If token < 14, skip the following two instructions
 BCC P%+6

 CMP #32                \ If token < 32, then this means token is in 14-31, so
 BCC qw                 \ this is a recursive token that needs 114 adding to it
                        \ to get the recursive token number, so jump to qw
                        \ which will do this

                        \ By this point, token is either 7 (beep) or in 10-13
                        \ (line feeds and carriage returns), or in 32-95
                        \ (ASCII letters, numbers and punctuation)

 LDX QQ17               \ Fetch QQ17, which controls letter case, into X

IF NOT(_NES_VERSION)

 BEQ TT74               \ If QQ17 = 0, then ALL CAPS is set, so jump to TT74
                        \ to print this character as is (i.e. as a capital)

ELIF _NES_VERSION

 BEQ TT44               \ If QQ17 = 0, then ALL CAPS is set, so jump to TT44
                        \ to print this character as is (i.e. as a capital)

ENDIF

 BMI TT41               \ If QQ17 has bit 7 set, then we are using Sentence
                        \ Case, so jump to TT41, which will print the
                        \ character in upper or lower case, depending on
                        \ whether this is the first letter in a word

IF NOT(_NES_VERSION)

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

ELIF _NES_VERSION

 BIT QQ17               \ If we get here, QQ17 is not 0 and bit 7 is clear, so
 BVS TT44               \ either it is bit 6 that is set, or some other flag in
                        \ QQ17 is set (bits 0-5). So check whether bit 6 is set.
                        \ If it is, then ALL CAPS has been set (as bit 7 is
                        \ clear), so jump to TT26 via TT44 to print the
                        \ character in upper case

ENDIF

                        \ If we get here, some other flag is set in QQ17 (one
                        \ of bits 0-5 is set), which shouldn't happen in this
                        \ version of Elite. If this were the case, then we
                        \ would fall through into TT42 to print in lower case,
                        \ which is how printing all words in lower case could
                        \ be supported (by setting QQ17 to 1, say)

