\ ******************************************************************************
\
\       Name: zonkscanners
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Hide all ships on the scanner
\
\ ******************************************************************************

.zonkscanners

 LDX #0                 \ Set up a counter in X to work our way through all the
                        \ ship slots in FRIN

.zonkL

 LDA FRIN,X             \ Fetch the ship type in slot X

 BEQ zonk1              \ If the slot contains 0 then it is empty and we have
                        \ checked all the slots (as they are always shuffled
                        \ down in the main loop to close up and gaps), so jump
                        \ to zonk1 as we are done

 BMI zonk2              \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet or the sun, so jump down to
                        \ zonk2 to skip this slot, as the planet and sun don't
                        \ appear on the scanner

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

 LDY #31                \ Clear bit 4 in the ship's byte #31, which hides it
 LDA (INF),Y            \ from the scanner
 AND #%11101111
 STA (INF),Y

.zonk2

 INX                    \ Increment X to point to the next ship slot

 BNE zonkL              \ Loop back up to process the next slot (this BNE is
                        \ effectively a JMP as X will never be zero)

.zonk1

 RTS                    \ Return from the subroutine

