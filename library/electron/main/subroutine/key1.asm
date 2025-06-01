\ ******************************************************************************
\
\       Name: KEY1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: The main keyboard interrupt handler (KEYV points here)
\
\ ******************************************************************************

.KEY1

 PHP                    \ Store the flags on the stack

 BIT KEYB               \ If bit 7 of KEYB is set then we are currently reading
 BMI P%+4               \ from the keyboard or processing a file with an OS
                        \ command, so skip the following two instructions so we
                        \ call the operating system's keyboard handler below

 PLP                    \ We aren't currently reading from the keyboard with an
 RTS                    \ OS command, so retrieve the flags from the stack and
                        \ return from the subroutine

 PLP                    \ If we get here then we are currently reading from the
                        \ keyboard with an OS command, so retrieve the flags on
                        \ the stack before passing the interrupt through for the
                        \ OS to process the key press

 JMP (S%+4)             \ Jump to the original value of KEYV, which is stored in
                        \ S%+4, so the OS can process the key press as normal,
                        \ and return from the subroutine using a tail call

