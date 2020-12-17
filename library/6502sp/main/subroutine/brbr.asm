\ ******************************************************************************
\
\       Name: BRBR
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The standard BRKV handler for the game
\
\ ------------------------------------------------------------------------------
\
\ This routine is used to display error messages, before restarting the game.
\ When called, it makes a beep and prints the system error message in the block
\ pointed to by (&FD &FE), which is where the MOS will put any system errors. It
\ then waits for a key press and restarts the game.
\
\ BRKV is set to this routine in the decryption routine at DEEOR just before the
\ game is run for the first time, and at the end of the SVE routine after the
\ disc access menu has been processed. In other words, this is the standard
\ BRKV handler for the game, and it's swapped out to MRBRK for disc access
\ operations only.
\
\ When it is the BRKV handler, the routine can be triggered using a BRK
\ instruction. The main differences between this routine and the MEBRK handler
\ that is used during disc access operations are that this routine restarts the
\ game rather than returning to the disc access menu, and this handler
\ decrements the brkd counter.
\
\ ******************************************************************************

.BRBR

 DEC brkd               \ Decrement the brkd counter

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR backtonormal       \ Disable the keyboard and set the SVN flag to 0

 TAY                    \ The call to backtonormal sets A to 0, so this sets Y
                        \ to 0, which use as a loop counter below

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.BRBRLOOP

 JSR OSWRCH             \ Print the character in A, which contains a line feed
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

 JMP BR1                \ Jump to BR1 to restart the game

