\ ******************************************************************************
\
\       Name: MEBRK
\       Type: Subroutine
\   Category: Save and load
\    Summary: The BRKV handler for disc access operations
\
\ ------------------------------------------------------------------------------
\
\ This routine is used to display error messages from the disc filing system
\ while disc access operations are being performed. When called, it makes a beep
\ and prints the system error message in the block pointed to by (&FD &FE),
\ which is where the disc filing system will put any disc errors (such as "File
\ not found", "Disc error" and so on). It then waits for a key press and returns
\ to the disc access menu.
\
\ BRKV is set to this routine at the start of the SVE routine, just before the
\ disc access menu is shown, and it reverts to BRBR at the end of the SVE
\ routine after the disc access menu has been processed. In other words, BRBR is
\ the standard BRKV handler for the game, and it's swapped out to MRBRK for disc
\ access operations only.
\
\ When it is the BRKV handler, the routine can be triggered using a BRK
\ instruction. The main difference between this routine and the standard BRKV
\ handler in BRBR is that this routine returns to the disc access menu rather
\ than restarting the game, and it doesn't decrement the brkd counter.
\
\ ******************************************************************************

.MEBRK

 LDX stack              \ Set the stack pointer to the value that we stored in
 TXS                    \ location stack, so that's back to the value it had
                        \ before we set BRKV to point to MEBRK in the SVE
                        \ routine

IF _DISC_DOCKED OR _ELITE_A_DOCKED \ Tube

 LDY #0                 \ Set Y to 0 to use as a loop counter below

ELIF _6502SP_VERSION

 JSR backtonormal       \ Disable the keyboard and set the SVN flag to 0

 TAY                    \ The call to backtonormal sets A to 0, so this sets Y
                        \ to 0, which we use as a loop counter below

ENDIF

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.MEBRKL

 JSR OSWRCH             \ Print the character in A (which contains a beep on the
                        \ first loop iteration), and then any non-zero
                        \ characters we fetch from the error message

 INY                    \ Increment the loop counter

IF _6502SP_VERSION \ Other: This might be a bug fix? The 6502SP version returns from the disc access break handler if the error printing routine loops through a whole page, so it always exits. The other versions could crash if there is no null value in the block pointed to by (&FD &FE), so perhaps this fixes this issue?

 BEQ retry              \ If Y = 0 then we have worked our way through a whole
                        \ page, so jump to retry to wait for a key press and
                        \ display the disc access menu (this BEQ is effectively
                        \ a JMP, as we didn't take the BNE branch above)

ENDIF

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE MEBRKL             \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

 BEQ retry              \ Jump to retry to wait for a key press and display the
                        \ disc access menu (this BEQ is effectively a JMP, as we
                        \ didn't take the BNE branch above)

