\ ******************************************************************************
\       Name: MEBRK
\ ******************************************************************************

.MEBRK

 LDX stack
 TXS
 JSR backtonormal       \ Disable the keyboard and set the SVN flag to 0

 TAY                    \ The call to backtonormal sets A to 0, so this sets Y
                        \ to 0, which use as a loop counter below

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.MEBRKL

 JSR OSWRCH             \ Print the character in A (which contains a line feed
                        \ on the first loop iteration, and then any non-zero
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 BEQ retry

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE MEBRKL             \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

 BEQ retry

