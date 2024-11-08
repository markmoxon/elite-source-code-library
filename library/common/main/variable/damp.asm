.DAMP

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION)

 SKIP 1                 \ Keyboard damping configuration setting
                        \
                        \   * 0 = damping is enabled (default)
                        \
                        \   * &FF = damping is disabled
                        \
                        \ Toggled by pressing CAPS LOCK when paused, see the
                        \ DKS3 routine for details

ELIF _C64_VERSION

 SKIP 1                 \ Keyboard damping configuration setting
                        \
                        \   * 0 = damping is enabled (default)
                        \
                        \   * &FF = damping is disabled
                        \
                        \ Toggled by pressing RUN/STOP when paused, see the
                        \ DKS3 routine for details
ELIF _APPLE_VERSION

 SKIP 1                 \ Keyboard damping configuration setting
                        \
                        \   * 0 = damping is enabled (default)
                        \
                        \   * &FF = damping is disabled
                        \
                        \ Toggled by pressing "D" when paused, see the DKS3
                        \ routine for details
ELIF _NES_VERSION

 SKIP 1                 \ Controller damping configuration setting
                        \
                        \   * 0 = damping is disabled
                        \
                        \   * &FF = damping is enabled (default)

ENDIF

