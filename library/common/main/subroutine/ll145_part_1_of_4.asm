\ ******************************************************************************
\
\       Name: LL145 (Part 1 of 4)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Clip line: Work out which end-points are on-screen, if any
\  Deep dive: Line-clipping
\             Extended screen coordinates
\
\ ------------------------------------------------------------------------------
\
\ This routine clips the line from (x1, y1) to (x2, y2) so it fits on-screen, or
\ returns an error if it can't be clipped to fit. The arguments are 16-bit
\ coordinates, and the clipped line is returned using 8-bit screen coordinates.
\
\ This part sets XX13 to reflect which of the two points are on-screen and
\ off-screen.
\
\ Arguments:
\
\   XX15(1 0)           x1 as a 16-bit coordinate (x1_hi x1_lo)
\
\   XX15(3 2)           y1 as a 16-bit coordinate (y1_hi y1_lo)
\
\   XX15(5 4)           x2 as a 16-bit coordinate (x2_hi x2_lo)
\
\   XX12(1 0)           y2 as a 16-bit coordinate (y2_hi y2_lo)
\
\ Returns:
\
\   (X1, Y1)            Screen coordinate of the start of the clipped line
\
\   (X2, Y2)            Screen coordinate of the end of the clipped line
\
\   C flag              Clear if the clipped line fits on-screen, set if it
\                       doesn't
\
\   XX13                The state of the original coordinates on-screen:
\
\                         * 0   = (x2, y2) on-screen
\
\                         * 95  = (x1, y1) on-screen,  (x2, y2) off-screen
\
\                         * 191 = (x1, y1) off-screen, (x2, y2) off-screen
\
\                       So XX13 is non-zero if the end of the line was clipped,
\                       meaning the next line sent to BLINE can't join onto the
\                       end but has to start a new segment
\
\   SWAP                The swap status of the returned coordinates:
\
\                         * &FF if we swapped the values of (x1, y1) and
\                           (x2, y2) as part of the clipping process
\
\                         * 0 if the coordinates are still in the same order
\
\   Y                   Y is preserved
\
\ Other entry points:
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   LL147               Don't initialise the values in SWAP or A
ELIF _MASTER_VERSION OR _NES_VERSION
\   CLIP                Another name for LL145
\
\   CLIP2               Don't initialise the values in SWAP or A
ENDIF
\
\ ******************************************************************************

.LL145

IF _MASTER_VERSION OR _NES_VERSION \ Label

.CLIP

ENDIF

 LDA #0                 \ Set SWAP = 0
 STA SWAP

 LDA XX15+5             \ Set A = x2_hi

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Label

.LL147

ELIF _MASTER_VERSION OR _NES_VERSION

.CLIP2

ENDIF

IF NOT(_NES_VERSION)

 LDX #Y*2-1             \ Set X = #Y * 2 - 1. The constant #Y is 96, the
                        \ y-coordinate of the mid-point of the space view, so
                        \ this sets Y2 to 191, the y-coordinate of the bottom
                        \ pixel row of the space view

 ORA XX12+1             \ If one or both of x2_hi and y2_hi are non-zero, jump
 BNE LL107              \ to LL107 to skip the following, leaving X at 191

 CPX XX12               \ If y2_lo > the y-coordinate of the bottom of screen
 BCC LL107              \ then (x2, y2) is off the bottom of the screen, so skip
                        \ the following instruction, leaving X at 191

ELIF _NES_VERSION

 LDX #255               \ Set X = 255, the highest y-coordinate possible, beyond
                        \ the bottom of the screen

 ORA XX12+1             \ If one or both of x2_hi and y2_hi are non-zero, jump
 BNE LL107              \ to LL107 to skip the following, leaving X at 255

 LDA Yx2M1              \ If y2_lo > the y-coordinate of the bottom of screen
 CMP XX12               \ (which is in the variable Yx2M1), then (x2, y2) is off
 BCC LL107              \ the bottom of the screen, so skip the following
                        \ instruction, leaving X at 255

ENDIF

 LDX #0                 \ Set X = 0

.LL107

 STX XX13               \ Set XX13 = X, so we have:
                        \
                        \   * XX13 = 0 if x2_hi = y2_hi = 0, y2_lo is on-screen
                        \
                        \   * XX13 = 191 if x2_hi or y2_hi are non-zero or y2_lo
                        \            is off the bottom of the screen
                        \
                        \ In other words, XX13 is 191 if (x2, y2) is off-screen,
                        \ otherwise it is 0

 LDA XX15+1             \ If one or both of x1_hi and y1_hi are non-zero, jump
 ORA XX15+3             \ jump to LL83
 BNE LL83

IF NOT(_NES_VERSION)

 LDA #Y*2-1             \ If y1_lo > the y-coordinate of the bottom of screen
 CMP XX15+2             \ then (x1, y1) is off the bottom of the screen, so jump
 BCC LL83               \ to LL83

ELIF _NES_VERSION

 LDA Yx2M1              \ If y1_lo > the y-coordinate of the bottom of screen
 CMP XX15+2             \ (which is in the variable Yx2M1),  then (x1, y1) is
 BCC LL83               \ off the bottom of the screen, so jump to LL83

ENDIF

                        \ If we get here, (x1, y1) is on-screen

 LDA XX13               \ If XX13 is non-zero, i.e. (x2, y2) is off-screen, jump
 BNE LL108              \ to LL108 to halve it before continuing at LL83

                        \ If we get here, the high bytes are all zero, which
                        \ means the x-coordinates are < 256 and therefore fit on
                        \ screen, and neither coordinate is off the bottom of
                        \ the screen. That means both coordinates are already on
                        \ screen, so we don't need to do any clipping, all we
                        \ need to do is move the low bytes into (X1, Y1) and
                        \ X2, Y2) and return

.LL146

                        \ If we get here then we have clipped our line to the
                        \ (if we had to clip it at all), so we move the low
                        \ bytes from (x1, y1) and (x2, y2) into (X1, Y1) and
                        \ (X2, Y2), remembering that they share locations with
                        \ XX15:
                        \
                        \   X1 = XX15
                        \   Y1 = XX15+1
                        \   X2 = XX15+2
                        \   Y2 = XX15+3
                        \
                        \ X1 already contains x1_lo, so now we do the rest

 LDA XX15+2             \ Set Y1 (aka XX15+1) = y1_lo
 STA XX15+1

 LDA XX15+4             \ Set X2 (aka XX15+2) = x2_lo
 STA XX15+2

 LDA XX12               \ Set Y2 (aka XX15+3) = y2_lo
 STA XX15+3

IF _6502SP_VERSION \ Platform

 LDA SWAP               \ If SWAP = 0, then we didn't have to swap the line
 BEQ noswap             \ coordinates around during the clipping process, so
                        \ jump to noswap to skip the following swap

 LDA X1                 \ Otherwise the coordinates were swapped above,
 LDY X2                 \ so we swap (X1, Y1) and (X2, Y2) back again
 STA X2
 STY X1
 LDA Y1
 LDY Y2
 STA Y2
 STY Y1

.noswap

ENDIF

 CLC                    \ Clear the C flag as the clipped line fits on-screen

 RTS                    \ Return from the subroutine

.LL109

 SEC                    \ Set the C flag to indicate the clipped line does not
                        \ fit on-screen

 RTS                    \ Return from the subroutine

.LL108

 LSR XX13               \ If we get here then (x2, y2) is off-screen and XX13 is
                        \ 191, so shift XX13 right to halve it to 95

