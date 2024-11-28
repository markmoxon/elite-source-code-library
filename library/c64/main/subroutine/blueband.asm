\ ******************************************************************************
\
\       Name: BLUEBAND
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear two four-character borders along each side of the space view
\
\ ------------------------------------------------------------------------------
\
\ The Elite game screen is 256 pixels wide but the Commodore 64 screen is 320
\ pixels wide, which leaves 64 pixels (eight character blocks). We therefore
\ show the game in the middle of the screen, and clear a four-character border
\ along the left and right edges of the space view.
\
\ This prevents graphics from spilling out of the sides of the space view (in
\ particular the Trumble and explosion sprites).
\
\ ******************************************************************************

.BLUEBAND

 LDX #LO(SCBASE)        \ Set (Y X) = SCBASE so it contains the address of the
 LDY #HI(SCBASE)        \ top-left corner of the four-character border along
                        \ the left edge of the screen

 JSR BLUEBANDS          \ Call BLUEBANDS to clear the left border

 LDX #LO(SCBASE+37*8)   \ Set (Y X) = SCBASE so it contains the address of
 LDY #HI(SCBASE+37*8)   \ character block 37 on the top row of the screen, which
                        \ is the top-left corner of the border along the right
                        \ edge of the screen (as there are four blocks for the
                        \ left border and 32 blocks for the space view)

                        \ Fall through into BLUEBANDS to clear the right border

