\ ******************************************************************************
\
IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
\       Name: BRBR
ELIF _MASTER_VERSION
\       Name: NEWBRK
ENDIF
\       Type: Subroutine
\   Category: Utility routines
\    Summary: The standard BRKV handler for the game
IF _DISC_DOCKED OR _ELITE_A_VERSION \ Comment
\  Deep dive: Swapping between the docked and flight code
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ This routine is used to display error messages, before restarting the game.
\ When called, it makes a beep and prints the system error message in the block
\ pointed to by (&FD &FE), which is where the MOS will put any system errors. It
\ then waits for a key press and restarts the game.
\
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\ This routine is used to display error messages. It does this by restarting the
\ game to display the title screen, and the TITLE routine then prints the error
\ message on-screen.
\
ELIF _C64_VERSION OR _APPLE_VERSION
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
ENDIF
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
\ game rather than returning to the disc access menu.
\
ELIF _DISC_VERSION OR _ELITE_A_VERSION
\ BRKV is set to this routine in the loader, when the docked code is loaded, and
\ at the end of the SVE routine after the disc access menu has been processed.
\ In other words, this is the standard BRKV handler for the game, and it's
\ swapped out to MEBRK for disc access operations only.
\
\ When it is the BRKV handler, the routine can be triggered using a BRK
\ instruction. The main differences between this routine and the MEBRK handler
\ that is used during disc access operations are that this routine restarts the
\ game rather than returning to the disc access menu.
\
ENDIF
\ ******************************************************************************

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Label

.BRBR

ELIF _MASTER_VERSION

.NEWBRK

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

                        \ When we call this routine, we know that brkd will be
                        \ zero, as it is initialised to zero and the only other
                        \ place it gets changed is in the TITLE routine, where
                        \ it also gets set to 0

 DEC brkd               \ Set brkd = &FF to indicate that there is a system
                        \ error that needs to be printed out on the title screen
                        \ by the TITLE routine

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

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

 JSR getzp              \ Call getzp to restore the top part of zero page from
                        \ the buffer at &3000, as this will have been stored in
                        \ the buffer before performing the disc access that gave
                        \ the error we're processsing

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

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 JSR CHPR               \ Print the character in A, which contains a line feed
                        \ on the first loop iteration, and then any non-zero
                        \ characters we fetch from the error message

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Platform

 INY                    \ Increment the loop counter

 LDA (&FD),Y            \ Fetch the Y-th byte of the block pointed to by
                        \ (&FD &FE), so that's the Y-th character of the message
                        \ pointed to by the error message pointer

 BNE BRBRLOOP           \ If the fetched character is non-zero, loop back to the
                        \ JSR OSWRCH above to print the it, and keep looping
                        \ until we fetch a zero (which marks the end of the
                        \ message)

ENDIF

IF _DISC_DOCKED OR _ELITE_A_VERSION \ Minor

 BNE BR1                \ If brkd is non-zero then it must be &FF, which
                        \ indicates that where is a system error that we need to
                        \ print, so jump to BR1 to restart the game and fall
                        \ through into the TITLE routine to print the error

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

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

