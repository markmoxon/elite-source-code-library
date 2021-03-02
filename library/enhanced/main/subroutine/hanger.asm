\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
IF _DISC_DOCKED \ Comment
\    Summary: Display the ship hanger
ELIF _6502SP_VERSION
\    Summary: Implement the OSWORD 248 command (display the ship hanger)
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _DISC_DOCKED \ Comment
\ This routine is called after the ships in the hanger have been drawn, so all
\ it has to do is draw the hanger's background.
ELIF _6502SP_VERSION
\ This command is sent after the ships in the hanger have been drawn, so all it
\ has to do is draw the hanger's background.
ENDIF
\
\ The hanger background is made up of two parts:
\
\   * The hanger floor consists of 11 screen-wide horizontal lines, which start
\     out quite spaced out near the bottom of the screen, and bunch ever closer
\     together as the eye moves up towards the horizon, where they merge to give
\     a sense of perspective
\
\   * The back wall of the hanger consists of 15 equally spaced vertical lines
\     that join the horizon to the top of the screen
\
\ The ships in the hangar have already been drawn by this point, so the lines
\ are drawn so they don't overlap anything that's already there, which makes
\ them look like they are behind and below the ships. This is achieved by
\ drawing the lines in from the screen edges until they bump into something
\ already on-screen. For the horizontal lines, when there are multiple ships in
\ the hanger, this also means drawing lines between the ships, as well as in
\ from each side.
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   HA3                 Contains an RTS
\
ENDIF
\ ******************************************************************************

.HANGER

                        \ We start by drawing the floor

 LDX #2                 \ We start with a loop using a counter in T that goes
                        \ from 2 to 12, one for each of the 11 horizontal lines
                        \ in the floor, so set the initial value in X

.HAL1

IF _DISC_DOCKED \ Minor

 STX XSAV               \ Store the loop counter in XSAV

ELIF _6502SP_VERSION

 STX T                  \ Store the loop counter in T

ENDIF

 LDA #130               \ Set A = 130

IF _DISC_DOCKED \ Minor

 LDX XSAV               \ Retrieve the loop counter from XSAV

ENDIF

 STX Q                  \ Set Q = T

 JSR DVID4              \ Calculate the following:
                        \
                        \   (P R) = 256 * A / Q
                        \         = 256 * 130 / T
                        \
                        \ so P = 130 / T, and as the counter T goes from 2 to
                        \ 12, P goes 65, 43, 32 ... 13, 11, 10, with the
                        \ difference between two consecutive numbers getting
                        \ smaller as P gets smaller
                        \
                        \ We can use this value as a y-coordinate to draw a set
                        \ of horizontal lines, spaced out near the bottom of the
                        \ screen (high value of P, high y-coordinate, lower down
                        \ the screen) and bunching up towards the horizon (low
                        \ value of P, low y-coordinate, higher up the screen)

IF _DISC_DOCKED \ Screen

 LDA P                  \ Set Y = #Y + P
 CLC                    \
 ADC #Y                 \ where #Y is the y-coordinate of the centre of the
                        \ screen, so Y is now the horizontal pixel row of the
                        \ line we want to draw to display the hanger floor

 LSR A                  \ Set A = A >> 3
 LSR A
 LSR A

 ORA #&60               \ Each character row in Elite's screen mode takes up one
                        \ page in memory (256 bytes), so we now OR with &60 to
                        \ get the page containing the line

 STA SCH                \ Store the screen page in the high byte of SC(1 0)

ELIF _6502SP_VERSION

 LDA P                  \ Set Y = #Y + P
 CLC                    \
 ADC #Y                 \ where #Y is the y-coordinate of the centre of the
 TAY                    \ screen, so Y is now the horizontal pixel row of the
                        \ line we want to draw to display the hanger floor

 LDA ylookup,Y          \ Look up the page number of the character row that
 STA SC+1               \ contains the pixel with the y-coordinate in Y, and
                        \ store it in the high byte of SC(1 0) at SC+1

 STA R                  \ Also store the page number in R

ENDIF

 LDA P                  \ Set the low byte of SC(1 0) to the y-coordinate mod 7,
 AND #7                 \ which determines the pixel row in the character block
 STA SC                 \ we need to draw in (as each character row is 8 pixels
                        \ high), so SC(1 0) now points to the address of the
                        \ start of the horizontal line we want to draw

 LDY #0                 \ Set Y = 0 so the call to HAS2 starts drawing the line
                        \ in the first byte of the screen row, at the left edge
                        \ of the screen

 JSR HAS2               \ Draw a horizontal line from the left edge of the
                        \ screen, going right until we bump into something
                        \ already on-screen, at which point stop drawing

