.LSX

 SKIP 0                 \ LSX is an alias that points to the first byte of the
                        \ sun line heap at LSO
                        \
                        \   * &FF indicates the sun line heap is empty
                        \
                        \   * Otherwise the LSO heap contains the line data for
                        \     the sun, starting with this byte

.LSO

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

