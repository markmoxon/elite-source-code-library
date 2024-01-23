\ ******************************************************************************
\
\       Name: wsstate
\       Type: Variable
\   Category: Utility routines
\    Summary: Flag to keep track of whether we have saved or restored the filing
\             system workspace
\
\ ******************************************************************************

                        \ --- Mod: Code added for Elite-A: -------------------->

IF _BUG_FIX

.wsstate

 EQUB 0                 \ Bit 7 determines the state of the filing system
                        \ workspace and MOS character definitions:
                        \
                        \   * Clear = filing system workspace restored to &C000
                        \             so it is safe to do file operations
                        \
                        \   * Set = filing system workspace saved to safe place
                        \           and replaced by MOS character definitions
                        \           at &C000

ENDIF

                        \ --- End of added code ------------------------------->