IF _DISC_DOCKED \ Screen

 LDA #%00000100         \ Now to draw the same line but from the right edge of
                        \ the screen, so set a pixel mask in A to check the
                        \ sixth pixel of the last byte, so we skip the 2-pixel
                        \ scren border at the right edge of the screen

ELIF _6502SP_VERSION

 LDY R                  \ Fetch the page number of the line from R, increment it
 INY                    \ so it points to the right half of the character row
 STY SC+1               \ (as each row takes up 2 pages), and store it in the
                        \ high byte of SC(1 0) at SC+1

 LDA #%01000000         \ Now to draw the same line but from the right edge of
                        \ the screen, so set a pixel mask in A to check the
                        \ second pixel of the last byte, so we skip the 2-pixel
                        \ scren border at the right edge of the screen

ENDIF

 LDY #248               \ Set Y = 248 so the call to HAS3 starts drawing the
                        \ line in the last byte of the screen row, at the right
                        \ edge of the screen

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

IF _DISC_DOCKED \ Tube

 LDY YSAV               \ Fetch the value of YSAV, which gets set to 0 in the
                        \ HALL routine above if there is only one ship

 BEQ HA2                \ If YSAV is zero, jump to HA2 to skip the following
                        \ as there is only one ship in the hanger

ELIF _6502SP_VERSION

 LDY #2                 \ Fetch byte #2 from the parameter block, which tells us
 LDA (OSSC),Y           \ whether the ship hanger contains just one ship, or
 TAY                    \ multiple ships

 BEQ HA2                \ If byte #2 is zero, jump to HA2 to skip the following
                        \ as there is only one ship in the hanger

ENDIF

                        \ If we get here then there are multiple ships in the
                        \ hanger, so we also need to draw the horizontal line in
                        \ the gap between the ships

IF _DISC_DOCKED \ Screen

 JSR HAS2               \ Call HAS2 to a line to the right, starting with the
                        \ third pixel of the pixel row at screen address SC(1 0)

 LDY #128               \ We now draw the line from the centre of the screen
                        \ to the left. SC(1 0) points to the start address of
                        \ the screen row, so we set Y to 128 so the call to
                        \ HAS3 starts drawing from halfway along the row (i.e.
                        \ from the centre of the screen)

 LDA #%01000000         \ We want to start drawing from the second pixel, to
                        \ avoid the border, so we set a pixel mask accordingly

 JSR HAS3               \ Call HAS3, which draws a line from the halfway point
                        \ across the left half of the screen, going left until
                        \ we bump into something already on-screen, at which
                        \ point it stops drawing

ELIF _6502SP_VERSION

 LDY #0                 \ First we draw the line from the centre of the screen
                        \ to the right. SC(1 0) points to the start address of
                        \ the second half of the screen row, so we set Y to 0 so
                        \ the call to HAL3 starts drawing from the first
                        \ character in that second half

 LDA #%10001000         \ We want to start drawing from the first pixel, so we
                        \ set a mask in A to the first pixel in the 4-pixel byte

 JSR HAL3               \ Call HAL3, which draws a line from the halfway point
                        \ across the right half of the screen, going right until
                        \ we bump into something already on-screen, at which
                        \ point it stops drawing

 DEC SC+1               \ Decrement the high byte of SC(1 0) in SC+1 to point to
                        \ the previous page (i.e. the left half of this screen
                        \ row)

 LDY #248               \ We now draw the line from the centre of the screen
                        \ to the left. SC(1 0) points to the start address of
                        \ the first half of the screen row, so we set Y to 248
                        \ so the call to HAS3 starts drawing from the last
                        \ character in that first half

 LDA #%00010000         \ We want to start drawing from the last pixel, so we
                        \ set a mask in A to the last pixel in the 4-pixel byte

 JSR HAS3               \ Call HAS3, which draws a line from the halfway point
                        \ across the left half of the screen, going left until
                        \ we bump into something already on-screen, at which
                        \ point it stops drawing

ENDIF

.HA2

                        \ We have finished threading our horizontal line behind
                        \ the ships already on-screen, so now for the next line

IF _DISC_DOCKED \ Minor

 LDX XSAV               \ Fetch the loop counter from XSAV and increment it
 INX

ELIF _6502SP_VERSION

 LDX T                  \ Fetch the loop counter from T and increment it
 INX

ENDIF

 CPX #13                \ If the loop counter is less than 13 (i.e. T = 2 to 12)
 BCC HAL1               \ then loop back to HAL1 to draw the next line

                        \ The floor is done, so now we move on to the back wall

IF _6502SP_VERSION \ Other

 LDA #60                \ Set S = 60, so we run the following 60 times (though I
 STA S                  \ have no idea why it's 60 times, when it should be 15,
                        \ as this has the effect of drawing each vertical line
                        \ four times, each time starting one character row lower
                        \ on-screen)

