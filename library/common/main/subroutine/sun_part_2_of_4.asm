\ ******************************************************************************
\
\       Name: SUN (Part 2 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw the sun: Start from bottom of screen and erase the old sun
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases the old sun, starting at the bottom of the screen and working
\ upwards until we reach the bottom of the new sun.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 LDY #2*Y-1             \ Set Y = y-coordinate of the bottom of the screen,
                        \ which we use as a counter in the following routine to
                        \ redraw the old sun

ELIF _MASTER_VERSION

 LDY YMAX               \ Set Y = y-coordinate of the bottom of the screen,
                        \ which we use as a counter in the following routine to
                        \ redraw the old sun

ENDIF

 LDA SUNX               \ Set YY(1 0) = SUNX(1 0), the x-coordinate of the
 STA YY                 \ vertical centre axis of the old sun that's currently
 LDA SUNX+1             \ on-screen
 STA YY+1

.PLFL2

 CPY TGT                \ If Y = TGT, we have reached the line where we will
 BEQ PLFL               \ start drawing the new sun, so there is no need to
                        \ keep erasing the old one, so jump down to PLFL

 LDA LSO,Y              \ Fetch the Y-th point from the sun line heap, which
                        \ gives us the half-width of the old sun's line on this
                        \ line of the screen

 BEQ PLF13              \ If A = 0, skip the following call to HLOIN2 as there
                        \ is no sun line on this line of the screen

 JSR HLOIN2             \ Call HLOIN2 to draw a horizontal line on pixel line Y,
                        \ with centre point YY(1 0) and half-width A, and remove
                        \ the line from the sun line heap once done

.PLF13

 DEY                    \ Decrement the loop counter

 BNE PLFL2              \ Loop back for the next line in the line heap until
                        \ we have either gone through the entire heap, or
                        \ reached the bottom row of the new sun

