\ ******************************************************************************
\
\       Name: SETYC
\       Type: Subroutine
\   Category: Text
\    Summary: An unused routine to move the text cursor to a specific row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text row
\
\ ******************************************************************************

.SETYC

 STA YC                 \ Store the new text row in YC

\JMP PUTBACK            \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

