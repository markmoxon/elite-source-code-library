\ ******************************************************************************
\
\       Name: print_wrch
\       Type: Subroutine
\   Category: Text
\    Summary: Send a character to the printer
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The ASCII character to send to the printer
\
\ ******************************************************************************

.print_wrch

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA #1                 \ Print ASCII 1 using the VDU routine in the MOS, which
 JSR print_safe         \ means "send the next character to the printer only"

 PLA                    \ Retrieve the value of A from the stack

                        \ Fall through into print_safe to print the character
                        \ in A, which will send it to the printer

