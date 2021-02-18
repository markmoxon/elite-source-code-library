\ ******************************************************************************
\
\       Name: LL145 (Part 3 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Calculate the line's gradient
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ******************************************************************************

.LL115

 TYA                    \ Store Y on the stack so we can preserve it through the
 PHA                    \ call to this subroutine

 LDA XX15+4             \ Set XX12+2 = x2_lo - x1_lo
 SEC
 SBC XX15
 STA XX12+2

 LDA XX15+5             \ Set XX12+3 = x2_hi - x1_hi
 SBC XX15+1
 STA XX12+3

 LDA XX12               \ Set XX12+4 = y2_lo - y1_lo
 SEC
 SBC XX15+2
 STA XX12+4

 LDA XX12+1             \ Set XX12+5 = y2_hi - y1_hi
 SBC XX15+3
 STA XX12+5

                        \ So we now have:
                        \
                        \   delta_x in XX12(3 2)
                        \   delta_y in XX12(5 4)
                        \
                        \ where the delta is (x1, y1) - (x2, y2))

 EOR XX12+3             \ Set S = the sign of delta_x * the sign of delta_y, so
 STA S                  \ if bit 7 of S is set, the deltas have different signs

 LDA XX12+5             \ If delta_y_hi is positive, jump down to LL110 to skip
 BPL LL110              \ the following

 LDA #0                 \ Otherwise flip the sign of delta_y to make it
 SEC                    \ positive, starting with the low bytes
 SBC XX12+4
 STA XX12+4

 LDA #0                 \ And then doing the high bytes, so now:
 SBC XX12+5             \
 STA XX12+5             \   XX12(5 4) = |delta_y|

.LL110

 LDA XX12+3             \ If delta_x_hi is positive, jump down to LL111 to skip
 BPL LL111              \ the following

 SEC                    \ Otherwise flip the sign of delta_x to make it
 LDA #0                 \ positive, starting with the low bytes
 SBC XX12+2
 STA XX12+2

 LDA #0                 \ And then doing the high bytes, so now:
 SBC XX12+3             \
                        \   (A XX12+2) = |delta_x|

.LL111

                        \ We now keep halving |delta_x| and |delta_y| until
                        \ both of them have zero in their high bytes

 TAX                    \ IF |delta_x_hi| is non-zero, skip the following
 BNE LL112

 LDX XX12+5             \ If |delta_y_hi| = 0, jump down to LL113 (as both
 BEQ LL113              \ |delta_x_hi| and |delta_y_hi| are 0)

.LL112

 LSR A                  \ Halve the value of delta_x in (A XX12+2)
 ROR XX12+2

 LSR XX12+5             \ Halve the value of delta_y XX12(5 4)
 ROR XX12+4

 JMP LL111              \ Loop back to LL111

.LL113

                        \ By now, the high bytes of both |delta_x| and |delta_y|
                        \ are zero

 STX T                  \ We know that X = 0 as that's what we tested with a BEQ
                        \ above, so this sets T = 0

 LDA XX12+2             \ If delta_x_lo < delta_y_lo, so our line is more
 CMP XX12+4             \ vertical than horizontal, jump to LL114
 BCC LL114

 STA Q                  \ Set Q = delta_x_lo

 LDA XX12+4             \ Set A = delta_y_lo

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * delta_y_lo / delta_x_lo

 JMP LL116              \ Jump to LL116, as we now have the line's gradient in R

.LL114

 LDA XX12+4             \ Set Q = delta_y_lo
 STA Q
 LDA XX12+2             \ Set A = delta_x_lo

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * delta_x_lo / delta_y_lo

 DEC T                  \ T was set to 0 above, so this sets T = &FF

