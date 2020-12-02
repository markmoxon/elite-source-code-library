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
\   A                   The new row number
\
\ ******************************************************************************

.DOYC

 STA YC                 \ Store A in YC, which sets the text cursor row number

 PHA                    \ Store the new row number on the stack

 LDA #SETYC             \ Set A to #SETYC, ready to send to the I/O processor 

                        \ Fall through into label to send a #SETYC <row> command
                        \ to the I/O processor

