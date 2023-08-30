\ ******************************************************************************
\
\       Name: SUN (Part 4 of 4)
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Continue to the top of the screen, erasing the old sun
\  Deep dive: Drawing the sun
\
\ ------------------------------------------------------------------------------
\
\ This part erases any remaining traces of the old sun, now that we have drawn
\ all the way to the top of the new sun.
\
\ Other entry points:
\
\   RTS2                Contains an RTS
\
\ ******************************************************************************

IF NOT(_NES_VERSION)

 LDA SUNX               \ Set YY(1 0) = SUNX(1 0), the x-coordinate of the
 STA YY                 \ vertical centre axis of the old sun that's currently
 LDA SUNX+1             \ on-screen
 STA YY+1

.PLFL3

 LDA LSO,Y              \ Fetch the Y-th point from the sun line heap, which
                        \ gives us the half-width of the old sun's line on this
                        \ line of the screen

 BEQ PLF9               \ If A = 0, skip the following call to HLOIN2 as there
                        \ is no sun line on this line of the screen

 JSR HLOIN2             \ Call HLOIN2 to draw a horizontal line on pixel line Y,
                        \ with centre point YY(1 0) and half-width A, and remove
                        \ the line from the sun line heap once done

.PLF9

 DEY                    \ Decrement the line number in Y to move to the line
                        \ above

 BNE PLFL3              \ Jump up to PLFL3 to redraw the next line up, until we
                        \ have reached the top of the screen

.PLF8

                        \ If we get here, we have successfully made it from the
                        \ bottom line of the screen to the top, and the old sun
                        \ has been replaced by the new one

 CLC                    \ Clear the C flag to indicate success in drawing the
                        \ sun

 LDA K3                 \ Set SUNX(1 0) = K3(1 0)
 STA SUNX
 LDA K3+1
 STA SUNX+1

ENDIF

IF _6502SP_VERSION \ Tube

 JSR HBFL               \ Call HBFL to send the contents of the horizontal line
                        \ buffer to the I/O processor for drawing on-screen

ENDIF

.RTS2

 RTS                    \ Return from the subroutine

