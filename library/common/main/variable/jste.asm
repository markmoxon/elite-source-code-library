.JSTE

 SKIP 1                 \ Reverse both joystick channels configuration setting
                        \
                        \   * 0 = standard channels (default)
                        \
                        \   * &FF = reversed channels
                        \
                        \ Toggled by pressing "J" when paused, see the DKS3
                        \ routine for details
IF _ELECTRON_VERSION \ Comment
                        \
                        \ Although this option is still configurable in the
                        \ Electron version, joystick values are never actually
                        \ read, so this option has no effect
ENDIF

