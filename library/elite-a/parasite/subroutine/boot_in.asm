\ ******************************************************************************
\
\       Name: boot_in
\       Type: Subroutine
\   Category: Loader
\    Summary: The entry point for the game
\
\ ------------------------------------------------------------------------------
\
\ This routine is at the execution address for the parasite code (&2E93), so
\ it is called when the parasite code in file 2.T is loaded and run.
\
\ ******************************************************************************

.boot_in

IF _BUG_FIX

 LDA #&9C               \ Send command &9C to the I/O processor:
 JSR tube_write         \
                        \   savews()
                        \
                        \ which will switch the MOS character definitions into
                        \ &C000 so we can print properly

ENDIF

 LDA #0                 \ Set save_lock to 0 to indicate there are no unsaved
 STA save_lock          \ changes in the commander file

 STA SSPR               \ Set the "space station present" flag to 0, as we are
                        \ no longer in the space station's safe zone

 STA ECMA               \ Set ECMA to 0 to indicate that no E.C.M. is currently
                        \ running

 STA dockedp            \ Set dockedp to 0 to indicate that we are docked

 JMP BEGIN              \ Jump to BEGIN to initialise the configuration
                        \ variables and start the game

