IF _C64_VERSION

IF _GMA_RELEASE

.MULIE

 SKIP 1                 \ A flag to record whether the RESET routine is
                        \ currently being run, in which case the music
                        \ configuration variables may be in a state of flux
                        \
                        \   * 0 = the RESET routine is not being run
                        \
                        \   * &FF = the RESET routine is in-progress

ENDIF

ELIF _APPLE_VERSION

.MULIE

 SKIP 1                 \ A flag to record whether the RESET routine is
                        \ currently being run, in which case the music
                        \ configuration variables may be in a state of flux
                        \
                        \   * 0 = the RESET routine is not being run
                        \
                        \   * &FF = the RESET routine is in-progress

ENDIF

