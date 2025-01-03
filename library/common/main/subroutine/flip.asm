\ ******************************************************************************
\
\       Name: FLIP
\       Type: Subroutine
\   Category: Stardust
IF NOT(_NES_VERSION)
\    Summary: Reflect the stardust particles in the screen diagonal and redraw
\             the stardust field
ELIF _NES_VERSION
\    Summary: Reflect the stardust particles in the screen diagonal
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_NES_VERSION)
\ Swap the x- and y-coordinates of all the stardust particles and draw the new
\ set of particles. Called by LOOK1 when we switch views.
ELIF _NES_VERSION
\ Swap the x- and y-coordinates of all the stardust particles. Called by LOOK1
\ when we switch views.
ENDIF
\
\ This is a quick way of making the stardust field in the new view feel
\ different without having to generate a whole new field. If you look carefully
\ at the stardust field when you switch views, you can just about see that the
\ new field is a reflection of the previous field in the screen diagonal, i.e.
\ in the line from bottom left to top right. This is the line where x = y when
\ the origin is in the middle of the screen, and positive x and y are right and
\ up, which is the coordinate system we use for stardust).
\
\ ******************************************************************************

.FLIP

IF _CASSETTE_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment

\LDA MJ                 \ These instructions are commented out in the original
\BNE FLIP-1             \ source. They would have the effect of not swapping the
                        \ stardust if we had mis-jumped into witchspace

ENDIF

IF _MASTER_VERSION \ Screen

 LDA #DUST              \ Switch to stripe 3-2-3-2, which is cyan/red in the
 STA COL                \ space view

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: The Electron version only shows 10 stardust particles at once, compared to 20 in the Master version or 18 in the other versions

 LDY NOSTM              \ Set Y to the current number of stardust particles, so
                        \ we can use it as a counter through all the stardust

ELIF _ELECTRON_VERSION

 LDY #NOST              \ Set Y to the number of stardust particles, so we can
                        \ use it as a counter through all the stardust

ENDIF

.FLL1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDX SY,Y               \ Copy the Y-th particle's y-coordinate from SY+Y into X

IF NOT(_NES_VERSION)

 LDA SX,Y               \ Copy the Y-th particle's x-coordinate from SX+Y into
 STA Y1                 \ both Y1 and the particle's y-coordinate
 STA SY,Y

 TXA                    \ Copy the Y-th particle's original y-coordinate into
 STA X1                 \ both X1 and the particle's x-coordinate, so the x- and
 STA SX,Y               \ y-coordinates are now swapped and (X1, Y1) contains
                        \ the particle's new coordinates

ELIF _NES_VERSION

 LDA SX,Y               \ Copy the Y-th particle's x-coordinate from SX+Y into
 STA SY,Y               \ the particle's y-coordinate

 TXA                    \ Copy the Y-th particle's original y-coordinate into
 STA SX,Y               \ the particle's x-coordinate, so the x- and
                        \ y-coordinates are now swapped

ENDIF

 LDA SZ,Y               \ Fetch the Y-th particle's distance from SZ+Y into ZZ
 STA ZZ

IF NOT(_NES_VERSION)

 JSR PIXEL2             \ Draw a stardust particle at (X1,Y1) with distance ZZ

ENDIF

 DEY                    \ Decrement the counter to point to the next particle of
                        \ stardust

 BNE FLL1               \ Loop back to FLL1 until we have moved all the stardust
                        \ particles

 RTS                    \ Return from the subroutine

