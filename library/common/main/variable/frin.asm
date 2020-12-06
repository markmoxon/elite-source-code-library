.FRIN

IF _CASSETTE_VERSION
 SKIP NOSH + 1          \ Slots for the 13 ships in the local bubble of universe
ELIF _6502SP_VERSION
 SKIP NOSH + 1          \ Slots for the 21 ships in the local bubble of universe
ENDIF
                        \
                        \ See the deep dive on "The local bubble of universe"
                        \ for details of how Elite stores the local universe in
                        \ FRIN, UNIV and K%

