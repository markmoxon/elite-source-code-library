\ ******************************************************************************
\
\       Name: DOVDU19
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Change the mode 1 palette by sending a #SETVDU19 command to the
\             I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The colour number to define
\
\ ******************************************************************************

.DOVDU19

 PHA                    \ Store A, the colour number, on the stack

 LDA #SETVDU19          \ Set A to #SETVDU19, ready to write to the I/O
                        \ processor

 BNE label              \ Jump to label to write #SETVDU19 <colour> to the I/O
                        \ processor, returning from the subroutine using a tail
                        \ call (this BNE is effectively a JMP as A is never
                        \ zero)

