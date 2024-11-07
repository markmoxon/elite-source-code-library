.LSX

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 SKIP 0                 \ LSX is an alias that points to the first byte of the
                        \ sun line heap at LSO
ELIF _MASTER_VERSION OR _APPLE_VERSION

 SKIP 1                 \ LSX contains the status of the sun line heap at LSO
ENDIF
                        \
                        \   * &FF indicates the sun line heap is empty
                        \
                        \   * Otherwise the LSO heap contains the line data for
                        \     the sun

