\ ******************************************************************************
\
\       Name: print_safe
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character using the VDU routine in the MOS, to bypass our
\             custom WRCHV handler
\
\ ******************************************************************************

.print_safe

 PHA                    \ Store the A, Y and X registers on the stack so we can
 TYA                    \ retrieve them after the call to rawrch
 PHA
 TXA
 PHA

 TSX                    \ Transfer the stack pointer S to X

 LDA &103,X             \ The stack starts at &100, with &100+S pointing to the
                        \ top of the stack, so this fetches the third value from
                        \ the stack into A, which is the value of A that we just
                        \ stored on the stack - i.e. the character that we want
                        \ to print

 JSR rawrch             \ Print the character by calling the VDU character
                        \ output routine in the MOS

 PLA                    \ Retrieve the A, Y and X registers from the stack
 TAX
 PLA
 TAY
 PLA

 RTS                    \ Return from the subroutine

