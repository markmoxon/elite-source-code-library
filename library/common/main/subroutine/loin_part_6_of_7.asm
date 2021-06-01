\ ******************************************************************************
\
\       Name: LOIN (Part 6 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and left or down and right
\  Deep dive: Bresenham's line algorithm
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going up and left (no swap) or down and right (swap)
\
\   * X1 < X2 and Y1 >= Y2
\
\   * Draw from (X1, Y1) at top left to (X2, Y2) at bottom right
\
IF _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ This routine looks complex, but that's because the loop that's used in the
\ cassette and disc versions has been unrolled to speed it up. The algorithm is
\ unchanged, it's just a lot longer.
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 CLC                    \ Clear the C flag

 LDA SWAP               \ If SWAP = 0 then we didn't swap the coordinates above,
 BEQ LI17               \ so jump down to LI17 to skip plotting the first pixel

 DEX                    \ Decrement the counter in X because we're about to plot
                        \ the first pixel

.LIL5

                        \ We now loop along the line from left to right, using X
                        \ as a decreasing counter, and at each count we plot a
                        \ single pixel using the pixel mask in R

 LDA R                  \ Fetch the pixel byte from R

 EOR (SC),Y             \ Store R into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

.LI17

 DEY                    \ Decrement Y to step up along the y-axis

 BPL LI16               \ If Y is positive we are still within the same
                        \ character block, so skip to LI16

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 DEC SCH                \ Otherwise we need to move up into the character block
 LDY #7                 \ above, so decrement the high byte of the screen
                        \ address and set the pixel line to the last line in
                        \ that character block

ELIF _ELECTRON_VERSION

                        \ We now need to move up into the character block above,
                        \ and each character row in screen memory takes up &140
                        \ bytes (&100 for the visible part and &20 for each of
                        \ the blank borders on the side of the screen), so
                        \ that's what we need to subtract from SC(1 0)
                        \
                        \ We also know the C flag is clear, as we cleared it
                        \ above, so we can subtract &13F in order to get the
                        \ correct result

 LDA SC                 \ Set SC(1 0) = SC(1 0) - &140
 SBC #&3F               \
 STA SC                 \ Starting with the low bytes

 LDA SC+1               \ And then subtracting the high bytes
 SBC #&01
 STA SC+1

 LDY #7                 \ Set the pixel line to the last line in that character
                        \ block

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

.LI16

 LDA S                  \ Set S = S + Q to update the slope error
 ADC P
 STA S

 BCC LIC5               \ If the addition didn't overflow, jump to LIC5

 LSR R                  \ Otherwise we just overflowed, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LIC5               \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LIC5

 ROR R                  \ Otherwise we need to move over to the next character
                        \ block, so first rotate R right so the set C flag goes
                        \ back into the left end, giving %10000000

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #8                 \ character along to the right
 STA SC

ENDIF

IF _ELECTRON_VERSION \ Screen

 BCC LIC5               \ If the addition of the low bytes of SC overflowed,
 INC SC+1               \ increment the high byte

 CLC                    \ Clear the C flag

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA \ Screen

.LIC5

 DEX                    \ Decrement the counter in X

 BNE LIL5               \ If we haven't yet reached the right end of the line,
                        \ loop back to LIL5 to plot the next pixel along

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

ELIF _ELITE_A_6502SP_IO

.LIC5

 DEX                    \ Decrement the counter in X

 BNE LIL5               \ If we haven't yet reached the right end of the line,
                        \ loop back to LIL5 to plot the next pixel along

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA SWAP               \ If SWAP = 0 then we didn't swap the coordinates above,
 BEQ LI290              \ so jump down to LI290 to plot the first pixel

 TYA                    \ Fetch bits 0-2 of the y-coordinate, so Y contains the
 AND #7                 \ y-coordinate mod 8
 TAY

 BNE P%+5               \ If Y = 0, jump to LI307+8 to start plotting from the
 JMP LI307+8            \ pixel above the top row of this character block
                        \ (LI307+8 points to the DEX instruction after the
                        \ EOR/STA instructions, so the pixel at row 0 doesn't
                        \ get plotted but we join at the right point to
                        \ decrement X and Y correctly to continue plotting from
                        \ the character row above)

 CPY #2                 \ If Y < 2 (i.e. Y = 1), jump to LI306+8 to start
 BCS P%+5               \ plotting from row 0 of this character block, missing
 JMP LI306+8            \ out row 1

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BNE P%+5               \ If Y = 2, jump to LI305+8 to start plotting from row
 JMP LI305+8            \ 1 of this character block, missing out row 2

 CPY #4                 \ If Y < 4 (i.e. Y = 3), jump to LI304+8 to start
 BCS P%+5               \ plotting from row 2 of this character block, missing
 JMP LI304+8            \ out row 3

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BNE P%+5               \ If Y = 4, jump to LI303+8 to start plotting from row
 JMP LI303+8            \ 3 of this character block, missing out row 4

 CPY #6                 \ If Y < 6 (i.e. Y = 5), jump to LI302+8 to start
 BCS P%+5               \ plotting from row 4 of this character block, missing
 JMP LI302+8            \ out row 5

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BEQ P%+5               \ If Y <> 6 (i.e. Y = 7), jump to LI300+8 to start
 JMP LI300+8            \ plotting from row 6 of this character block, missing
                        \ out row 7

 JMP LI301+8            \ Otherwise Y = 6, so jump to LI301+8 to start plotting
                        \ from row 5 of this character block, missing out row 6

.LI290

 DEX                    \ Decrement the counter in X because we're about to plot
                        \ the first pixel

 TYA                    \ Fetch bits 0-2 of the y-coordinate, so Y contains the
 AND #7                 \ y-coordinate mod 8
 TAY

 BNE P%+5               \ If Y = 0, jump to LI307 to start plotting from row 0
 JMP LI307              \ of this character block

 CPY #2                 \ If Y < 2 (i.e. Y = 1), jump to LI306 to start plotting
 BCS P%+5               \ from row 1 of this character block
 JMP LI306

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BNE P%+5               \ If Y = 2, jump to LI305 to start plotting from row 2
 JMP LI305              \ of this character block

 CPY #4                 \ If Y < 4 (i.e. Y = 3), jump to LI304 (via LI304S) to
 BCC LI304S             \ start plotting from row 3 of this character block

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BEQ LI303S             \ If Y = 4, jump to LI303 (via LI303S) to start plotting
                        \ from row 4 of this character block

 CPY #6                 \ If Y < 6 (i.e. Y = 5), jump to LI302 (via LI302S) to
 BCC LI302S             \ start plotting from row 5 of this character block

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BEQ LI301S             \ If Y = 6, jump to LI301 (via LI301S) to start plotting
                        \ from row 6 of this character block

 JMP LI300              \ Otherwise Y = 7, so jump to LI300 to start plotting
                        \ from row 7 of this character block

.LI310

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI300, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI301              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI301 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI301              \ If the addition didn't overflow, jump to LI301 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

.LI301S

 BCC LI301              \ Jump to LI301 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LI311

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI301, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI302              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI302 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI302              \ If the addition didn't overflow, jump to LI302 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

.LI302S

 BCC LI302              \ Jump to LI302 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LI312

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI302, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI303              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI303 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI303              \ If the addition didn't overflow, jump to LI303 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

.LI303S

 BCC LI303              \ Jump to LI303 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LI313

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI303, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI304              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI304 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI304              \ If the addition didn't overflow, jump to LI304 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

.LI304S

 BCC LI304              \ Jump to LI304 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LIEX3

 RTS                    \ Return from the subroutine

.LI300

                        \ Plot a pixel on row 7 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX3              \ If we have just reached the right end of the line,
                        \ jump to LIEX3 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI310              \ If the addition overflowed, jump to LI310 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI301 below

.LI301

                        \ Plot a pixel on row 6 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX3              \ If we have just reached the right end of the line,
                        \ jump to LIEX3 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI311              \ If the addition overflowed, jump to LI311 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI302 below

.LI302

                        \ Plot a pixel on row 5 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX3              \ If we have just reached the right end of the line,
                        \ jump to LIEX3 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI312              \ If the addition overflowed, jump to LI312 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI303 below

.LI303

                        \ Plot a pixel on row 4 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX3              \ If we have just reached the right end of the line,
                        \ jump to LIEX3 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI313              \ If the addition overflowed, jump to LI313 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI304 below

.LI304

                        \ Plot a pixel on row 3 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX4              \ If we have just reached the right end of the line,
                        \ jump to LIEX4 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI314              \ If the addition overflowed, jump to LI314 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI305 below

.LI305

                        \ Plot a pixel on row 2 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX4              \ If we have just reached the right end of the line,
                        \ jump to LIEX4 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI315              \ If the addition overflowed, jump to LI315 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI306 below

.LI306

                        \ Plot a pixel on row 1 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX4              \ If we have just reached the right end of the line,
                        \ jump to LIEX4 to return from the subroutine

 DEY                    \ Decrement Y to step up along the y-axis

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI316              \ If the addition overflowed, jump to LI316 to move to
                        \ the pixel in the next character block along, which
                        \ returns us to LI307 below

.LI307

                        \ Plot a pixel on row 0 of this character block

 LDA R                  \ Fetch the pixel byte from R and apply the colour in
 AND COL                \ COL to it

 EOR (SC),Y             \ Store A into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

 DEX                    \ Decrement the counter in X

 BEQ LIEX4              \ If we have just reached the right end of the line,
                        \ jump to LIEX4 to return from the subroutine

 DEC SC+1               \ We just reached the top of the character block, so
 DEC SC+1               \ decrement the high byte in SC(1 0) twice to point to
 LDY #7                 \ the screen row above (as there are two pages per
                        \ screen row) and set Y to point to the last row in the
                        \ new character block

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS P%+5               \ If the addition didn't overflow, jump to LI300 to
 JMP LI300              \ continue plotting in the next character block along

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI307 above, so shift the
                        \ single pixel in R to the right, so the next pixel we
                        \ plot will be at the next x-coordinate

 BCS P%+5               \ If the pixel didn't fall out of the right end of R
 JMP LI300              \ into the C flag, then jump to LI400 to continue
                        \ plotting in the next character block along

 LDA #%10001000         \ Otherwise we need to move over to the next character
 STA R                  \ along, so set a mask in R to the first pixel in the
                        \ 4-pixel byte

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ took the above BCS, so the ADC adds 8)

 BCS P%+5               \ If the addition didn't overflow, ump to LI300 to
 JMP LI300              \ continue plotting in the next character block along

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 JMP LI300              \ Jump to LI300 to continue plotting in the next
                        \ character block along

