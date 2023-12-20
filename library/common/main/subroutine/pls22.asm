\ ******************************************************************************
\
\       Name: PLS22
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw an ellipse or half-ellipse
\  Deep dive: Drawing ellipses
\             Drawing meridians and equators
\             Drawing craters
\
\ ------------------------------------------------------------------------------
\
\ Draw an ellipse or half-ellipse, to be used for the planet's equator and
\ meridian (in which case we draw half an ellipse), or crater (in which case we
\ draw a full ellipse).
\
\ The ellipse is defined by a centre point, plus two conjugate radius vectors,
\ u and v, where:
\
\   u = [ u_x ]       v = [ v_x ]
\       [ u_y ]           [ v_y ]
\
\ The individual components of these 2D vectors (i.e. u_x, u_y etc.) are 16-bit
\ sign-magnitude numbers, where the high bytes contain only the sign bit (in
\ bit 7), with bits 0 to 6 being clear. This means that as we store u_x as
\ (XX16 K2), for example, we know that |u_x| = K2.
\
\ This routine calls BLINE to draw each line segment in the ellipse, passing the
\ coordinates as follows:
\
\   K6(1 0) = K3(1 0) + u_x * cos(CNT2) + v_x * sin(CNT2)
\
\   K6(3 2) = K4(1 0) - u_y * cos(CNT2) - v_y * sin(CNT2)
\
\ The y-coordinates are negated because BLINE expects pixel coordinates but the
\ u and v vectors are extracted from the orientation vector. The y-axis runs
\ in the opposite direction in 3D space to that on the screen, so we need to
\ negate the 3D space coordinates before we can combine them with the ellipse's
\ centre coordinates.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K(1 0)              The planet's radius
\
\   K3(1 0)             The pixel x-coordinate of the centre of the ellipse
\
\   K4(1 0)             The pixel y-coordinate of the centre of the ellipse
\
\   (XX16 K2)           The x-component of u (i.e. u_x), where XX16 contains
\                       just the sign of the sign-magnitude number
\
\   (XX16+1 K2+1)       The y-component of u (i.e. u_y), where XX16+1 contains
\                       just the sign of the sign-magnitude number
\
\   (XX16+2 K2+2)       The x-component of v (i.e. v_x), where XX16+2 contains
\                       just the sign of the sign-magnitude number
\
\   (XX16+3 K2+3)       The y-component of v (i.e. v_y), where XX16+3 contains
\                       just the sign of the sign-magnitude number
\
\   TGT                 The number of segments to draw:
\
\                         * 32 for a half ellipse (a meridian)
\
\                         * 64 for a full ellipse (a crater)
\
\   CNT2                The starting segment for drawing the half-ellipse
\
IF _NES_VERSION OR _ELITE_A_6502SP_PARA
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   PL40                Contains an RTS
\
ENDIF
\ ******************************************************************************

.PLS22

 LDX #0                 \ Set CNT = 0
 STX CNT

 DEX                    \ Set FLAG = &FF to reset the ball line heap in the call
 STX FLAG               \ to the BLINE routine below

