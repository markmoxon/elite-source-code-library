.LSO

IF _DISC_VERSION OR _ELITE_A_VERSION \ Platform

 SKIP 1                 \ The ship line heap for the space station (see NWSPS)
                        \ and the sun line heap (see SUN)
                        \
                        \ The spaces can be shared as our local bubble of
                        \ universe can support either the sun or a space
                        \ station, but not both

.BUF

 SKIP 191               \ The line buffer used by DASC to print justified text
                        \
                        \ This buffer shares space with the LSO buffer, which
                        \ works because neither the sun or space station are
                        \ shown at the same time as printing justified text

ELIF _CASSETTE_VERSION OR _6502SP_VERSION

 SKIP 192               \ The ship line heap for the space station (see NWSPS)
                        \ and the sun line heap (see SUN)
                        \
                        \ The spaces can be shared as our local bubble of
                        \ universe can support either the sun or a space
                        \ station, but not both

ELIF _ELECTRON_VERSION

 SKIP 86                \ This is the ship line heap for the space station
                        \ (see NWSPS for details)

ELIF _MASTER_VERSION

 SKIP 200               \ The ship line heap for the space station (see NWSPS)
                        \ and the sun line heap (see SUN)
                        \
                        \ The spaces can be shared as our local bubble of
                        \ universe can support either the sun or a space
                        \ station, but not both

ENDIF

