.COMC

 SKIP 1                 \ The colour of the dot on the compass
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
                        \   * &F0 = the object in the compass is in front of us,
                        \     so the dot is yellow/white
                        \
                        \   * &FF = the object in the compass is behind us, so
                        \     the dot is green/cyan
ELIF _6502SP_VERSION
                        \   * #WHITE2 = the object in the compass is in front of
                        \     us, so the dot is white
                        \
                        \   * #GREEN2 = the object in the compass is behind us,
                        \     so the dot is green
ENDIF

