.TP

IF _CASSETTE_VERSION

 SKIP 1                 \ The current mission status, which is always 0 for the
                        \ cassette version of Elite as there are no missions

ELIF _6502SP_VERSION

 SKIP 1                 \ The current mission status:
                        \
                        \   * 0 = no missions started
                        \
                        \   * Bit 0 set = mission 1 in progress
                        \   * Bit 1 set = mission 1 completed

ENDIF

