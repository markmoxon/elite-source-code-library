\ ******************************************************************************
\
\       Name: startat
\       Type: Subroutine
\   Category: Sound
\    Summary: Start playing the title music, if configured
\
\ ******************************************************************************

IF _GMA85_NTSC OR _GMA86_PAL

.startat

 LDA #LO(THEME-1)       \ Set (A X) to THEME-1, which is the address before
 LDX #HI(THEME-1)       \ the start of the title music at THEME

 BNE startat2           \ Jump to startat2 to play the title music (this BNE is
                        \ effectively a JMP as X is never zero)

ENDIF

