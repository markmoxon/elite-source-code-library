.MSTG

 SKIP 1                 \ The current missile lock target
                        \
                        \   * &FF = no target
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Comment
                        \   * 1-12 = the slot number of the ship that our
                        \            missile is locked onto
ELIF _NES_VERSION
                        \   * 1-8 = the slot number of the ship that our
                        \           missile is locked onto
ELIF _6502SP_VERSION
                        \   * 1-20 = the slot number of the ship that our
                        \            missile is locked onto
ENDIF