.PLL4

 LDA CNT2               \ Set X = CNT2 mod 32
 AND #31                \
 TAX                    \ So X is the starting segment, reduced to the range 0
                        \ to 32, so as there are 64 segments in the circle, this
                        \ reduces the starting angle to 0 to 180 degrees, so we
                        \ can use X as an index into the sine table (which only
                        \ contains values for segments 0 to 31)
                        \
                        \ Also, because CNT2 mod 32 is in the range 0 to 180
                        \ degrees, we know that sin(CNT2 mod 32) is always
                        \ positive, or to put it another way:
                        \
                        \   sin(CNT2 mod 32) = |sin(CNT2)|

 LDA SNE,X              \ Set Q = sin(X)
 STA Q                  \       = sin(CNT2 mod 32)
                        \       = |sin(CNT2)|

 LDA K2+2               \ Set A = K2+2
                        \       = |v_x|

 JSR FMLTU              \ Set R = A * Q / 256
 STA R                  \       = |v_x| * |sin(CNT2)|

 LDA K2+3               \ Set A = K2+3
                        \       = |v_y|

 JSR FMLTU              \ Set K = A * Q / 256
 STA K                  \       = |v_y| * |sin(CNT2)|

 LDX CNT2               \ If CNT2 >= 33 then this sets the C flag, otherwise
 CPX #33                \ it's clear, so this means that:
                        \
                        \   * C is clear if the segment starts in the first half
                        \     of the circle, 0 to 180 degrees
                        \
                        \   * C is set if the segment starts in the second half
                        \     of the circle, 180 to 360 degrees
                        \
                        \ In other words, the C flag contains the sign bit for
                        \ sin(CNT2), which is positive for 0 to 180 degrees
                        \ and negative for 180 to 360 degrees

 LDA #0                 \ Shift the C flag into the sign bit of XX16+5, so
 ROR A                  \ XX16+5 has the correct sign for sin(CNT2)
 STA XX16+5             \
                        \ Because we set the following above:
                        \
                        \   K = |v_y| * |sin(CNT2)|
                        \   R = |v_x| * |sin(CNT2)|
                        \
                        \ we can add XX16+5 as the high byte to give us the
                        \ following:
                        \
                        \   (XX16+5 K) = |v_y| * sin(CNT2)
                        \   (XX16+5 R) = |v_x| * sin(CNT2)

 LDA CNT2               \ Set X = (CNT2 + 16) mod 32
 CLC                    \
 ADC #16                \ So we can use X as a lookup index into the SNE table
 AND #31                \ to get the cosine (as there are 16 segments in a
 TAX                    \ quarter-circle)
                        \
                        \ Also, because the sine table only contains positive
                        \ values, we know that sin((CNT2 + 16) mod 32) will
                        \ always be positive, or to put it another way:
                        \
                        \   sin((CNT2 + 16) mod 32) = |cos(CNT2)|

 LDA SNE,X              \ Set Q = sin(X)
 STA Q                  \       = sin((CNT2 + 16) mod 32)
                        \       = |cos(CNT2)|

 LDA K2+1               \ Set A = K2+1
                        \       = |u_y|

 JSR FMLTU              \ Set K+2 = A * Q / 256
 STA K+2                \         = |u_y| * |cos(CNT2)|

 LDA K2                 \ Set A = K2
                        \       = |u_x|

 JSR FMLTU              \ Set P = A * Q / 256
 STA P                  \       = |u_x| * |cos(CNT2)|
                        \
                        \ The call to FMLTU also sets the C flag, so in the
                        \ following, ADC #15 adds 16 rather than 15

 LDA CNT2               \ If (CNT2 + 16) mod 64 >= 33 then this sets the C flag,
 ADC #15                \ otherwise it's clear, so this means that:
 AND #63                \
 CMP #33                \   * C is clear if the segment starts in the first or
                        \     last quarter of the circle, 0 to 90 degrees or 270
                        \     to 360 degrees
                        \
                        \   * C is set if the segment starts in the second or
                        \     third quarter of the circle, 90 to 270 degrees
                        \
                        \ In other words, the C flag contains the sign bit for
                        \ cos(CNT2), which is positive for 0 to 90 degrees or
                        \ 270 to 360 degrees, and negative for 90 to 270 degrees

 LDA #0                 \ Shift the C flag into the sign bit of XX16+4, so:
 ROR A                  \ XX16+4 has the correct sign for cos(CNT2)
 STA XX16+4             \
                        \ Because we set the following above:
                        \
                        \   K+2 = |u_y| * |cos(CNT2)|
                        \   P   = |u_x| * |cos(CNT2)|
                        \
                        \ we can add XX16+4 as the high byte to give us the
                        \ following:
                        \
                        \   (XX16+4 K+2) = |u_y| * cos(CNT2)
                        \   (XX16+4 P)   = |u_x| * cos(CNT2)

 LDA XX16+5             \ Set S = the sign of XX16+2 * XX16+5
 EOR XX16+2             \       = the sign of v_x * XX16+5
 STA S                  \
                        \ So because we set this above:
                        \
                        \   (XX16+5 R) = |v_x| * sin(CNT2)
                        \
                        \ we now have this:
                        \
                        \   (S R) = v_x * sin(CNT2)

 LDA XX16+4             \ Set A = the sign of XX16 * XX16+4
 EOR XX16               \       = the sign of u_x * XX16+4
                        \
                        \ So because we set this above:
                        \
                        \   (XX16+4 P)   = |u_x| * cos(CNT2)
                        \
                        \ we now have this:
                        \
                        \   (A P) = u_x * cos(CNT2)

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           = u_x * cos(CNT2) + v_x * sin(CNT2)

 STA T                  \ Store the high byte in T, so the result is now:
                        \
                        \   (T X) = u_x * cos(CNT2) + v_x * sin(CNT2)

 BPL PL42               \ If the result is positive, jump down to PL42

 TXA                    \ The result is negative, so we need to negate the
 EOR #%11111111         \ magnitude using two's complement, first doing the low
 CLC                    \ byte in X
 ADC #1
 TAX

 LDA T                  \ And then the high byte in T, making sure to leave the
 EOR #%01111111         \ sign bit alone
 ADC #0
 STA T

