\ ******************************************************************************
\
\       Name: LOIN (Part 6 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and left or down and right
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
\ ******************************************************************************

IF _CASSETTE_VERSION

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

 DEC SCH                \ Otherwise we need to move up into the character block
 LDY #7                 \ above, so decrement the high byte of the screen
                        \ address and set the pixel line to the last line in
                        \ that character block

.LI16

 LDA S                  \ Set S = S + P
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

.LIC5

 DEX                    \ Decrement the counter in X

 BNE LIL5               \ If we haven't yet reached the right end of the line,
                        \ loop back to LIL5 to plot the next pixel along

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA SWAP
 BEQ LI290
 TYA
 AND #7
 TAY
 BNE P%+5
 JMP LI307+8
 CPY #2
 BCS P%+5
 JMP LI306+8
 CLC
 BNE P%+5
 JMP LI305+8
 CPY #4
 BCS P%+5
 JMP LI304+8
 CLC
 BNE P%+5
 JMP LI303+8
 CPY #6
 BCS P%+5
 JMP LI302+8
 CLC
 BEQ P%+5
 JMP LI300+8
 JMP LI301+8

.LI290

 DEX
 TYA
 AND #7
 TAY
 BNE P%+5
 JMP LI307
 CPY #2
 BCS P%+5
 JMP LI306
 CLC
 BNE P%+5
 JMP LI305
 CPY #4
 BCC LI304S
 CLC
 BEQ LI303S
 CPY #6
 BCC LI302S
 CLC
 BEQ LI301S
 JMP LI300

.LI310

 LSR R
 BCC LI301
 LDA #%10001000         \ Set a mask in A to the first pixel in the 4-pixel byte
 STA R
 LDA SC
 ADC #7
 STA SC
 BCC LI301
 INC SC+1
 CLC

.LI301S

 BCC LI301

.LI311

 LSR R
 BCC LI302
 LDA #%10001000         \ Set a mask in A to the first pixel in the 4-pixel byte
 STA R
 LDA SC
 ADC #7
 STA SC
 BCC LI302
 INC SC+1
 CLC

.LI302S

 BCC LI302

.LI312

 LSR R
 BCC LI303
 LDA #%10001000         \ Set a mask in A to the first pixel in the 4-pixel byte
 STA R
 LDA SC
 ADC #7
 STA SC
 BCC LI303
 INC SC+1
 CLC

.LI303S

 BCC LI303

.LI313

 LSR R
 BCC LI304
 LDA #%10001000         \ Set a mask in A to the first pixel in the 4-pixel byte
 STA R
 LDA SC
 ADC #7
 STA SC
 BCC LI304
 INC SC+1
 CLC

.LI304S

 BCC LI304

.LIEX3

 RTS

.LI300

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX3
 DEY
 LDA S
 ADC P
 STA S
 BCS LI310

.LI301

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX3
 DEY
 LDA S
 ADC P
 STA S
 BCS LI311

.LI302

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX3
 DEY
 LDA S
 ADC P
 STA S
 BCS LI312

.LI303

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX3
 DEY
 LDA S
 ADC P
 STA S
 BCS LI313

.LI304

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX4
 DEY
 LDA S
 ADC P
 STA S
 BCS LI314

.LI305

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX4
 DEY
 LDA S
 ADC P
 STA S
 BCS LI315

.LI306

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX4
 DEY
 LDA S
 ADC P
 STA S
 BCS LI316

.LI307

 LDA R

 AND COL                \ Apply the pixel mask in A to the colour byte in COL

 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX4
 DEC SC+1
 DEC SC+1
 LDY #7
 LDA S
 ADC P
 STA S
 BCS P%+5
 JMP LI300
 LSR R
 BCS P%+5
 JMP LI300

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC
 ADC #7
 STA SC
 BCS P%+5
 JMP LI300
 INC SC+1
 CLC
 JMP LI300

.LIEX4

 RTS

.LI314

 LSR R
 BCC LI305

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC
 ADC #7
 STA SC
 BCC LI305
 INC SC+1
 CLC
 BCC LI305

.LI315

 LSR R
 BCC LI306

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC
 ADC #7
 STA SC
 BCC LI306
 INC SC+1
 CLC
 BCC LI306

.LI316

 LSR R
 BCC LI307

 LDA #%10001000         \ Set a mask in R to the first pixel in the 4-pixel byte
 STA R

 LDA SC
 ADC #7
 STA SC
 BCC LI307
 INC SC+1
 CLC
 BCC LI307

ENDIF
