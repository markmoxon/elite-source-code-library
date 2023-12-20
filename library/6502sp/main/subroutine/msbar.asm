\ ******************************************************************************
\
\       Name: MSBAR
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar by
\             sending a #DOmsbar command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Each indicator is a rectangle that's 3 pixels wide and 5 pixels high. If the
\ indicator is set to black, this effectively removes a missile.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left, so indicator NOMSL is the leftmost
\                       indicator)
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
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.msbpars

 EQUB 4                 \ The number of bytes to transmit with this command

 EQUB 0                 \ The number of bytes to receive with this command

 EQUB 0                 \ The number of the missile indicator to update

 EQUB 0                 \ The colour of the missile indicator

 EQUB 0                 \ End of the parameter block

.MSBAR

 PHX                    \ Store the indicator number on the stack so we can
                        \ retrieve it later

 STX msbpars+2          \ Store the indicator number in byte #2 of the parameter
                        \ block above

 STY msbpars+3          \ Store the indicator colour in byte #3 of the parameter
                        \ block above

 PHY                    \ Store the indicator colour on the stack so we can
                        \ retrieve it later

 LDX #LO(msbpars)       \ Set (Y X) to point to the parameter block above
 LDY #HI(msbpars)

 LDA #DOmsbar           \ Send a #DOmsbar command to the I/O processor to update
 JSR OSWORD             \ the missile indicator on the dashboard

 LDY #0                 \ Set Y = 0

 PLA                    \ Restore the indicator colour from the stack into A

 PLX                    \ Restore the indicator number from the stack into X

 RTS                    \ Return from the subroutine

