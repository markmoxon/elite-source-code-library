.LSX

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 SKIP 0                 \ LSX is an alias that points to the first byte of the
                        \ sun line heap at LSO
ELIF _MASTER_VERSION

 SKIP 1                 \ LSX contains the status of the sun line heap at LSO
ENDIF
                        \
                        \   * &FF indicates the sun line heap is empty
                        \
                        \   * Otherwise the LSO heap contains the line data for
                        \     the sun

