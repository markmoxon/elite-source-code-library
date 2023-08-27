\ ******************************************************************************
\
\       Name: LL118
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Move a point along a line until it is on-screen
\  Deep dive: Line-clipping
\
\ ------------------------------------------------------------------------------
\
\ Given a point (x1, y1), a gradient and a direction of slope, move the point
\ along the line until it is on-screen, so this effectively clips the (x1, y1)
\ end of a line to be on the screen.
\
\ See the deep dive on "Line-clipping" for more details.
\
\ Arguments:
\
\   XX15(1 0)           x1 as a 16-bit coordinate (x1_hi x1_lo)
\
\   XX15(3 2)           y1 as a 16-bit coordinate (y1_hi y1_lo)
\
\   XX12+2              The line's gradient * 256 (so 1.0 = 256)
\
\   XX12+3              The direction of slope:
\
\                         * Positive (bit 7 clear) = top left to bottom right
\
\                         * Negative (bit 7 set) = top right to bottom left
\
\   T                   The gradient of slope:
\
\                         * 0 if it's a shallow slope
\
\                         * &FF if it's a steep slope
\
\ Returns:
\
\   XX15                x1 as an 8-bit coordinate
\
\   XX15+2              y1 as an 8-bit coordinate
\
\ Other entry points:
\
\   LL118-1             Contains an RTS
\
\ ******************************************************************************

.LL118

IF NOT(_NES_VERSION)

 LDA XX15+1             \ If x1_hi is positive, jump down to LL119 to skip the
 BPL LL119              \ following

 STA S                  \ Otherwise x1_hi is negative, i.e. off the left of the
                        \ screen, so set S = x1_hi

ELIF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA XX15+1             \ Set S = x1_hi
 STA S

 BPL LL119              \ If x1_hi is positive, jump down to LL119 to skip the
                        \ following

ENDIF

 JSR LL120              \ Call LL120 to calculate:
                        \
                        \   (Y X) = (S x1_lo) * XX12+2      if T = 0
                        \         = x1 * gradient
                        \
                        \   (Y X) = (S x1_lo) / XX12+2      if T <> 0
                        \         = x1 / gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set y1 = y1 + (Y X)
 CLC                    \
 ADC XX15+2             \ starting with the low bytes
 STA XX15+2

 TYA                    \ And then adding the high bytes
 ADC XX15+3
 STA XX15+3

 LDA #0                 \ Set x1 = 0
 STA XX15
 STA XX15+1

 TAX                    \ Set X = 0 so the next instruction becomes a JMP

IF _NES_VERSION

 BEQ LL134S             \ If x1_hi = 0 then jump down to LL134S to skip the
                        \ following, as the x-coordinate is already on-screen
                        \ (as 0 <= (x_hi x_lo) <= 255)

ENDIF

.LL119

 BEQ LL134              \ If x1_hi = 0 then jump down to LL134 to skip the
                        \ following, as the x-coordinate is already on-screen
                        \ (as 0 <= (x_hi x_lo) <= 255)

IF NOT(_NES_VERSION)

 STA S                  \ Otherwise x1_hi is positive, i.e. x1 >= 256 and off
 DEC S                  \ the right side of the screen, so set S = x1_hi - 1

ELIF _NES_VERSION

 DEC S                  \ Otherwise x1_hi is positive, i.e. x1 >= 256 and off
                        \ the right side of the screen, so set:
                        \
                        \   S = S - 1
                        \     = x1_hi - 1

ENDIF

 JSR LL120              \ Call LL120 to calculate:
                        \
                        \   (Y X) = (S x1_lo) * XX12+2      if T = 0
                        \         = (x1 - 256) * gradient
                        \
                        \   (Y X) = (S x1_lo) / XX12+2      if T <> 0
                        \         = (x1 - 256) / gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set y1 = y1 + (Y X)
 CLC                    \
 ADC XX15+2             \ starting with the low bytes
 STA XX15+2

 TYA                    \ And then adding the high bytes
 ADC XX15+3
 STA XX15+3

 LDX #255               \ Set x1 = 255
 STX XX15
 INX
 STX XX15+1

IF _NES_VERSION

.LL134S

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

.LL134

                        \ We have moved the point so the x-coordinate is on
                        \ screen (i.e. in the range 0-255), so now for the
                        \ y-coordinate

 LDA XX15+3             \ If y1_hi is positive, jump down to LL119 to skip
 BPL LL135              \ the following

 STA S                  \ Otherwise y1_hi is negative, i.e. off the top of the
                        \ screen, so set S = y1_hi

 LDA XX15+2             \ Set R = y1_lo
 STA R

 JSR LL123              \ Call LL123 to calculate:
                        \
                        \   (Y X) = (S R) / XX12+2      if T = 0
                        \         = y1 / gradient
                        \
                        \   (Y X) = (S R) * XX12+2      if T <> 0
                        \         = y1 * gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set x1 = x1 + (Y X)
 CLC                    \
 ADC XX15               \ starting with the low bytes
 STA XX15

 TYA                    \ And then adding the high bytes
 ADC XX15+1
 STA XX15+1

 LDA #0                 \ Set y1 = 0
 STA XX15+2
 STA XX15+3

.LL135

IF _CASSETTE_VERSION OR _MASTER_VERSION OR _6502SP_VERSION \ Comment

\BNE LL139              \ This instruction is commented out in the original
                        \ source

ENDIF

IF NOT(_NES_VERSION)

 LDA XX15+2             \ Set (S R) = (y1_hi y1_lo) - screen height
 SEC                    \
 SBC #Y*2               \ starting with the low bytes
 STA R

ELIF _NES_VERSION

 LDA XX15+2             \ Set (S R) = (y1_hi y1_lo) - screen height
 SEC                    \
 SBC screenHeight       \ starting with the low bytes
 STA R

ENDIF

 LDA XX15+3             \ And then subtracting the high bytes
 SBC #0
 STA S

 BCC LL136              \ If the subtraction underflowed, i.e. if y1 < screen
                        \ height, then y1 is already on-screen, so jump to LL136
                        \ to return from the subroutine, as we are done

.LL139

                        \ If we get here then y1 >= screen height, i.e. off the
                        \ bottom of the screen

 JSR LL123              \ Call LL123 to calculate:
                        \
                        \   (Y X) = (S R) / XX12+2      if T = 0
                        \         = (y1 - screen height) / gradient
                        \
                        \   (Y X) = (S R) * XX12+2      if T <> 0
                        \         = (y1 - screen height) * gradient
                        \
                        \ with the sign of (Y X) set to the opposite of the
                        \ line's direction of slope

 TXA                    \ Set x1 = x1 + (Y X)
 CLC                    \
 ADC XX15               \ starting with the low bytes
 STA XX15

 TYA                    \ And then adding the high bytes
 ADC XX15+1
 STA XX15+1

IF NOT(_NES_VERSION)

 LDA #Y*2-1             \ Set y1 = 2 * #Y - 1. The constant #Y is 96, the
 STA XX15+2             \ y-coordinate of the mid-point of the space view, so
 LDA #0                 \ this sets Y2 to 191, the y-coordinate of the bottom
 STA XX15+3             \ pixel row of the space view

ELIF _NES_VERSION

 LDA Yx2M1              \ Set y1 = 2 * Yx2M1. The variable Yx2M1 is the
 STA XX15+2             \ y-coordinate of the mid-point of the space view, so
 LDA #0                 \ this sets Y2 to y-coordinate of the bottom pixel
 STA XX15+3             \ row of the space view

ENDIF

.LL136

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 RTS                    \ Return from the subroutine

