\ ******************************************************************************
\
\       Name: LASLI
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the laser lines for when we fire our lasers
\
\ ------------------------------------------------------------------------------
\
\ Draw the laser lines, aiming them to slightly different place each time so
\ they appear to flicker and dance. Also heat up the laser temperature and drain
\ some energy.
\
\ Other entry points:
\
\   LASLI2              Just draw the current laser lines without moving the
\                       centre point, draining energy or heating up. This has
\                       the effect of removing the lines from the screen
\
\   LASLI-1             Contains an RTS
\
\ ******************************************************************************

.LASLI

 JSR DORND              \ Set A and X to random numbers

 AND #7                 \ Restrict A to a random value in the range 0 to 7

 ADC #Y-4               \ Set LASY to four pixels above the centre of the
 STA LASY               \ screen (#Y), plus our random number, so the laser
                        \ dances above and below the centre point

 JSR DORND              \ Set A and X to random numbers

 AND #7                 \ Restrict A to a random value in the range 0 to 7

 ADC #X-4               \ Set LASX to four pixels left of the centre of the
 STA LASX               \ screen (#X), plus our random number, so the laser
                        \ dances to the left and right of the centre point

 LDA GNTMP              \ Add 8 to the laser temperature in GNTMP
 ADC #8
 STA GNTMP

 JSR DENGY              \ Call DENGY to deplete our energy banks by 1

.LASLI2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE PU1-1              \ then jump to MA9 to return from the main flight loop
                        \ (as PU1-1 is an RTS)

ELIF _DISC_FLIGHT OR _6502SP_VERSION

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE LASLI-1            \ then jump to MA9 to return from the main flight loop
                        \ (as LASLI-1 is an RTS)

ELIF _MASTER_VERSION

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE ARCRTS             \ then jump to MA9 to return from the main flight loop
                        \ (as ARCRTS is an RTS)

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JSR DOCOL              \ switch to colour 2, which is red in the space view

ELIF _MASTER_VERSION

 LDA #RED               \ Switch to colour 2, which is red in the space view
 STA COL

ENDIF

 LDA #32                \ Set A = 32 and Y = 224 for the first set of laser
 LDY #224               \ lines (the wider pair of lines)

IF _6502SP_VERSION \ Advanced: Group A: In the original versions, both sets of laser lines converge at the same pixel. In the 6502SP version, the upper pair of laser lines aim one pixel higher than the lower pair, so they overlap less, and in the Master version, the top lines aim two pixels higher than the lower lines. Because EOR logic is used when drawing, this gives the lasers in the 6502SP version a sharper point, and the lines in the Master version an even sharper point, as the tips overlap less and don't cancel each other out

IF _SNG45

 DEC LASY               \ Decrement the y-coordinate of the centre point to move
                        \ it up the screen by a pixel for the top set of lines,
                        \ so the wider set of lines aim slightly higher than the
                        \ narrower set

ENDIF

ELIF _MASTER_VERSION

 DEC LASY               \ Decrement the y-coordinate of the centre point to move
 DEC LASY               \ it up the screen by two pixels for the top set of
                        \ lines, so the wider set of lines aim slightly higher
                        \ than the narrower set

ENDIF

 JSR las                \ Call las below to draw the first set of laser lines

IF _6502SP_VERSION \ Advanced: See group A

IF _SNG45

 INC LASY               \ Increment the y-coordinate of the centre point to put
                        \ it back to the original position

ENDIF

ELIF _MASTER_VERSION

 INC LASY               \ Increment the y-coordinate of the centre point to put
 INC LASY               \ it back to the original position

ENDIF

 LDA #48                \ Fall through into las with A = 48 and Y = 208 to draw
 LDY #208               \ a second set of lines (the narrower pair)

                        \ The following routine draws two laser lines, one from
                        \ the centre point down to point A on the bottom row,
                        \ and the other from the centre point down to point Y
                        \ on the bottom row. We therefore get lines from the
                        \ centre point to points 32, 48, 208 and 224 along the
                        \ bottom row, giving us the triangular laser effect
                        \ we're after

.las

 STA X2                 \ Set X2 = A

 LDA LASX               \ Set (X1, Y1) to the random centre point we set above
 STA X1
 LDA LASY
 STA Y1

 LDA #2*Y-1             \ Set Y2 = 2 * #Y - 1. The constant #Y is 96, the
 STA Y2                 \ y-coordinate of the mid-point of the space view, so
                        \ this sets Y2 to 191, the y-coordinate of the bottom
                        \ pixel row of the space view

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Label

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ the centre point to (A, 191)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ the centre point to (A, 191)

ENDIF

 LDA LASX               \ Set (X1, Y1) to the random centre point we set above
 STA X1
 LDA LASY
 STA Y1

 STY X2                 \ Set X2 = Y

 LDA #2*Y-1             \ Set Y2 = 2 * #Y - 1, the y-coordinate of the bottom
 STA Y2                 \ pixel row of the space view (as before)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Label

 JMP LOIN               \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ the centre point to (Y, 191), and return from
                        \ the subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JMP LL30               \ Draw a line from (X1, Y1) to (X2, Y2), so that's from
                        \ the centre point to (Y, 191), and return from
                        \ the subroutine using a tail call

ENDIF

