.FRIN

 SKIP NOSH + 1          \ Slots for the ships in the local bubble of universe
                        \
                        \ There are #NOSH + 1 slots, but the ship-spawning
                        \ routine at NWSHP only populates #NOSH of them, so
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
                        \ there are 13 slots but only 12 are used for ships
ELIF _6502SP_VERSION
                        \ there are 21 slots but only 20 are used for ships
ENDIF
                        \ (the last slot is effectively used as a null
                        \ terminator when shuffling the slots down in the
                        \ KILLSHP routine)
                        \
                        \ See the deep dive on "The local bubble of universe"
                        \ for details of how Elite stores the local universe in
                        \ FRIN, UNIV and K%

