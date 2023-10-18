\ ******************************************************************************
\
\       Name: RemoveShip
\       Type: Subroutine
\   Category: Universe
\    Summary: Fetch a ship data block and remove that ship from our local bubble
\             of universe
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The slot number of the ship to remove
\
\   INF                 The address of the data block for the ship to remove
\
\ ******************************************************************************

.RemoveShip

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #NI%-1             \ There are NI% bytes in each ship data block (and in
                        \ the INWK workspace, so we set a counter in Y so we can
                        \ loop through them

.cink1

 LDA (INF),Y            \ Load the Y-th byte of INF and store it in the Y-th
 STA INWK,Y             \ byte of INWK

 DEY                    \ Decrement the loop counter

 BPL cink1              \ Loop back for the next byte until we have copied the
                        \ last byte from INF to INWK

                        \ Fall through into KILLSHP to remove the ship from our
                        \ local bubble of universe

