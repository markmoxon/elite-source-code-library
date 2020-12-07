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
\ This is the main entry point for a the main game coce. It is also called
\ following death, and when the game is quit by pressing ESCAPE when paused.
\
\ ******************************************************************************

.TT170

 LDX #&FF               \ Set stack pointer to &01FF, as stack is in page 1
 TXS                    \ (this is the standard location for the 6502 stack,
                        \ so this instruction effectively resets the stack).
                        \ We need to do this because the loader code in
                        \ elite-loader.asm pushes code onto the stack, and this
                        \ effectively removes that code so we start afresh

IF _CASSETTE_VERSION

                        \ Fall through into BR1 to start the game

ELIF _6502SP_VERSION

 JSR RESET

                        \ Fall through into DEATH2 to start the game

ENDIF

