\ ******************************************************************************
\
\       Name: gnum
\       Type: Subroutine
\   Category: Market
\    Summary: Get a number from the keyboard
\
\ ------------------------------------------------------------------------------
\
\ Get a number from the keyboard, up to the maximum number in QQ25, for the
\ buying and selling of cargo and equipment.
\
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
\ Pressing "Y" will return the maximum number (i.e. buy/sell all items), while
\ pressing "N" will abort the sale and return a 0.
\
ENDIF
\ Pressing a key with an ASCII code less than ASCII "0" will return a 0 in A (so
\ that includes pressing Space or Return), while pressing a key with an ASCII
\ code greater than ASCII "9" will jump to the Inventory screen (so that
\ includes all letters and most punctuation).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   QQ25                The maximum number allowed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The number entered
\
\   R                   Also contains the number entered
\
\   C flag              Set if the number is too large (> QQ25), clear otherwise
\
IF _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   OUT                 The OUTX routine jumps back here after printing the key
\                       that was just pressed
\
ENDIF
\ ******************************************************************************

.gnum

IF _6502SP_VERSION \ Screen

 LDA #MAGENTA           \ Send a #SETCOL MAGENTA command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is magenta in the trade view

ELIF _MASTER_VERSION

 LDA #MAGENTA           \ Switch to colour 2, which is magenta in the trade view
 STA COL

ELIF _C64_VERSION

 LDA #MAG2              \ Switch the text colour to violet
 STA COL2

ELIF _APPLE_VERSION

\LDA #MAG2              \ These instructions are commented out in the original
\STA COL2               \ source

ENDIF

 LDX #0                 \ We will build the number entered in R, so initialise
 STX R                  \ it with 0

 LDX #12                \ We will check for up to 12 key presses, so set a
 STX T1                 \ counter in T1

.TT223

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A (and X)

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Enhanced: Group A: When buying or selling cargo in the enhanced versions, you can specify an exact amount of cargo for the transaction, or you can press "Y" to buy/sell everything, or "N" to buy/sell nothing. In the cassette version, you have to enter the exact amount you want to buy, and if you want to sell an item, then you have to sell your entire stock of that item, rather than part of it

 LDX R                  \ If R is non-zero then skip to NWDAV2, as we are
 BNE NWDAV2             \ already building a number

 CMP #'y'               \ If "Y" was pressed, jump to NWDAV1 to return the
 BEQ NWDAV1             \ maximum number allowed (i.e. buy/sell the whole stock)

 CMP #'n'               \ If "N" was pressed, jump to NWDAV3 to return from the
 BEQ NWDAV3             \ subroutine with a result of 0 (i.e. abort transaction)

.NWDAV2

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDX R                  \ If R is non-zero then skip to NWDAV2, as we are
 BNE NWDAV2             \ already building a number

 CMP #'Y'               \ If "Y" was pressed, jump to NWDAV1 to return the
 BEQ NWDAV1             \ maximum number allowed (i.e. buy/sell the whole stock)

 CMP #'N'               \ If "N" was pressed, jump to NWDAV3 to return from the
 BEQ NWDAV3             \ subroutine with a result of 0 (i.e. abort transaction)

.NWDAV2

ELIF _ELITE_A_ENCYCLOPEDIA

 LDX R                  \ If R is non-zero then skip to NWDAV2, as we are
 BNE NWDAV2             \ already building a number

.NWDAV2

ENDIF

 STA Q                  \ Store the key pressed in Q

 SEC                    \ Subtract ASCII "0" from the key pressed, to leave the
 SBC #'0'               \ numeric value of the key in A (if it was a number key)

 BCC OUT                \ If A < 0, jump to OUT to load the current number and
                        \ return from the subroutine, as the key pressed was
                        \ RETURN (or some other ncharacter with a value less
                        \ than ASCII "0")

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 CMP #10                \ If A >= 10, jump to BAY2 to display the Inventory
 BCS BAY2               \ screen, as the key pressed was a letter or other
                        \ non-digit and is greater than ASCII "9"

ELIF _ELITE_A_ENCYCLOPEDIA

 CMP #10                \ If A >= 10, jump to buy_invnt to decide which screen
 BCS buy_invnt          \ to display, as the key pressed was a letter or other
                        \ non-digit and is greater than ASCII "9" (so it could
                        \ be a red function key, for example)