ENDIF

 LDA #16                \ We want to draw 15 vertical lines, one every 16 pixels
                        \ across the screen, with the first at x-coordinate 16,
                        \ so set this in A to act as the x-coordinate of each
                        \ line as we work our way through them from left to
                        \ right, incrementing by 16 for each new line

IF _6502SP_VERSION \ Screen

 LDX #&40               \ Set X = &40, the high byte of the start of screen
 STX R                  \ memory (the screen starts at location &4000) and the
                        \ page number of the first screen row

ENDIF

.HAL6

IF _DISC_DOCKED \ Screen

 LDX #&60               \ Set the high byte of SC(1 0) to &60, the high byte of
 STX SCH                \ the start of screen

 STA XSAV               \ Store this value in XSAV, so we can retrieve it later

 AND #%11111000         \ Each character block contains 8 pixel rows, so to get
                        \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2

 STA SC                 \ Set the low byte of SC(1 0) to this value, so SC(1 0)
                        \ now points to the address where the line starts

 LDX #%10000000         \ Set a mask in X to the first pixel the 8-pixel byte

ELIF _6502SP_VERSION

 LDX R                  \ Set the high byte of SC(1 0) to R
 STX SC+1

 STA T                  \ Store A in T so we can retrieve it later

 AND #%11111100         \ A contains the x-coordinate of the line to draw, and
 STA SC                 \ each character block is 4 pixels wide, so setting the
                        \ low byte of SC(1 0) to A mod 4 points SC(1 0) to the
                        \ correct character block on the top screen row for this
                        \ x-coordinate

 LDX #%10001000         \ Set a mask in X to the first pixel in the 4-pixel byte

ENDIF

 LDY #1                 \ We are going to start drawing the line from the second
                        \ pixel from the top (to avoid drawing on the 1-pixel
                        \ border), so set Y to 1 to point to the second row in
                        \ the first character block

.HAL7

 TXA                    \ Copy the pixel mask to A

 AND (SC),Y             \ If the pixel we want to draw is non-zero (using A as a
 BNE HA6                \ mask), then this means it already contains something,
                        \ so jump to HA6 to stop drawing this line

 TXA                    \ Copy the pixel mask to A again

IF _DISC_DOCKED \ Screen

 ORA (SC),Y             \ OR the byte with the current contents of screen
                        \ memory, so the pixel we want is set

ELIF _6502SP_VERSION

 AND #RED               \ Apply the pixel mask in A to a four-pixel block of
                        \ red pixels, so we now know which bits to set in screen
                        \ memory

 ORA (SC),Y             \ OR the byte with the current contents of screen
                        \ memory, so the pixel we want is set to red (because
                        \ we know the bits are already 0 from the above test)

ENDIF

 STA (SC),Y             \ Store the updated pixel in screen memory

 INY                    \ Increment Y to point to the next row in the character
                        \ block, i.e. the next pixel down

 CPY #8                 \ Loop back to HAL7 to draw this next pixel until we
 BNE HAL7               \ have drawn all 8 in the character block

IF _DISC_DOCKED \ Screen

 INC SC+1               \ Point SC(1 0) to the next page in memory, i.e. the
                        \ next character row

ELIF _6502SP_VERSION

 INC SC+1               \ There are two pages of memory for each character row,
 INC SC+1               \ so we increment the high byte of SC(1 0) twice to
                        \ point to the same character but in the next row down

ENDIF

 LDY #0                 \ Set Y = 0 to point to the first row in this character
                        \ block

 BEQ HAL7               \ Loop back up to HAL7 to keep drawing the line (this
                        \ BEQ is effectively a JMP as Y is always zero)

.HA6

IF _DISC_DOCKED \ Screen

 LDA XSAV               \ Fetch the x-coordinate of the line we just drew from
 CLC                    \ XSAV into A, and add 16 so that A contains the
 ADC #16                \ x-coordinate of the next line to draw

ELIF _6502SP_VERSION

 LDA T                  \ Fetch the x-coordinate of the line we just drew from T
 CLC                    \ into A, and add 16 so that A contains the x-coordinate
 ADC #16                \ of the next line to draw

 BCC P%+4               \ If the addition overflowed, increment the page number
 INC R                  \ in R to point to the second half of the screen row

 DEC S                  \ Decrement the loop counter in S

ENDIF

 BNE HAL6               \ Loop back to HAL6 until we have run through the loop
                        \ 60 times, by which point we are most definitely done

IF _6502SP_VERSION \ Label

.HA3

ENDIF

 RTS                    \ Return from the subroutine