.PL42

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 TXA                    \ Set K6(1 0) = K3(1 0) + (T X)
 ADC K3                 \
 STA K6                 \ starting with the low bytes

 LDA T                  \ And then doing the high bytes, so we now get:
 ADC K3+1               \
 STA K6+1               \   K6(1 0) = K3(1 0) + (T X)
                        \           = K3(1 0) + u_x * cos(CNT2)
                        \                     + v_x * sin(CNT2)
                        \
                        \ K3(1 0) is the x-coordinate of the centre of the
                        \ ellipse, so we now have the correct x-coordinate for
                        \ our ellipse segment that we can pass to BLINE below

 LDA K                  \ Set R = K = |v_y| * sin(CNT2)
 STA R

 LDA XX16+5             \ Set S = the sign of XX16+3 * XX16+5
 EOR XX16+3             \       = the sign of v_y * XX16+5
 STA S                  \
                        \ So because we set this above:
                        \
                        \   (XX16+5 K) = |v_y| * sin(CNT2)
                        \
                        \ and we just set R = K, we now have this:
                        \
                        \   (S R) = v_y * sin(CNT2)

 LDA K+2                \ Set P = K+2 = |u_y| * cos(CNT2)
 STA P

 LDA XX16+4             \ Set A = the sign of XX16+1 * XX16+4
 EOR XX16+1             \       = the sign of u_y * XX16+4
                        \
                        \ So because we set this above:
                        \
                        \   (XX16+4 K+2) = |u_y| * cos(CNT2)
                        \
                        \ and we just set P = K+2, we now have this:
                        \
                        \   (A P) = u_y * cos(CNT2)

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           =  u_y * cos(CNT2) + v_y * sin(CNT2)

 EOR #%10000000         \ Store the negated high byte in T, so the result is
 STA T                  \ now:
                        \
                        \   (T X) = - u_y * cos(CNT2) - v_y * sin(CNT2)
                        \
                        \ This negation is necessary because BLINE expects us
                        \ to pass pixel coordinates, where y-coordinates get
                        \ larger as we go down the screen; u_y and v_y, on the
                        \ other hand, are extracted from the orientation
                        \ vectors, where y-coordinates get larger as we go up
                        \ in space, so to rectify this we need to negate the
                        \ result in (T X) before we can add it to the
                        \ y-coordinate of the ellipse's centre in BLINE

 BPL PL43               \ If the result is positive, jump down to PL43

 TXA                    \ The result is negative, so we need to negate the
 EOR #%11111111         \ magnitude using two's complement, first doing the low
 CLC                    \ byte in X
 ADC #1
 TAX

 LDA T                  \ And then the high byte in T, making sure to leave the
 EOR #%01111111         \ sign bit alone
 ADC #0
 STA T

.PL43

                        \ We now call BLINE to draw the ellipse line segment
                        \
                        \ The first few instructions of BLINE do the following:
                        \
                        \   K6(3 2) = K4(1 0) + (T X)
                        \
                        \ which gives:
                        \
                        \   K6(3 2) = K4(1 0) - u_y * cos(CNT2)
                        \                     - v_y * sin(CNT2)
                        \
                        \ K4(1 0) is the pixel y-coordinate of the centre of the
                        \ ellipse, so this gives us the correct y-coordinate for
                        \ our ellipse segment (we already calculated the
                        \ x-coordinate in K3(1 0) above)

 JSR BLINE              \ Call BLINE to draw this segment, which also returns
                        \ the updated value of CNT in A

 CMP TGT                \ If CNT > TGT then jump to PL40 to stop drawing the
 BEQ P%+4               \ ellipse (which is how we draw half-ellipses)
 BCS PL40

 LDA CNT2               \ Set CNT2 = (CNT2 + STP) mod 64
 CLC
 ADC STP
 AND #63
 STA CNT2

 JMP PLL4               \ Jump back to PLL4 to draw the next segment

.PL40

 RTS                    \ Return from the subroutine

