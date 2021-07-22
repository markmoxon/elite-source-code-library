\ ******************************************************************************
\
\       Name: write_0346
\       Type: Subroutine
\   Category: Tube
\    Summary: Update the value of LASCT by sending a write_0346 command to the
\             I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of LASCT
\
\ ******************************************************************************

.write_0346

 PHA                    \ Store the new value of LASCT on the stack

 LDA #&97               \ Send command &97 to the I/O processor:
 JSR tube_write         \
                        \   write_0346(value)
                        \
                        \ which will set the I/O processor's copy of LASCT to
                        \ the given value

 PLA                    \ Send the parameter to the I/O processor:
 JMP tube_write         \
                        \   * value = the new value of LASCT that we stored on
                        \             the stack
                        \
                        \ and return from the subroutine using a tail call