.LIEX4

 RTS                    \ Return from the subroutine

.LI314

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI304, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI305              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI305 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI305              \ If the addition didn't overflow, jump to LI305 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BCC LI305              \ Jump to LI305 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LI315

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI305, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI306              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI306 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI306              \ If the addition didn't overflow, jump to LI306 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BCC LI306              \ Jump to LI306 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

.LI316

 LSR R                  \ If we get here then the slope error just overflowed
                        \ after plotting the pixel in LI306, so shift the single
                        \ pixel in R to the right, so the next pixel we plot
                        \ will be at the next x-coordinate along

 BCC LI307              \ If the pixel didn't fall out of the right end of R
                        \ into the C flag, then jump to LI307 to plot the pixel
                        \ on the next character row up

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC                 \ Add 8 to SC, so SC(1 0) now points to the next
 ADC #7                 \ character along to the right (the C flag is set as we
 STA SC                 \ didn't take the above BCC, so the ADC adds 8)

 BCC LI307              \ If the addition didn't overflow, jump to LI307 to plot
                        \ the pixel on the next character row up

 INC SC+1               \ The addition overflowed, so increment the high byte in
                        \ SC(1 0) to move to the next page in screen memory

 CLC                    \ Clear the C flag so it doesn't affect the arithmetic
                        \ below

 BCC LI307              \ Jump to LI307 to rejoin the pixel plotting routine
                        \ (this BCC is effectively a JMP as the C flag is clear)

ENDIF

