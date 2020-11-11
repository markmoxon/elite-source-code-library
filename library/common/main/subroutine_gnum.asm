\ ******************************************************************************
\
\       Name: gnum
\       Type: Subroutine
\   Category: Market
\    Summary: Get a number from the keyboard
\
\ ------------------------------------------------------------------------------
\
\ Get a number from the keyboard, up to the maximum number in QQ25. Pressing a
\ key with an ASCII code less than ASCII "0" will return a 0 in A (so that
\ includes pressing Space or Return), while pressing a key with an ASCII code
\ greater than ASCII "9" will jump to the Inventory screen (so that includes
\ all letters and most punctuation).
\
\ Arguments:
\
\   QQ25                The maximum number allowed
\
\ Returns:
\
\   A                   The number entered
\
\   R                   Also contains the number entered
\
\   C flag              Set if the number is too large (> QQ25), clear otherwise
\
\ ******************************************************************************

.gnum

IF _6502SP_VERSION

 LDA #MAGENTA
 JSR DOCOL

ENDIF

 LDX #0                 \ We will build the number entered in R, so initialise
 STX R                  \ it with 0

 LDX #12                \ We will check for up to 12 key presses, so set a
 STX T1                 \ counter in T1

.TT223

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

IF _6502SP_VERSION

 LDX R
 BNE NWDAV2
 CMP #'y'
 BEQ NWDAV1
 CMP #'n'
 BEQ NWDAV3

.NWDAV2

ENDIF

 STA Q                  \ Store the key pressed in Q

 SEC                    \ Subtract ASCII '0' from the key pressed, to leave the
 SBC #'0'               \ numeric value of the key in A (if it was a number key)

 BCC OUT                \ If A < 0, jump to OUT to return from the subroutine
                        \ with a result of 0, as the key pressed was not a
                        \ number or letter and is less than ASCII "0"

 CMP #10                \ If A >= 10, jump to BAY2 to display the Inventory
 BCS BAY2               \ screen, as the key pressed was a letter or other
                        \ non-digit and is greater than ASCII "9"

 STA S                  \ Store the numeric value of the key pressed in S

 LDA R                  \ Fetch the result so far into A

 CMP #26                \ If A >= 26, where A is the number entered so far, then
 BCS OUT                \ adding a further digit will make it bigger than 256,
                        \ so jump to OUT to return from the subroutine with the
                        \ result in R (i.e. ignore the last key press)

 ASL A                  \ Set A = (A * 2) + (A * 8) = A * 10
 STA T
 ASL A
 ASL A
 ADC T

 ADC S                  \ Add the pressed digit to A and store in R, so R now
 STA R                  \ contains its previous value with the new key press
                        \ tacked onto the end

 CMP QQ25               \ If the result in R = the maximum allowed in QQ25, jump
 BEQ TT226              \ to TT226 to print the key press and keep looping (the
                        \ BEQ is needed because the BCS below would jump to OUT
                        \ if R >= QQ25, which we don't want)

 BCS OUT                \ If the result in R > QQ25, jump to OUT to return from
                        \ the subroutine with the result in R

.TT226

 LDA Q                  \ Print the character in Q (i.e. the key that was
 JSR TT26               \ pressed, as we stored the ASCII value in Q earlier)

 DEC T1                 \ Decrement the loop counter

 BNE TT223              \ Loop back to TT223 until we have checked for 12 digits

.OUT

IF _6502SP_VERSION

 PHP
 LDA #CYAN
 JSR DOCOL
 PLP

ENDIF

 LDA R                  \ Set A to the result we have been building in R

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION

.NWDAV1

 JSR TT26
 LDA QQ25
 STA R
 BRA OUT\++

.NWDAV3

 JSR TT26
 LDA #0
 STA R
 BRA OUT\++

.^NWDAV4

 JSR TT67
 LDA #176
 JSR prq
 JSR dn2
 LDY QQ29
 JMP NWDAVxx

ENDIF

