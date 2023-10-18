\ ******************************************************************************
\
\       Name: ClearScanner
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Remove all ships from the scanner and hide the scanner sprites
\
\ ******************************************************************************

.ClearScanner

 LDX #0                 \ Set up a counter in X to work our way through all the
                        \ ship slots in FRIN

.csca1

 LDA FRIN,X             \ Fetch the ship type in slot X

 BEQ csca3              \ If the slot contains 0 then it is empty and we have
                        \ checked all the slots (as they are always shuffled
                        \ down in the main loop to close up and gaps), so jump
                        \ to csca3WS2 as we are done

 BMI csca2              \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet or the sun, so jump down to
                        \ csca2 to skip this slot, as the planet and sun don't
                        \ appear on the scanner

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

 LDY #31                \ Clear bit 4 in the ship's byte #31, which hides it
 LDA (INF),Y            \ from the scanner
 AND #%11101111
 STA (INF),Y

.csca2

 INX                    \ Increment X to point to the next ship slot

 BNE csca1              \ Loop back up to process the next slot (this BNE is
                        \ effectively a JMP as X will never be zero)

.csca3

 LDY #44                \ Set Y so we start hiding from sprite 44 / 4 = 11

 LDX #27                \ Set X = 27 so we hide 27 sprites

                        \ Fall through into HideSprites to hide 27 sprites
                        \ from sprite 11 onwards (i.e. the scanner sprites from
                        \ 11 to 37)

