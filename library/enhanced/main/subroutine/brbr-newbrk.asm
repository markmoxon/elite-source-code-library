\ ******************************************************************************
\
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\       Name: BRBR
ELIF _MASTER_VERSION
\       Name: NEWBRK
ENDIF
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
IF _6502SP_VERSION \ Comment
\ BRKV is set to this routine in the decryption routine at DEEOR just before the
\ game is run for the first time, and at the end of the SVE routine after the
\ disc access menu has been processed. In other words, this is the standard
\ BRKV handler for the game, and it's swapped out to MEBRK for disc access
\ operations only.
\
\ When it is the BRKV handler, the routine can be triggered using a BRK
\ instruction. The main differences between this routine and the MEBRK handler
\ that is used during disc access operations are that this routine restarts the
\ game rather than returning to the disc access menu, and this handler
\ decrements the brkd counter.
\
ELIF _ELITE_A_VERSION OR _DISC_VERSION
\ BRKV is set to this routine in the loader, when the docked code is loaded, and
\ at the end of the SVE routine after the disc access menu has been processed.
\ In other words, this is the standard BRKV handler for the game, and it's
\ swapped out to MEBRK for disc access operations only.
\
\ When it is the BRKV handler, the routine can be triggered using a BRK
\ instruction. The main differences between this routine and the MEBRK handler
\ that is used during disc access operations are that this routine restarts the
\ game rather than returning to the disc access menu, and this handler
\ decrements the brkd counter.
\
ENDIF
\ ******************************************************************************

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Label

.BRBR

ELIF _MASTER_VERSION

.NEWBRK

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 DEC brkd               \ Decrement the brkd counter

ENDIF

IF _6502SP_VERSION \ Platform

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR backtonormal       \ Disable the keyboard and set the SVN flag to 0

 TAY                    \ The call to backtonormal sets A to 0, so this sets Y
                        \ to 0, which we use as a loop counter below

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.BRBRLOOP

ELIF _MASTER_VERSION

 LDX stackpt            \ Set the stack pointer to the value that we stored in
 TXS                    \ location stack, so that's back to the value it had
                        \ before we change it in the SVE routine

 JSR SWAPZP             \ Call SWAPZP to restore the top part of zero page

 STZ CATF               \ Set the CATF flag to 0, so the TT26 routine reverts to
                        \ standard formatting

 LDY #0                 \ Set Y to 0, which we use as a loop counter below

 LDA #7                 \ Set A = 7 to generate a beep before we print the error
                        \ message

.BRBRLOOP

ENDIF

IF _6502SP_VERSION \ Label

 JSR OSWRCH             \ Print the character in A, which contains a line feed
                        \ on the first loop iteration, and then any non-zero
                        \ characters we fetch from the error message

ELIF _MASTER_VERSION

 JSR CHPR               \ Print the character in A, which contains a line feed
                        \ on the first loop iteration, and then any non-zero
                        \ characters we fetch from the error message

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the MOS error message pointer

 BNE BRBRLOOP           \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Minor

 BNE BR1                \ If the brkd counter is non-zero, jump to BR1 to
                        \ restart the game

ELIF _6502SP_VERSION

 JMP BR1                \ Jump to BR1 to restart the game

ELIF _MASTER_VERSION

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disc access menu and return
                        \ from the subroutine using a tail call

ENDIF

IF _ELITE_A_6502SP_PARA

 JSR RES2               \ Reset a number of flight variables and workspaces
                        \ and fall through into the entry code for the game
                        \ to restart from the title screen

ENDIF

