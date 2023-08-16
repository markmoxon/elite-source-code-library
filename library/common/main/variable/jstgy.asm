.JSTGY

 SKIP 1                 \ Reverse joystick Y-channel configuration setting
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform
                        \   * 0 = standard Y-channel (default)
                        \
                        \   * &FF = reversed Y-channel
ELIF _MASTER_VERSION
                        \   * 0 = reversed Y-channel
                        \
                        \   * &FF = standard Y-channel (default)
ENDIF
IF NOT(_NES_VERSION)
                        \
                        \ Toggled by pressing "Y" when paused, see the DKS3
                        \ routine for details
ENDIF
IF _ELECTRON_VERSION \ Comment
                        \
                        \ Although this option is still configurable in the
                        \ Electron version, joystick values are never actually
                        \ read, so this option has no effect
ENDIF

