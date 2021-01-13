.LSO

IF _DISC_VERSION

 SKIP 1                 \ This space has three uses:
                        \
.BUF                    \   * The ship line heap for the space station (see
                        \     NWSPS for details)
 SKIP 191               \
                        \   * The sun line heap (see SUN for details)
                        \
                        \   * The line buffer used by DASC to print justified
                        \     text (BUF = LSO + 1)
                        \
                        \ The spaces can be shared as our local bubble of
                        \ universe can support either the sun or a space
                        \ station, but not both

ELIF _CASSETTE_VERSION OR _6502SP_VERSION

 SKIP 192               \ This space has two uses:
                        \
                        \   * The ship line heap for the space station (see
                        \     NWSPS for details)
                        \
                        \   * The sun line heap (see SUN for details)
                        \
                        \ The spaces can be shared as our local bubble of
                        \ universe can support either the sun or a space
                        \ station, but not both

ENDIF

