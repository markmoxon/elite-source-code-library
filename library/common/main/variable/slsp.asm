.SLSP

 SKIP 2                 \ The address of the bottom of the ship line heap
                        \
                        \ The ship line heap is a descending block of memory
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
                        \ that starts at WP and descends down to SLSP. It can be
ELIF _6502SP_VERSION
                        \ that starts at D% and descends down to SLSP. It can be
ENDIF
                        \ extended downwards by the NWSHP routine when adding
                        \ new ships (and their associated ship line heaps), in
                        \ which case SLSP is lowered to provide more heap space,
                        \ assuming there is enough free memory to do so

