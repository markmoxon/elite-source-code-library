\ ******************************************************************************
\
\       Name: MSBAR_b6
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from bottom-right to bottom-left, then top-left and
\                       top-right, so indicator NOMSL is the top-right
\                       indicator)
\
\   Y                   The pattern number for the new missile indicator:
\
\                         * 133 = no missile indicator
\
\                         * 109 = red (armed and locked)
\
\                         * 108 = black (disarmed)
\
\                       The armed missile flashes black and red, so the tile is
\                       swapped between 108 and 109 in the main loop
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

.MSBAR_b6

 TYA                    \ Store the pattern number on the stack so we can
 PHA                    \ retrieve it later

 LDY missileNames_b6,X  \ Set Y to the X-th entry from the missileNames table,
                        \ so Y is the offset of missile X's indicator in the
                        \ nametable buffer, from the start of row 22

 PLA                    \ Set the nametable buffer entry to the pattern number
 STA nameBuffer0+22*32,Y

 LDY #0                 \ Set Y = 0, so we can return it from the subroutine

 RTS                    \ Return from the subroutine

