\ ******************************************************************************
\
\       Name: LL145 (Part 4 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Call the routine in LL188 to do the actual clipping
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ------------------------------------------------------------------------------
\
\ This part sets things up to call the routine in LL188, which does the actual
\ clipping.
\
\ If we get here, then R has been set to the gradient of the line (x1, y1) to
\ (x2, y2), with T indicating the gradient of slope:
\
\   * 0   = shallow slope (more horizontal than vertical)
\
\   * &FF = steep slope (more vertical than horizontal)
\
\ and XX13 has been set as follows:
\
\   * 0   = (x1, y1) off-screen, (x2, y2) on-screen
\
IF NOT(_NES_VERSION)
\   * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\   * 191 = (x1, y1) off-screen, (x2, y2) off-screen
ELIF _NES_VERSION
\   * 127 = (x1, y1) on-screen,  (x2, y2) off-screen
\
\   * 255 = (x1, y1) off-screen, (x2, y2) off-screen
ENDIF
\
\ ******************************************************************************

.LL116

IF NOT(_NES_VERSION)

 LDA R                  \ Store the gradient in XX12+2
 STA XX12+2

ELIF _NES_VERSION

 STA XX12+2             \ Store the gradient in XX12+2 (as the call to LL28 in
                        \ part 3 returns the gradient in both A and R)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA S                  \ Store the type of slope in XX12+3, bit 7 clear means
 STA XX12+3             \ top left to bottom right, bit 7 set means top right to
                        \ bottom left

 LDA XX13               \ If XX13 = 0, skip the following instruction
 BEQ LL138

IF NOT(_NES_VERSION)

 BPL LLX117             \ If XX13 is positive, it must be 95. This means
                        \ (x1, y1) is on-screen but (x2, y2) isn't, so we jump
                        \ to LLX117 to swap the (x1, y1) and (x2, y2)
                        \ coordinates around before doing the actual clipping,
                        \ because we need to clip (x2, y2) but the clipping
                        \ routine at LL118 only clips (x1, y1)

ELIF _NES_VERSION

 BPL LLX117             \ If XX13 is positive, it must be 127. This means
                        \ (x1, y1) is on-screen but (x2, y2) isn't, so we jump
                        \ to LLX117 to swap the (x1, y1) and (x2, y2)
                        \ coordinates around before doing the actual clipping,
                        \ because we need to clip (x2, y2) but the clipping
                        \ routine at LL118 only clips (x1, y1)

ENDIF

.LL138

IF NOT(_NES_VERSION)

                        \ If we get here, XX13 = 0 or 191, so (x1, y1) is
                        \ off-screen and needs clipping

ELIF _NES_VERSION

                        \ If we get here, XX13 = 0 or 255, so (x1, y1) is
                        \ off-screen and needs clipping

ENDIF

 JSR LL118              \ Call LL118 to move (x1, y1) along the line onto the
                        \ screen, i.e. clip the line at the (x1, y1) end

IF NOT(_NES_VERSION)

 LDA XX13               \ If XX13 = 0, i.e. (x2, y2) is on-screen, jump down to
 BPL LL124              \ LL124 to return with a successfully clipped line

ELIF _NES_VERSION

 LDA XX13               \ If XX13 = 255, i.e. (x2, y2) is off-screen, jump down
 BMI LL117              \ down to LL117 to skip the following

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 JMP LL146              \ Jump up to LL146 to move the low bytes of (x1, y1) and
                        \ (x2, y2) into (X1, Y1) and (X2, Y2), and return from
                        \ the subroutine with a successfully clipped line

ENDIF

.LL117

IF NOT(_NES_VERSION)

                        \ If we get here, XX13 = 191 (both coordinates are
                        \ off-screen)

ELIF _NES_VERSION

                        \ If we get here, XX13 = 255 (both coordinates are
                        \ off-screen)

ENDIF

 LDA XX15+1             \ If either of x1_hi or y1_hi are non-zero, jump to
 ORA XX15+3             \ LL137 to return from the subroutine with the C flag
 BNE LL137              \ set, as the line doesn't fit on-screen

IF NOT(_NES_VERSION)

 LDA XX15+2             \ If y1_lo > y-coordinate of the bottom of the screen
 CMP #Y*2               \ jump to LL137 to return from the subroutine with the
 BCS LL137              \ C flag set, as the line doesn't fit on-screen

ELIF _NES_VERSION

 LDA XX15+2             \ If y1_lo > y-coordinate of the bottom of the screen
 CMP screenHeight       \ (which is in the variable screenHeight), jump to LL137
 BCS LL137              \ to return from the subroutine with the C flag set, as
                        \ the line doesn't fit on-screen

ENDIF

.LLX117

IF NOT(_NES_VERSION)

                        \ If we get here, XX13 = 95 or 191, and in both cases
                        \ (x2, y2) is off-screen, so we now need to swap the
                        \ (x1, y1) and (x2, y2) coordinates around before doing
                        \ the actual clipping, because we need to clip (x2, y2)
                        \ but the clipping routine at LL118 only clips (x1, y1)

ELIF _NES_VERSION

                        \ If we get here, XX13 = 127 or 255, and in both cases
                        \ (x2, y2) is off-screen, so we now need to swap the
                        \ (x1, y1) and (x2, y2) coordinates around before doing
                        \ the actual clipping, because we need to clip (x2, y2)
                        \ but the clipping routine at LL118 only clips (x1, y1)

ENDIF

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

IF _NES_VERSION

 LDA XX15+1             \ If either of x1_hi or y1_hi are non-zero, jump to
 ORA XX15+3             \ LL137 to return from the subroutine with the C flag
 BNE LL137              \ set, as the line doesn't fit on-screen

ENDIF

 DEC SWAP               \ Set SWAP = &FF to indicate that we just clipped the
                        \ line at the (x2, y2) end by swapping the coordinates
                        \ (the DEC does this as we set SWAP to 0 at the start of
                        \ this subroutine)

.LL124

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

IF NOT(_NES_VERSION)

 JMP LL146              \ Jump up to LL146 to move the low bytes of (x1, y1) and
                        \ (x2, y2) into (X1, Y1) and (X2, Y2), and return from
                        \ the subroutine with a successfully clipped line

ELIF _NES_VERSION

                        \ If we get here then we have clipped our line to the
                        \ screen edge (if we had to clip it at all), so we move
                        \ the low bytes from (x1, y1) and (x2, y2) into (X1, Y1)
                        \ and (X2, Y2), remembering that they share locations
                        \ with XX15:
                        \
                        \   X1 = XX15
                        \   Y1 = XX15+1
                        \   X2 = XX15+2
                        \   Y2 = XX15+3
                        \
                        \ X1 already contains x1_lo, so now we do the rest

 LDA XX15+2             \ Set A = y1_lo

 CMP screenHeight       \ If A >= screenHeight then jump down to clip2 to clip
 BCS clip2              \ the coordinate to the screen before jumping back to
                        \ clip1

.clip1

 STA XX15+1             \ Set Y1 (aka XX15+1) = y1_lo

 LDA XX15+4             \ Set X2 (aka XX15+2) = x2_lo
 STA XX15+2

 LDA XX12               \ Set Y2 (aka XX15+3) = y2_lo
 STA XX15+3

 CLC                    \ Clear the C flag as the clipped line fits on-screen

 RTS                    \ Return from the subroutine

.clip2

 LDA Yx2M1              \ Set A = Yx2M1, which contains the height in pixels of
                        \ the space view

 BNE clip1              \ Jump to clip1 to continue setting the clipped line's
                        \ coordinates (this BNE is effectively a JMP as A is
                        \ never zero)

ENDIF

.LL137

 PLA                    \ Restore Y from the stack so it gets preserved through
 TAY                    \ the call to this subroutine

 SEC                    \ Set the C flag to indicate the clipped line does not
                        \ fit on-screen

 RTS                    \ Return from the subroutine

