\ ******************************************************************************
\
\       Name: BRBR1
\       Type: Subroutine
\   Category: Loader
\    Summary: Loader break handler: print a newline and the error message, and
\             then hang the computer
\
\ ------------------------------------------------------------------------------
\
\ This break handler is only used until the docked code has loaded and the scram
\ routine has decrypted the code, at which point the break handler is changed to
\ the main game break handler (which doesn't hang the computer on an error).
\
\ ******************************************************************************

.BRBR1

                        \ The following loop prints out the null-terminated
                        \ message pointed to by (&FD &FE), which is the MOS
                        \ error message pointer - so this prints the error
                        \ message on the next line

 LDY #0                 \ Set Y = 0 to act as a character counter

 LDA #13                \ Set A = 13 so the first character printed is a
                        \ carriage return

.BRBRLOOP

 JSR OSWRCH             \ Print the character in A (which contains a carriage
                        \ return on the first loop iteration), and then any
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE BRBRLOOP           \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

 BEQ P%                 \ Hang the computer as something has gone wrong

