.JSTK

 SKIP 1                 \ Keyboard or joystick configuration setting
                        \
                        \   * 0 = keyboard (default)
                        \
                        \   * &FF = joystick
                        \
                        \ Toggled by pressing "K" when paused, see the DKS3
                        \ routine for details
IF _ELECTRON_VERSION \ Comment
                        \
                        \ Although this option is still configurable in the
                        \ Electron version, joystick values are never actually
                        \ read, so this option has no effect, though the chart
                        \ views do still run the joystick code, so switching to
                        \ joysticks moves the chart crosshairs in an
                        \ uncontrollable way (which is presumably a bug)
ENDIF

