.COMC

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment
 SKIP 1                 \ The colour of the dot on the compass
ELIF _ELECTRON_VERSION OR _APPLE_VERSION
 SKIP 1                 \ The shape (i.e. thickness) of the dot on the compass
ENDIF
                        \
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \   * &F0 = the object in the compass is in front of us,
                        \     so the dot is yellow/white
                        \
                        \   * &FF = the object in the compass is behind us, so
                        \     the dot is green/cyan
ELIF _ELECTRON_VERSION
                        \   * &F0 = the object in the compass is in front of us,
                        \     so the dot is two pixels high and white
                        \
                        \   * &FF = the object in the compass is behind us, so
                        \     the dot is one pixel high and white
ELIF _6502SP_VERSION OR _MASTER_VERSION
                        \   * #WHITE2 = the object in the compass is in front of
                        \     us, so the dot is white
                        \
                        \   * #GREEN2 = the object in the compass is behind us,
                        \     so the dot is green
ELIF _C64_VERSION
                        \   * #YELLOW = the object in the compass is in front of
                        \     us, so the dot is yellow
                        \
                        \   * #GREEN = the object in the compass is behind us,
                        \     so the dot is green
ELIF _APPLE_VERSION
                        \
                        \   * 0 = do not draw a dot on the compass
                        \
                        \   * &30 = the object in the compass is in front of us,
                        \     so the dot is two pixels high and white
                        \
                        \   * &60 = the object in the compass is behind us, so
                        \     the dot is one pixel high and white
ENDIF

