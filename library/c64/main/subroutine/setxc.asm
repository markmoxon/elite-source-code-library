\ ******************************************************************************
\
\       Name: SETXC
\       Type: Subroutine
\   Category: Text
\    Summary: An unused routine to move the text cursor to a specific column
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text column
\
\ ******************************************************************************

.SETXC

 STA XC                 \ Store the new text column in XC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

