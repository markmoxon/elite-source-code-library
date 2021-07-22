\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar by
\             sending a put_missle command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left and starting at 0 rather than 1, so
\                       indicator NOMSL - 1 is the leftmost indicator)
\
\   Y                   The colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.MSBAR

 LDA #&88               \ Send command &86 to the I/O processor:
 JSR tube_write         \
                        \   put_missle(number, colour)
                        \
                        \ which will update missile indicator with the specified
                        \ number, changing it to the specified colour

 TXA                    \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * number = X

 TYA                    \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * colour = Y

 LDY #0                 \ Set Y = 0 to ensure we return the same value as the
                        \ SCAN routine in the non-Tube version

 RTS                    \ Return from the subroutine

