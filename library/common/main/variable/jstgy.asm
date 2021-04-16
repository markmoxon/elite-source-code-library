.JSTGY

 SKIP 1                 \ Reverse joystick Y-channel configuration setting
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform
                        \   * 0 = standard Y-channel (default)
                        \
                        \   * &FF = reversed Y-channel
ELIF _MASTER_VERSION
                        \   * 0 = reversed Y-channel
                        \
                        \   * &FF = standard Y-channel (default)
ENDIF
                        \
                        \ Toggled by pressing "Y" when paused, see the DKS3
                        \ routine for details

