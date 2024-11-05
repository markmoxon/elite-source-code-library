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
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\ This is the main entry point for the main game code.
ELIF _6502SP_VERSION
\ This is the main entry point for the main game code. It is called after the
\ various setup, decryption and checksum routines in S%, G% and BEGIN have
\ successfully completed.
ENDIF
\
\ ******************************************************************************

.TT170

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack. We need to do this
                        \ because the loader code in elite-loader.asm pushes
                        \ code onto the stack, and this effectively removes that
                        \ code so we start afresh

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED \ 6502SP: The Executive version immediately starts the demo once the game has loaded (though just like the other 6502SP versions, you can still bring it up manually using TAB from the title screen, and it will automatically start after a period of inactivity)

                        \ Fall through into BR1 to start the game

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 JSR RESET              \ Call RESET to initialise most of the game variables

                        \ Fall through into DEATH2 to start the game

ELIF _6502SP_VERSION

 JSR RESET              \ Call RESET to initialise most of the game variables

IF _EXECUTIVE

 JSR DEMON              \ Call DEMON to show the demo

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 JSR RESET              \ Call RESET to initialise most of the game variables

ENDIF

                        \ Fall through into DEATH2 to start the game

ENDIF

