\ ******************************************************************************
\
\       Name: DOYC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specified row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The row number
\
\ ******************************************************************************

.DOYC

 STA YC                 \ Store A in YC, which sets the text cursor row number

 PHA                    \ Store the row number on the stack

 LDA #SETYC             \ Set A to #SETYC, ready to write to the I/O processor 

                        \ Fall through into label to write #SETYC <row> to the
                        \ I/O processor

