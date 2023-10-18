\ ******************************************************************************
\
\       Name: GetScrollDivisions
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Set up the division calculations for the scroll text
\
\ ------------------------------------------------------------------------------
\
\ This routine sets up a division table to use in the calculations for drawing
\ the scroll text in DrawScrollFrame.
\
\ ******************************************************************************

.GetScrollDivisions

 LDY #15                \ We are going to populate 16 bytes in the buffer at BUF
                        \ and another 16 in the buffer at BUF+16, so set a loop
                        \ counter in Y

.sdiv1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY T                  \ Store the loop counter in T (though we don't read this
                        \ again, so this has no effect)

 TYA                    \ Set R = Y * 2
 ASL A
 STA R

 ASL A                  \ Set S = Y * 4
 STA S

 ASL A                  \ Set the Y-th entry in BUF+16 to the following:
 ADC #31                \
 SBC scrollProgress     \   Y * 8 + 31 - scrollProgress
 STA BUF+16,Y           \
                        \ We know the C flag is clear because Y is a maximum of
                        \ 15 so the three ASL A instructions will shift zeroes
                        \ into the C flag each time

 BPL sdiv4              \ If A < 128, jump to sdiv4 to set Q and A as follows,
                        \ but with both scaled up as far as possible to make the
                        \ calculation more accurate

 STA Q                  \ Set Q = A

 LDA scrollProgress     \ Set A = 37 + scrollProgress / 4 - R
 LSR A                  \       = 37 + scrollProgress / 4 - Y * 2
 LSR A
 ADC #37
 SBC R

.sdiv2

 CMP Q                  \ If A >= Q, jump to sdiv3 to store 255 as the result
 BCS sdiv3              \ in the Y-th byte of BUF

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \
                        \     = 37 - Y * 2 + scrollProgress / 4
                        \       -------------------------------
                        \         31 + Y * 8 - scrollProgress

 LSR R                  \ Set R = R / 2
                        \
                        \     =  37 - Y * 2 + scrollProgress / 4
                        \       ---------------------------------
                        \       2 * (31 + Y * 8 - scrollProgress)

 LDA #72                \ Set the Y-th entry in BUF to 72 + R
 CLC
 ADC R
 STA BUF,Y

 DEY                    \ Decrement the loop counter in Y

 BPL sdiv1              \ Loop back until we have calculated all 16 values

 RTS                    \ Return from the subroutine

.sdiv3

 LDA #255               \ Set the Y-th entry in BUF to 255
 STA BUF,Y

 DEY                    \ Decrement the loop counter in Y

 BPL sdiv1              \ Loop back until we have calculated all 16 values

 RTS                    \ Return from the subroutine

.sdiv4

 ASL A                  \ Set A = A * 2

 BPL sdiv5              \ If A < 128, jump to sdiv5

 STA Q                  \ Set Q = A * 2

 LDA scrollProgress     \ Set A = 73 + scrollProgress / 2 - Y * 4
 LSR A
 ADC #73
 SBC S

                        \ So we have:
                        \
                        \   Q = A * 2
                        \
                        \   A = 73 + scrollProgress / 2 - Y * 4
                        \
                        \ So when we divide them at sdiv2 above, this is the
                        \ same as having:
                        \
                        \   Q = A
                        \
                        \   A = 37 + scrollProgress / 4 - Y * 2
                        \
                        \ but with both the numerator and denominator scaled up
                        \ by the same factor of 2

 JMP sdiv2              \ Jump to sdiv2 to continue the calculation with these
                        \ scaled up values of Q and A

.sdiv5

 ASL A                  \ Set Q = A * 4
 STA Q

 LDA scrollProgress     \ Set A = 144 + scrollProgress - Y * 2
 ADC #144
 SBC S
 SBC S

                        \ So we have:
                        \
                        \   Q = A * 4
                        \
                        \   A = 144 + scrollProgress - Y * 2
                        \
                        \ So when we divide them at sdiv2 above, this is the
                        \ same as having:
                        \
                        \   Q = A
                        \
                        \   A = 37 + scrollProgress / 4 - Y * 2
                        \
                        \ but with both the numerator and denominator scaled up
                        \ by the same factor of 4

 JMP sdiv2              \ Jump to sdiv2 to continue the calculation with these
                        \ scaled up values of Q and A

