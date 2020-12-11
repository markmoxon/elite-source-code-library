\ ******************************************************************************
\       Name: BRBR
\ ******************************************************************************

.BRBR

 DEC brkd               \ Decrement brkd

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR backtonormal       \ Disable the keyboard and set the SVN flag to 0

 TAY                    \ The call to backtonormal sets A to 0, so this sets Y
                        \ to 0, which use as a loop counter below

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.BRBRLOOP

 JSR OSWRCH             \ Print the character in A (which contains a line feed
                        \ on the first loop iteration, and then any non-zero
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE BRBRLOOP           \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

 JMP BR1

