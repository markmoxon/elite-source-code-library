\ ******************************************************************************
\
\       Name: LL145 (Part 4 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Call the routine in LL188 to do the actual clipping
\
\ ------------------------------------------------------------------------------
\
\ This part sets things up to call the routine in LL188, which does the actual
\ clipping.
\
\ If we get here, then R has been set to the gradient of the line (x1, y1) to
\ (x2, y2), with T indicating the type of slope:
\
\   * 0   = it's more vertical than horizontal
\
\   * &FF = it's more horizontal than vertical
\
\ and XX13 has been set as follows:
\
\   * 0   = (x1, y1) off-screen, (x2, y2) on-screen
\
\   * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\   * 191 = (x1, y1) off-screen, (x2, y2) off-screen
\
\ ******************************************************************************

.LL116

 LDA R                  \ Store the gradient in XX12+2
 STA XX12+2

 LDA S                  \ Store the type of slope in XX12+3, bit 7 clear means
 STA XX12+3             \ top left to bottom right, bit 7 set means top right to
                        \ bottom left

 LDA XX13               \ If XX13 = 0, skip the following instruction
 BEQ LL138

 BPL LLX117             \ If XX13 is positive, it must be 95. This means
                        \ (x1, y1) is on-screen but (x2, y2) isn't, so we jump
                        \ to LLX117 to swap the (x1, y1) and (x2, y2)
                        \ coordinates around before doing the actual clipping,
                        \ because we need to clip (x2, y2) but the clipping
                        \ routine at LL118 only clips (x1, y1)

.LL138

                        \ If we get here, XX13 = 0 or 191, so (x1, y1) is
                        \ off-screen and needs clipping

 JSR LL118              \ Call LL118 to move (x1, y1) along the line onto the
                        \ screen, i.e. clip the line at the (x1, y1) end

 LDA XX13               \ If XX13 = 0, i.e. (x2, y2) is on-screen, jump down to
 BPL LL124              \ LL124 to return with a successfully clipped line

.LL117

                        \ If we get here, XX13 = 191 (both coordinates are
                        \ off-screen)

 LDA XX15+1             \ If either of x1_hi or y1_hi are non-zero, jump to
 ORA XX15+3             \ LL137 to return from the subroutine with the C flag
 BNE LL137              \ set, as the line doesn't fit on-screen

 LDA XX15+2             \ If y1_lo > y-coordinate of the bottom of the screen
 CMP #Y*2               \ jump to LL137 to return from the subroutine with the
 BCS LL137              \ C flag set, as the line doesn't fit on-screen

.LLX117

                        \ If we get here, XX13 = 95 or 191, and in both cases
                        \ (x2, y2) is off-screen, so we now need to swap the
                        \ (x1, y1) and (x2, y2) coordinates around before doing
                        \ the actual clipping, because we need to clip (x2, y2)
                        \ but the clipping routine at LL118 only clips (x1, y1)

 LDX XX15               \ Swap x1_lo = x2_lo
 LDA XX15+4
 STA XX15
 STX XX15+4

 LDA XX15+5             \ Swap x2_lo = x1_lo
 LDX XX15+1
 STX XX15+5
 STA XX15+1

 LDX XX15+2             \ Swap y1_lo = y2_lo
 LDA XX12
 STA XX15+2
 STX XX12

 LDA XX12+1             \ Swap y2_lo = y1_lo
 LDX XX15+3
 STX XX12+1
 STA XX15+3

 JSR LL118              \ Call LL118 to move (x1, y1) along the line onto the
                        \ screen, i.e. clip the line at the (x1, y1) end

 DEC SWAP               \ Set SWAP = &FF to indicate that we just clipped the
                        \ line at the (x2, y2) end by swapping the coordinates
                        \ (the DEC does this as we set SWAP to 0 at the start of
                        \ this subroutine)

.LL124

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 JMP LL146              \ Jump up to LL146 to move the low bytes of (x1, y1) and
                        \ (x2, y2) into (X1, Y1) and (X2, Y2), and return from
                        \ the subroutine with a successfully clipped line

.LL137

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 SEC                    \ Set the C flag to indicate the clipped line does not
                        \ fit on-screen

 RTS                    \ Return from the subroutine

