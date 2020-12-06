\ ******************************************************************************
\
\       Name: WPLS
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Remove the sun from the screen
\
\ ------------------------------------------------------------------------------
\
\ We do this by redrawing it using the lines stored in the sun line heap when
\ the sun was originally drawn by the SUN routine.
\
\ Arguments:
\
\   SUNX(1 0)           The x-coordinate of the vertical centre axis of the sun
\
\ ******************************************************************************

.WPLS

IF _CASSETTE_VERSION

 LDA LSX                \ If LSX < 0, the sun line heap is empty, so return from
 BMI WPLS-1             \ the subroutine (as WPLS-1 contains an RTS)

ELIF _6502SP_VERSION

 LDA LSX                \ If LSX < 0, the sun line heap is empty, so return from
 BMI WP1                \ the subroutine (as WP1 contains an RTS)

ENDIF

 LDA SUNX               \ Set YY(1 0) = SUNX(1 0), the x-coordinate of the
 STA YY                 \ vertical centre axis of the sun that's currently on
 LDA SUNX+1             \ screen
 STA YY+1

 LDY #2*Y-1             \ #Y is the y-coordinate of the centre of the mode 4
                        \ space view, so this sets Y as a counter for the number
                        \ of lines in the space view (i.e. 191), which is also
                        \ the number of lines in the LSO block

.WPL2

 LDA LSO,Y              \ Fetch the Y-th point from the sun line heap, which
                        \ gives us the half-width of the sun's line on this line
                        \ of the screen

 BEQ P%+5               \ If A = 0, skip the following call to HLOIN2 as there
                        \ is no sun line on this line of the screen

 JSR HLOIN2             \ Call HLOIN2 to draw a horizontal line on pixel line Y,
                        \ with centre point YY(1 0) and half-width A, and remove
                        \ the line from the sun line heap once done

 DEY                    \ Decrement the loop counter

 BNE WPL2               \ Loop back for the next line in the line heap until
                        \ we have gone through the entire heap

 DEY                    \ This sets Y to &FF, as we end the loop with Y = 0

 STY LSX                \ Set LSX to &FF to indicate the sun line heap is empty

IF _CASSETTE_VERSION

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 JMP HBFL

ENDIF

