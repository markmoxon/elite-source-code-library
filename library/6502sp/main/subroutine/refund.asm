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
\   X                   The view number for fitting the new laser
\
\ Returns:
\
\   A                   A is preserved
\
\   X                   X is preserved
\
\ ******************************************************************************

\.ref2                  \ These instructions are commented out in the original
\LDY #18                \ source, but they would jump to pres in the EQSHP
\JMP pres               \ routine with Y = 18, which would show the error:
                        \ "{cr}all caps}EQUIPMENT: {sentence case} PRESENT"

.refund

 STA T1                 \ Store A in T1 so we can retrieve it later

 LDA LASER,X            \ If there is no laser in view X (i.e. the laser power
 BEQ ref3               \ is zero), jump to ref3 to skip the refund code

 \CMP T1                \ These instructions are commented out in the original
 \BEQ ref2              \ source, but they would jump to ref2 above if we were
                        \ trying to replace a laser with one of the same type

 LDY #4                 \ If the current laser has power #POW (pulse laser),
 CMP #POW               \ jump to ref1 with Y = 4 (the item number of a pulse
 BEQ ref1               \ laser in the table at PRXS)

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

 STX ZZ                 \ Store the view number in ZZnso we can retrieve it
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

 RTS                    \ Return from the subroutine

