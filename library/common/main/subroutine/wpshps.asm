\ ******************************************************************************
\
\       Name: WPSHPS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Clear the scanner, reset the ball line and sun line heaps
\
\ ------------------------------------------------------------------------------
\
\ Remove all ships from the scanner, reset the sun line heap at LSO, and reset
\ the ball line heap at LSX2 and LSY2.
\
\ ******************************************************************************

.WPSHPS

 LDX #0                 \ Set up a counter in X to work our way through all the
                        \ ship slots in FRIN

.WSL1

 LDA FRIN,X             \ Fetch the ship type in slot X

 BEQ WS2                \ If the slot contains 0 then it is empty and we have
                        \ checked all the slots (as they are always shuffled
                        \ down in the main loop to close up and gaps), so jump
                        \ to WS2 as we are done

 BMI WS1                \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet or the sun, so jump down to WS1
                        \ to skip this slot, as the planet and sun don't appear
                        \ on the scanner

 STA TYPE               \ Store the ship type in TYPE

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

 LDY #31                \ We now want to copy the first 32 bytes from the ship's
                        \ data block into INWK, so set a counter in Y

.WSL2

 LDA (INF),Y            \ Copy the Y-th byte from the data block pointed to by
 STA INWK,Y             \ INF into the Y-th byte of INWK workspace

 DEY                    \ Decrement the counter to point at the next byte

 BPL WSL2               \ Loop back to WSL2 until we have copied all 32 bytes

 STX XSAV               \ Store the ship slot number in XSAV while we call SCAN

 JSR SCAN               \ Call SCAN to plot this ship on the scanner, which will
                        \ remove it as it's plotted with EOR logic

 LDX XSAV               \ Restore the ship slot number from XSAV into X

 LDY #31                \ Clear bits 3, 4 and 6 in the ship's byte #31, which
 LDA (INF),Y            \ stops drawing the ship on-screen (bit 3), hides it
 AND #%10100111         \ from the scanner (bit 4) and stops any lasers firing
 STA (INF),Y            \ at it (bit 6)

.WS1

 INX                    \ Increment X to point to the next ship slot

 BNE WSL1               \ Loop back up to process the next slot (this BNE is
                        \ effectively a JMP as X will never be zero)

.WS2

IF _CASSETTE_VERSION

 LDX #&FF               \ Set LSX2 = LSY2 = &FF to clear the ball line heap
 STX LSX2
 STX LSY2

ELIF _6502SP_VERSION

 STZ LSP
 LDX #&FF

ENDIF

                        \ Fall through into FLFLLS to reset the LSO block

