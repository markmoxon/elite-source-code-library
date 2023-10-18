\ ******************************************************************************
\
\       Name: DrawPitchRollBars
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the pitch and roll bars on the dashboard
\
\ ------------------------------------------------------------------------------
\
\ The roll indicator uses sprite 11 and the pitch indicator uses sprite 12.
\
\ ******************************************************************************

.DrawPitchRollBars

                        \ We start by drawing the roll indicator

 LDA JSTX               \ Set SC2 = 216 + ~JSTX / 8
 EOR #&FF               \         = 216 - (JSTX + 1) / 8
 LSR A                  \
 LSR A                  \ We use this as the x-coordinate of the roll indicator
 LSR A                  \ as the centre of the indicator is at x-coordinate 232
 CLC                    \ and JSTX / 8 is in the range 0 to 31, with a value of
 ADC #216               \ 16 in the middle of the indicator, so SC2 is in the
 STA SC2                \ range 216 to 247 with a middle point of 231 (this
                        \ isn't 232 because of the + 1 in the calculation above)

 LDY #29                \ Set Y = 29 so we draw the indicator sprite on pixel
                        \ y-coordinate 170 + 29 = 199 (which is the y-coordinate
                        \ of the roll indicator)

 LDA #11                \ Set A = 11 so we draw the indicator using sprite 11

 JSR piro1              \ Call piro1 below to draw the roll indicator

                        \ We now draw the pitch indicator

 LDA JSTY               \ Set SC2 = 216 + JSTY / 8
 LSR A                  \
 LSR A                  \ We use this as the x-coordinate of the pitch indicator
 LSR A                  \ as the centre of the indicator is at x-coordinate 232
 CLC                    \ and JSTY / 8 is in the range 0 to 31, with a value of
 ADC #216               \ 16 in the middle of the indicator, so SC2 is in the
 STA SC2                \ range 216 to 247 with a middle point of 232

 LDY #37                \ Set Y = 37 so we draw the indicator sprite on pixel
                        \ y-coordinate 170 + 37 = 207 (which is the y-coordinate
                        \ of the pitch indicator)

 LDA #12                \ Set A = 11 so we draw the indicator using sprite 12

.piro1

 ASL A                  \ Set X = A * 4
 ASL A                  \
 TAX                    \ So we can use X as an index into the sprite buffer to
                        \ update the sprite data for sprite A (as each sprite
                        \ has four bytes in the buffer)

 LDA SC2                \ Set the x-coordinate of the relevant indicator's
 SEC                    \ sprite to SC2 - 4, so the centre of the eight-pixel
 SBC #4                 \ wide sprite is on x-coordinate SC2
 STA xSprite0,X

 TYA                    \ Set the y-coordinate of the relevant indicator's
 CLC                    \ sprite to 170 + Y, so it appears on the correct row
 ADC #170+YPAL
 STA ySprite0,X

 RTS                    \ Return from the subroutine

