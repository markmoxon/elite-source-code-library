\ ******************************************************************************
\
\       Name: INCYC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to the next row
\
\ ******************************************************************************

.INCYC

 PHA                    \ Store A on the stack so we can preserve it

 LDA YC                 \ Set A = YC + 1, so A is the number of the next row
 INA

 JSR DOYC               \ Call DOYC to move the text cursor to the new row in A

 PLA                    \ Retrieve the original value of A from the stack

 RTS                    \ Return from the subroutine

