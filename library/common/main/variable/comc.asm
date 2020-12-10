.COMC

 EQUB 0                 \ The colour of the dot on the compass
                        \
                        \   * &F0 = the object in the compass is in front of us,
                        \     so the dot is yellow/white
                        \
                        \   * &FF = the object in the compass is behind us, so
IF _CASSETTE_VERSION
                        \     the dot is green/cyan
ELIF _6502SP_VERSION
                        \     the dot is green
ENDIF

