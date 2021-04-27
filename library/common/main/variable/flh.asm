.FLH

 SKIP 1                 \ Flashing console bars configuration setting
                        \
                        \   * 0 = static bars (default)
                        \
                        \   * &FF = flashing bars
                        \
                        \ Toggled by pressing "F" when paused, see the DKS3
                        \ routine for details
IF _ELECTRON_VERSION \ Comment
                        \
                        \ Although this option is still configurable in the
                        \ Electron version, it has no effect, as the code to
                        \ flash the console bars is missing
ENDIF