ENDIF

 STA S                  \ Store the numeric value of the key pressed in S

 LDA R                  \ Fetch the result so far into A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: Group B: If you try to enter a number that is too big when buying or selling in the Master version, all your key presses are displayed, whereas in the other versions the key press that pushes you over the edge is not shown

 CMP #26                \ If A >= 26, where A is the number entered so far, then
 BCS OUT                \ adding a further digit will make it bigger than 256,
                        \ so jump to OUT to return from the subroutine with the
                        \ result in R (i.e. ignore the last key press)

ELIF _MASTER_VERSION

\BEQ P%+4               \ This instruction is commented out in the original
                        \ source, and has a comment "tribs"

 CMP #26                \ If A >= 26, where A is the number entered so far, then
 BCS OUTX               \ adding a further digit will make it bigger than 256,
                        \ so jump to OUTX to print the key that was just pressed
                        \ before jumping to OUT below with the C flag still set

ENDIF

 ASL A                  \ Set A = (A * 2) + (A * 8) = A * 10
 STA T
 ASL A
 ASL A
 ADC T

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: See group B

 ADC S                  \ Add the pressed digit to A and store in R, so R now
 STA R                  \ contains its previous value with the new key press
                        \ tacked onto the end

ELIF _MASTER_VERSION

 ADC S                  \ Add the pressed digit to A

 BCS OUTX               \ If the addition overflowed, then jump to OUTX to print
                        \ the key that was just pressed before jumping to OUT
                        \ below with the C flag still set

 STA R                  \ Otherwise store the result in R, so R now contains
                        \ its previous value with the new key press tacked onto
                        \ the end

ENDIF

 CMP QQ25               \ If the result in R = the maximum allowed in QQ25, jump
 BEQ TT226              \ to TT226 to print the key press and keep looping (the
                        \ BEQ is needed because the BCS below would jump to OUT
                        \ if R >= QQ25, which we don't want)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: See group B

 BCS OUT                \ If the result in R > QQ25, jump to OUT to return from
                        \ the subroutine with the result in R

ELIF _MASTER_VERSION

 BCS OUTX               \ If the result in R > QQ25, jump to OUTX to print
                        \ the key that was just pressed before jumping to OUT
                        \ below with the C flag still set

ENDIF

.TT226

 LDA Q                  \ Print the character in Q (i.e. the key that was
 JSR TT26               \ pressed, as we stored the ASCII value in Q earlier)

 DEC T1                 \ Decrement the loop counter

 BNE TT223              \ Loop back to TT223 until we have checked for 12 digits

.OUT

IF _6502SP_VERSION \ Screen

 PHP                    \ Store the processor flags, so we can return the C flag
                        \ without the call to DOCOL corrupting it

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JSR DOCOL              \ switch to colour 3, which is white in the trade view

 PLP                    \ Restore the processor flags, in particular the C flag

ELIF _MASTER_VERSION

 LDA #CYAN              \ Switch to colour 3, which is white in the trade view
 STA COL

ELIF _C64_VERSION

 LDA #&10               \ Switch the text colour to white
 STA COL2

ELIF _APPLE_VERSION

\LDA #&10               \ These instructions are commented out in the original
\STA COL2               \ source

ENDIF

 LDA R                  \ Set A to the result we have been building in R

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Enhanced: See group A

.NWDAV1

                        \ If we get here then "Y" was pressed, so we return the
                        \ maximum number allowed, which is in QQ25

 JSR TT26               \ Print the character for the key that was pressed

 LDA QQ25               \ Set R = QQ25, so we return the maximum value allowed
 STA R

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 BRA OUT                \ Jump to OUT to return from the subroutine

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 JMP OUT                \ Jump to OUT to return from the subroutine

ENDIF

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION \ Enhanced: See group A

.NWDAV3

                        \ If we get here then "N" was pressed, so we return 0

 JSR TT26               \ Print the character for the key that was pressed

 LDA #0                 \ Set R = 0, so we return 0
 STA R

ELIF _MASTER_VERSION

.NWDAV3

                        \ If we get here then "N" was pressed, so we return 0

 JSR TT26               \ Print the character for the key that was pressed

 STZ R                  \ Set R = 0, so we return 0

ENDIF

IF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Minor

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 BRA OUT                \ Jump to OUT to return from the subroutine

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 JMP OUT                \ Jump to OUT to return from the subroutine

ENDIF

