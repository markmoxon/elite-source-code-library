\ ******************************************************************************
\
\       Name: WPSHPS
\       Type: Subroutine
\   Category: Dashboard
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Clear the scanner, reset the ball line and sun line heaps
ELIF _ELECTRON_VERSION
\    Summary: Clear the scanner and reset the ball line heap
ELIF _NES_VERSION
\    Summary: Set all ships to be hidden from the screen
ENDIF
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Remove all ships from the scanner, reset the sun line heap at LSO, and reset
\ the ball line heap at LSX2 and LSY2.
\
ELIF _ELECTRON_VERSION
\ ------------------------------------------------------------------------------
\
\ Remove all ships from the scanner and reset the ball line heap at LSX2 and
\ LSY2.
\
ENDIF
\ ******************************************************************************

.WPSHPS

 LDX #0                 \ Set up a counter in X to work our way through all the
                        \ ship slots in FRIN

.WSL1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA FRIN,X             \ Fetch the ship type in slot X

 BEQ WS2                \ If the slot contains 0 then it is empty and we have
                        \ checked all the slots (as they are always shuffled
                        \ down in the main loop to close up and gaps), so jump
                        \ to WS2 as we are done

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

 BMI WS1                \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet or the sun, so jump down to WS1
                        \ to skip this slot, as the planet and sun don't appear
                        \ on the scanner

ELIF _ELECTRON_VERSION

 BMI WS1                \ If the slot contains a ship type with bit 7 set, then
                        \ it contains the planet, so jump down to WS1 to skip
                        \ this slot, as the planet don't appear on the scanner

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION OR _NES_VERSION \ Platform

 STA TYPE               \ Store the ship type in TYPE

ENDIF

 JSR GINF               \ Call GINF to get the address of the data block for
                        \ ship slot X and store it in INF

IF NOT(_NES_VERSION)

 LDY #31                \ We now want to copy the first 32 bytes from the ship's
                        \ data block into INWK, so set a counter in Y

.WSL2

 LDA (INF),Y            \ Copy the Y-th byte from the data block pointed to by
 STA INWK,Y             \ INF into the Y-th byte of INWK workspace

 DEY                    \ Decrement the counter to point at the next byte

 BPL WSL2               \ Loop back to WSL2 until we have copied all 32 bytes

 STX XSAV               \ Store the ship slot number in XSAV while we call SCAN

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 JSR SCAN               \ Call SCAN to plot this ship on the scanner, which will
                        \ remove it as it's plotted with EOR logic

ENDIF

IF NOT(_NES_VERSION)

 LDX XSAV               \ Restore the ship slot number from XSAV into X

 LDY #31                \ Clear bits 3, 4 and 6 in the ship's byte #31, which
 LDA (INF),Y            \ stops drawing the ship on-screen (bit 3), hides it
 AND #%10100111         \ from the scanner (bit 4) and stops any lasers firing
 STA (INF),Y            \ (bit 6)

ELIF _NES_VERSION

 LDY #31                \ Clear bits 3 and 6 in the ship's byte #31, which stops
 LDA (INF),Y            \ drawing the ship on-screen (bit 3), and denotes that
 AND #%10110111         \ the explosion has not been drawn and there are no
 STA (INF),Y            \ lasers firing (bit 6)

ENDIF

.WS1

 INX                    \ Increment X to point to the next ship slot

 BNE WSL1               \ Loop back up to process the next slot (this BNE is
                        \ effectively a JMP as X will never be zero)

.WS2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDX #&FF               \ Set LSX2 = LSY2 = &FF to clear the ball line heap
 STX LSX2
 STX LSY2

ELIF _6502SP_VERSION

 STZ LSP                \ Reset the ball line heap by setting the ball line heap
                        \ pointer to 0

 LDX #&FF               \ Set X = &FF (though this appears not to be used)

ELIF _MASTER_VERSION

 LDX #0                 \ Reset the ball line heap by setting the ball line heap
 STX LSP                \ pointer to 0

 DEX                    \ Set X = &FF

 STX LSX2               \ Set LSX2 = LSY2 = &FF to clear the ball line heap
 STX LSY2

ELIF _NES_VERSION

 LDX #0                 \ Set X = 0 (though this appears not to be used)

ENDIF

IF NOT(_NES_VERSION)

                        \ Fall through into FLFLLS to reset the LSO block

ELIF _NES_VERSION

 RTS                    \ Return from the subroutine

ENDIF

