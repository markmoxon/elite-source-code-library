.DAMP

IF NOT(_NES_VERSION)

 SKIP 1                 \ Keyboard damping configuration setting
                        \
                        \   * 0 = damping is enabled (default)
                        \
                        \   * &FF = damping is disabled
                        \
                        \ Toggled by pressing CAPS LOCK when paused, see the
                        \ DKS3 routine for details

ELIF _NES_VERSION

 SKIP 1                 \ Keyboard damping configuration setting
                        \
                        \   * 0 = damping is disabled
                        \
                        \   * &FF = damping is enabled (default)

ENDIF

