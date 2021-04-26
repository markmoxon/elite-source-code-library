.COMC

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
 SKIP 1                 \ The colour of the dot on the compass
ELIF _ELECTRON_VERSION
 SKIP 1                 \ The shape (i.e. thickness) of the dot on the compass
ENDIF
                        \
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
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
ELIF _6502SP_VERSION
                        \   * #WHITE2 = the object in the compass is in front of
                        \     us, so the dot is white
                        \
                        \   * #GREEN2 = the object in the compass is behind us,
                        \     so the dot is green
ENDIF

