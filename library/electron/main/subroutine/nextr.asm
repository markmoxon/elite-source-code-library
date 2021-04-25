\ ******************************************************************************
\
\       Name: NEXTR
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Move to the next character row in the Electron mode 4 screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   C flag              Must be set on entry
\
\ ******************************************************************************

.NEXTR

                        \ Each character row in screen memory takes up &140
                        \ bytes (&100 for the visible part and &20 for each of
                        \ the blank borders on the side of the screen), so
                        \ that's what we need to add to SC(1 0) to move down
                        \ one row
                        \
                        \ We also know the C flag is set on entry, so we can
                        \ add &13F in order to get the correct result

 LDA SC                 \ Set SC(1 0) = SC(1 0) + &140
 ADC #&3F               \
 STA SC                 \ Starting with the low bytes

 LDA SC+1               \ And then adding the high bytes
 ADC #&01
 STA SC+1

 RTS                    \ Return from the subroutine

