\ ******************************************************************************
\
\       Name: DIL2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the roll or pitch indicator on the dashboard by sending a
\             draw_angle command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The offset of the vertical bar to show in the indicator,
\                       from 0 at the far left, to 8 in the middle, and 15 at
\                       the far right
\
\ Returns:
\
\   C flag              The C flag is set
\
\ ******************************************************************************

.DIL2

 PHA                    \ Store the new value of the indicator on the stack

 LDA #&87               \ Send command &87 to the I/O processor:
 JSR tube_write         \
                        \   draw_angle(value, screen_low, screen_high)
                        \
                        \ which will update the roll or pitch dashboard
                        \ indicator to the specified value

 PLA                    \ Send the first parameter to the I/O processor:
 JSR tube_write         \
                        \   * value = A

 LDA SC                 \ Send the second parameter to the I/O processor:
 JSR tube_write         \
                        \   * screen_low = SC

 LDA SC+1               \ Send the third parameter to the I/O processor:
 JSR tube_write         \
                        \   * screen_high = SC+1

 INC SC+1               \ Increment the high byte of SC to point to the next
                        \ character row on-screen (as each row takes up exactly
                        \ one page of 256 bytes) - so this sets up SC to point
                        \ to the next indicator, i.e. the one below the one we
                        \ just drew

 RTS                    \ Return from the subroutine

