.MSAR

 SKIP 1                 \ The targeting state of our leftmost missile
                        \
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \   * 0 = missile is not looking for a target, or it
                        \     already has a target lock (indicator is not
                        \     yellow/white)
                        \
                        \   * Non-zero = missile is currently looking for a
                        \     target (indicator is yellow/white)
ELIF _ELECTRON_VERSION
                        \   * 0 = missile is not looking for a target, or it
                        \     already has a target lock (indicator is either a
                        \     white square, or a white square containing a "T")
                        \
                        \   * Non-zero = missile is currently looking for a
                        \     target (indicator is a black box in a white
                        \     square)
ENDIF

