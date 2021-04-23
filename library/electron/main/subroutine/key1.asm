\ ******************************************************************************
\
\       Name: KEY1
\       Type: Subroutine
\   Category: Keyboard
\    Summary: The main keyboard interrupt handler (KEYV points here)
\
\ ******************************************************************************

.KEY1

 PHP                    \ ???

 BIT &0D01

 BMI P%+4
 PLP

 RTS

 PLP

 JMP (S%+4)             \ Jump to the original value of KEYV to process the key
                        \ press as normal

