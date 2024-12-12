IF _C64_VERSION

IF _GMA_RELEASE

.MULIE

 SKIP 1                 \ A flag to record whether the RESET routine is being
                        \ being called from within the TITLE routine, when the
                        \ title screen is being displayed, as we don't want to
                        \ stop the title music from playing when this is the
                        \ case
                        \
                        \   * 0 = the RESET routine is not currently being run
                        \         from the call in the TITLE routine, so the
                        \         RESET, RES2 and stopbd routines should stop
                        \         any music that is playing
                        \
                        \   * &FF = the RESET routine is currently being run
                        \           from the call in the TITLE routine, so
                        \           prevent it from stopping the title music

ENDIF

ELIF _APPLE_VERSION

.MULIE

 SKIP 1                 \ A flag to record whether the RESET routine is being
                        \ being called from within the TITLE routine, when the
                        \ title screen is being displayed, as we don't want to
                        \ stop the title music from playing when this is the
                        \ case
                        \
                        \   * 0 = the RESET routine is not currently being run
                        \         from the call in the TITLE routine, so the
                        \         RESET, RES2 and stopbd routines should stop
                        \         any music that is playing
                        \
                        \   * &FF = the RESET routine is currently being run
                        \           from the call in the TITLE routine, so
                        \           prevent it from stopping the title music

ENDIF

