\ ******************************************************************************
\
\       Name: TT170
\       Type: Subroutine
\   Category: Start and end
\    Summary: Main entry point for the Elite game code
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_DOCKED OR _MASTER_VERSION \ Comment
\ This is the main entry point for the main game code.
ELIF _6502SP_VERSION
\ This is the main entry point for the main game code. It is called after the
\ various setup, decryption and checksum routines in S%, G% and BEGIN have
\ successfully completed.
ENDIF
\
\ It is also called following death, and when the game is quit by pressing
\ ESCAPE when paused.
\
\ ******************************************************************************

.TT170

IF _CASSETTE_VERSION \ Comment

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack. We need to do this
                        \ because the loader code in elite-loader.asm pushes
                        \ code onto the stack, and this effectively removes that
                        \ code so we start afresh

ELIF _DISC_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Platform

                        \ Fall through into BR1 to start the game

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR RESET              \ Call RESET to initialise most of the game variables

                        \ Fall through into DEATH2 to start the game

ENDIF

