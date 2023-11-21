\ ******************************************************************************
\
\       Name: SOS1
\       Type: Subroutine
\   Category: Universe
\    Summary: Update the missile indicators, set up the planet data block
\
\ ------------------------------------------------------------------------------
\
\ Update the missile indicators, and set up a data block for the planet, but
\ only setting the pitch and roll counters to 127 (no damping).
\
\ ******************************************************************************

.SOS1

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

 LDA #127               \ Set the pitch and roll counters to 127, so that's a
 STA INWK+29            \ clockwise roll and a diving pitch with no damping, so
 STA INWK+30            \ the planet's rotation doesn't slow down

 LDA tek                \ Set A = 128 or 130 depending on bit 1 of the system's
 AND #%00000010         \ tech level in tek
 ORA #%10000000

 JMP NWSHP              \ Add a new planet to our local bubble of universe,
                        \ with the planet type defined by A (128 is a planet
                        \ with an equator and meridian, 130 is a planet with
                        \ a crater)

