\ ******************************************************************************
\
\       Name: LOIN (Part 7 of 7)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a steep line going up and right or down and left
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a line from (X1, Y1) to (X2, Y2). It has multiple stages.
\ If we get here, then:
\
\   * The line is going up and right (no swap) or down and left (swap)
\
\   * X1 >= X2 and Y1 >= Y2
\
\   * Draw from (X1, Y1) at bottom left to (X2, Y2) at top right
\
\ ******************************************************************************

.LFT

IF _CASSETTE_VERSION

 LDA SWAP               \ If SWAP = 0 then we didn't swap the coordinates above,
 BEQ LI18               \ jump down to LI18 to skip plotting the first pixel

 DEX                    \ Decrement the counter in X because we're about to plot
                        \ the first pixel

.LIL6

 LDA R                  \ Fetch the pixel byte from R

 EOR (SC),Y             \ Store R into screen memory at SC(1 0), using EOR
 STA (SC),Y             \ logic so it merges with whatever is already on-screen

.LI18

 DEY                    \ Decrement Y to step up along the y-axis

 BPL LI19               \ If Y is positive we are still within the same
                        \ character block, so skip to LI19

 DEC SCH                \ Otherwise we need to move up into the character block
 LDY #7                 \ above, so decrement the high byte of the screen
                        \ address and set the pixel line to the last line in
                        \ that character block

.LI19

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCC LIC6               \ If the addition didn't overflow, jump to LIC6

 ASL R                  \ Otherwise we just overflowed, so shift the single
                        \ pixel in R to the left, so the next pixel we plot
                        \ will be at the previous x-coordinate

 BCC LIC6               \ If the pixel didn't fall out of the left end of R
                        \ into the C flag, then jump to LIC6

 ROL R                  \ Otherwise we need to move over to the next character
                        \ block, so first rotate R left so the set C flag goes
                        \ back into the right end, giving %0000001

 LDA SC                 \ Subtract 7 from SC, so SC(1 0) now points to the
 SBC #7                 \ previous character along to the left
 STA SC

 CLC

.LIC6

 DEX                    \ Decrement the counter in X

 BNE LIL6               \ If we haven't yet reached the left end of the line,
                        \ loop back to LIL6 to plot the next pixel along

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

.HL6

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION

 LDA SWAP
 BEQ LI291
 TYA
 AND #7
 TAY
 BNE P%+5
 JMP LI407+8
 CPY #2
 BCS P%+5
 JMP LI406+8
 CLC
 BNE P%+5
 JMP LI405+8
 CPY #4
 BCS P%+5
 JMP LI404+8
 CLC
 BNE P%+5
 JMP LI403+8
 CPY #6
 BCS P%+5
 JMP LI402+8
 CLC
 BEQ P%+5
 JMP LI400+8
 JMP LI401+8

.LI291

 DEX
 TYA
 AND #7
 TAY
 BNE P%+5
 JMP LI407
 CPY #2
 BCS P%+5
 JMP LI406
 CLC
 BNE P%+5
 JMP LI405
 CPY #4
 BCC LI404S
 CLC
 BEQ LI403S
 CPY #6
 BCC LI402S
 CLC
 BEQ LI401S
 JMP LI400

.LI410

 ASL R
 BCC LI401

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC

.LI401S

 BCC LI401

.LI411

 ASL R
 BCC LI402

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC

.LI402S

 BCC LI402

.LI412

 ASL R
 BCC LI403

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC

.LI403S

 BCC LI403

.LI413

 ASL R
 BCC LI404

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC

.LI404S

 BCC LI404

.LIEX5

 RTS

.LI400

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX5
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI410

.LI401

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX5
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI411

.LI402

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX5
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI412

.LI403

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX5
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI413

.LI404

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX6
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI414

.LI405

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX6
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI415

.LI406

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX6
 DEY

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS LI416

.LI407

 LDA R
 AND COL
 EOR (SC),Y
 STA (SC),Y
 DEX
 BEQ LIEX6
 DEC SC+1
 DEC SC+1
 LDY #7

 LDA S                  \ Set S = S + P to update the slope error
 ADC P
 STA S

 BCS P%+5
 JMP LI400
 ASL R
 BCS P%+5
 JMP LI400

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC
 JMP LI400

.LIEX6

 RTS

.LI414

 ASL R
 BCC LI405

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC
 BCC LI405

.LI415

 ASL R
 BCC LI406

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC
 BCC LI406

.LI416

 ASL R
 BCC LI407

 LDA #%00010001         \ Set a mask in R to the fourth pixel in the 4-pixel
 STA R                  \ byte

 LDA SC
 SBC #8
 STA SC
 BCS P%+4
 DEC SC+1
 CLC
 JMP LI407

ENDIF
