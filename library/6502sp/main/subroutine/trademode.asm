\ ******************************************************************************
\
\       Name: TRADEMODE
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Clear the screen and set up a printable trading screen
\
\ ------------------------------------------------------------------------------
\
\ Clear the top part of the screen, draw a white border, set the print flag if
\ CTRL is being pressed, set the palette for trading screens, and set the
\ current view type in QQ11 to A.
\
\ Arguments:
\
\   A                   The type of the new current view (see QQ11 for a list of
\                       view types)
\
\ ******************************************************************************

.TRADEMODE

 PHA                    \ Store the view type on the stack so we can restore it
                        \ after the call to CTRL

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed

 STA printflag          \ Store the result in printflag, which will have bit 7
                        \ set (and will therefore enable printing) if CTRL is
                        \ being pressed

 PLA                    \ Restore the view type from the stack

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to A

 JSR FLKB               \ Call FLKB to flush the keyboard buffer

 LDA #48                \ Send a #SETVDU19 48 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for trading screens,
                        \ which is yellow (colour 1), magenta (colour 2) and
                        \ white (colour 3)

 LDA #CYAN              \ Send a #SETCOL CYAN command to the I/O processor to
 JMP DOCOL              \ switch to colour 3, which is white in the trade view,
                        \ and return from the subroutine using a tail call

