\ ******************************************************************************
\
\       Name: Main flight loop (Part 6 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Move the ship in space and copy the updated
\             INWK data block back to K%
\  Deep dive: Program flow of the main game loop
\             Program flow of the ship-moving routine
\             Ship data blocks
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * Move the ship in space
\
\     * Copy the updated ship's data block from INWK back to K%
\
\ ******************************************************************************

.MA21

IF NOT(_ELITE_A_6502SP_PARA)

 JSR MVEIT              \ Call MVEIT to move the ship we are processing in space

ELIF _ELITE_A_6502SP_PARA

 JSR MVEIT_FLIGHT       \ Call MVEIT_FLIGHT to move the ship we are processing
                        \ in space

ENDIF

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

                        \ Now that we are done processing this ship, we need to
                        \ copy the ship data back from INWK to the correct place
                        \ in the K% workspace. We already set INF in part 4 to
                        \ point to the ship's data block in K%, so we can simply
                        \ do the reverse of the copy we did before, this time
                        \ copying from INWK to INF

 LDY #NI%-1             \ Set a counter in Y so we can loop through the NI%
                        \ bytes in the ship data block

.MAL3

 LDA INWK,Y             \ Load the Y-th byte of INWK and store it in the Y-th
 STA (INF),Y            \ byte of INF

 DEY                    \ Decrement the loop counter

 BPL MAL3               \ Loop back for the next byte, until we have copied the
                        \ last byte from INWK back to INF

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

