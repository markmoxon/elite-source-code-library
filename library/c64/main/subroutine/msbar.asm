\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ------------------------------------------------------------------------------
\
\ Each indicator is a character block, so we can change the colour by simply
\ changing the relevant colour byte
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left, so indicator NOMSL is the leftmost
\                       indicator)
\
\   Y                   The new colour of the missile indicator:
\
\                         * #BLACK2 = black (no missile)
\
\                         * #RED2 = red (armed and locked)
\
\                         * #YELLOW2 = yellow/white (armed)
\
\                         * #GREEN2 = green (disarmed)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.MSBAR

 DEX                    \ Set A = X - 1
 TXA                    \
 INX                    \ So A is in the range 0 to 3, with 0 being the missile
                        \ indicator on the right

 EOR #3                 \ Flip A so it is in the range 0 to 3, but with 0 being
                        \ the missile indicator on the left

 STY SC                 \ Swap A and Y around (using SC as temporary storage),
 TAY                    \ so we have:
 LDA SC                 \
                        \   * A = the colour of the missile indicator
                        \
                        \   * Y = the indicator number (0 on left, 3 on right)

 STA MCELL,Y            \ Set the Y-th colour byte at MCELL to the new colour of
                        \ the indicator, which sets the colour of the character
                        \ block for the Y-th indicator

 LDY #0                 \ Set Y = 0 so we can return it from the subroutine

 RTS                    \ Return from the subroutine

