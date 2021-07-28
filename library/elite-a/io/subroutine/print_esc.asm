\ ******************************************************************************
\
\       Name: print_esc
\       Type: Subroutine
\   Category: Text
\    Summary: Send an escape sequence to the printer
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The parameter of the escape sequence, so ESC A is sent
\                       to the printer
\
\ ******************************************************************************

.print_esc

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA #27                \ Send ASCII 27 to the printer, which starts a printer
 JSR print_wrch         \ ESC escape sequence

 PLA                    \ Retrieve the value of A from the stack

                        \ Fall through into print_safe to send the character in
                        \ A to the printer

