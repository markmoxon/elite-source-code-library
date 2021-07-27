\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: Display the ship hanger by sending picture_h and picture_v
\             commands to the I/O processor
\
\ ******************************************************************************

.HANGER

                        \ We start by drawing the floor

 LDX #2                 \ We start with a loop using a counter in T that goes
                        \ from 2 to 12, one for each of the 11 horizontal lines
                        \ in the floor, so set the initial value in X

.HAL1

 STX XSAV               \ Store the loop counter in XSAV

 LDA #130               \ Set A = 130

 LDX XSAV               \ Retrieve the loop counter from XSAV

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

 LDA #&9A               \ Send command &9A to the I/O processor:
 JSR tube_write         \
                        \   picture_h(line_count, multiple_ships)
                        \
                        \ which will draw the specified number of horizontal
                        \ lines as the hanger floor, drawing lines between
                        \ multiple ships if required

 LDA P                  \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * line_count = P

 LDA YSAV               \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * multiple_ships = YSAV

 LDX XSAV               \ Fetch the loop counter from XSAV and increment it
 INX

 CPX #13                \ If the loop counter is less than 13 (i.e. T = 2 to 12)
 BCC HAL1               \ then loop back to HAL1 to draw the next line

                        \ The floor is done, so now we move on to the back wall

 LDA #16                \ We want to draw 15 vertical lines, one every 16 pixels
                        \ across the screen, with the first at x-coordinate 16,
                        \ so set this in A to act as the x-coordinate of each
                        \ line as we work our way through them from left to
                        \ right, incrementing by 16 for each new line

.HAL6

 STA XSAV               \ Store this value in XSAV, so we can retrieve it later

 LDA #&9B               \ Send command &9B to the I/O processor:
 JSR tube_write         \
                        \   picture_v(line_count)
                        \
                        \ which will draw the specified number of vertical
                        \ lines as the back wall of the hanger

 LDA XSAV               \ Send the parameter to the I/O processor:
 JSR tube_write         \
                        \   * line_count = XSAV

 LDA XSAV               \ Fetch the x-coordinate of the line we just drew from
 CLC                    \ XSAV into A, and add 16 so that A contains the
 ADC #16                \ x-coordinate of the next line to draw

 BNE HAL6               \ Loop back to HAL6 until we have run through the loop
                        \ 60 times, by which point we are most definitely done

 RTS                    \ Return from the subroutine

