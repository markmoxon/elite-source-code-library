\ ******************************************************************************
\
\       Name: refund
\       Type: Subroutine
\   Category: Equipment
\    Summary: Install a new laser, processing a refund if applicable
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The power of the new laser to be fitted
\
\   X                   The view number for fitting the new laser (0-3)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\ ******************************************************************************

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Other: This is a bug fix for the laser refund bug in the first version of disc Elite, where buying a laser that you already owned affected your credit balance

IF _STH_DISC OR _SRAM_DISC

 NOP                    \ In the first version of disc Elite, there was a nasty
 NOP                    \ bug where buying a laser that you already owned
 NOP                    \ affected your credit balance, so if you were clever,
 NOP                    \ you could keep doing this to get as many credits as
 NOP                    \ you liked. This was quickly fixed by replacing the
 NOP                    \ incorrect code with NOPs, which is what we have here
 NOP
 NOP
 NOP

.refund

 STA T1                 \ Store A in T1 so we can retrieve it later

 LDA LASER,X            \ If there is no laser in view X (i.e. the laser power
 BEQ ref3               \ is zero), jump to ref3 to skip the refund code

ELIF _IB_DISC

                        \ In the first version of disc Elite, there was a nasty
                        \ bug where buying a laser that you already owned
                        \ affected your credit balance. This was quickly fixed
                        \ by replacing the incorrect code with NOPs, but the
                        \ version on Ian Bell's website contains this bug, and
                        \ this is the section responsible for the problem

.ref2

 LDY #187               \ Print out the error: "LASER PRESENT" and refund the
 JMP pres               \ value of the laser, returning from the subroutine
                        \ using a tail call. This is the cause of the refund
                        \ bug, as pres is called with the laser power in A
                        \ rather than the item number, so the prx routine
                        \ fetches a refund price from a location well outside
                        \ the prxs table. This means that depending on which
                        \ type of laser you are attempting to buy, your credit
                        \ level will go up or down, when it shouldn't change at
                        \ all

.refund

 STA T1                 \ Store A in T1 so we can retrieve it later

 LDA LASER,X            \ If there is no laser in view X (i.e. the laser power
 BEQ ref3               \ is zero), jump to ref3 to skip the refund code

 CMP T1                 \ If we are trying to replace a laser with one of the
 BEQ ref2               \ same type, jump up ref2 above

ENDIF

ELIF _6502SP_VERSION OR _MASTER_VERSION

\.ref2                  \ These instructions are commented out in the original
\LDY #187               \ source, but they would jump to pres in the EQSHP
\JMP pres               \ routine with Y = 187, which would show the error:
\Belgium                \ "LASER PRESENT" (this code was part of the refund
                        \ bug in the disc version of Elite, which is why it is
                        \ commented out)
                        \
                        \ There is also a comment in the original source - the
                        \ solitary word "Belgium"
                        \
                        \ This is presumably a reference to the Hitchhiker's
                        \ Guide to the Galaxy, which says that Belgium is the
                        \ galaxy's most unspeakably rude word, so this no doubt
                        \ reflects the authors' strong feelings on the refund
                        \ bug

.refund

 STA T1                 \ Store A in T1 so we can retrieve it later

 LDA LASER,X            \ If there is no laser in view X (i.e. the laser power
 BEQ ref3               \ is zero), jump to ref3 to skip the refund code

\CMP T1                 \ These instructions are commented out in the original
\BEQ ref2               \ source, but they would jump to ref2 above if we were
                        \ trying to replace a laser with one of the same type
                        \ (this code was part of the refund bug in the disc
                        \ version of Elite, which is why it is commented out)

ELIF _NES_VERSION

.refund

 STA T1                 \ Store A in T1 so we can retrieve it later

 LDA LASER,X            \ If there is no laser in view X (i.e. the laser power
 BEQ ref3               \ is zero), jump to ref3 to skip the refund code

ENDIF

IF NOT(_NES_VERSION)

 LDY #4                 \ If the current laser has power #POW (pulse laser),
 CMP #POW               \ jump to ref1 with Y = 4 (the item number of a pulse
 BEQ ref1               \ laser in the table at PRXS)

ELIF _NES_VERSION

 LDY #4                 \ If the current laser has power #POW+9 (pulse laser),
 CMP #POW+9             \ jump to ref1 with Y = 4 (the item number of a pulse
 BEQ ref1               \ laser in the table at PRXS)

ENDIF

 LDY #5                 \ If the current laser has power #POW+128 (beam laser),
 CMP #POW+128           \ jump to ref1 with Y = 5 (the item number of a beam
 BEQ ref1               \ laser in the table at PRXS)

 LDY #12                \ If the current laser has power #Armlas (military
 CMP #Armlas            \ laser), jump to ref1 with Y = 12 (the item number of a
 BEQ ref1               \ military laser in the table at PRXS)

 LDY #13                \ Otherwise this is a mining laser, so fall through into
                        \ ref1 with Y = 13 (the item number of a mining laser in
                        \ the table at PRXS)

.ref1

                        \ We now want to refund the laser of type Y that we are
                        \ exchanging for the new laser

 STX ZZ                 \ Store the view number in ZZ so we can retrieve it
                        \ later

 TYA                    \ Copy the laser type to be refunded from Y to A

 JSR prx                \ Call prx to set (Y X) to the price of equipment item
                        \ number A

 JSR MCASH              \ Call MCASH to add (Y X) to the cash pot

 LDX ZZ                 \ Retrieve the view number from ZZ

.ref3

                        \ Finally, we install the new laser

 LDA T1                 \ Retrieve the new laser's power from T1 into A

 STA LASER,X            \ Set the laser view to the new laser's power

IF _NES_VERSION

 JSR BEEP_b7            \ Call the BEEP subroutine to make a short, high beep

 JMP EQSHP              \ Jump back to the EQSHP routine (which called this
                        \ routine using a JMP), to redisplay the Equip Ship
                        \ screen

ENDIF

 RTS                    \ Return from the subroutine

