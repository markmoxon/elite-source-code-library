.DNOIZ

IF NOT(_NES_VERSION)

 SKIP 1                 \ Sound on/off configuration setting
                        \
                        \   * 0 = sound is on (default)
                        \
                        \   * Non-zero = sound is off
                        \
                        \ Toggled by pressing "S" when paused, see the DK4
                        \ routine for details

ELIF _NES_VERSION

 SKIP 1                 \ Sound on/off configuration setting
                        \
                        \   * 0 = sound is off
                        \
                        \   * &FF = sound is on (default)

ENDIF

