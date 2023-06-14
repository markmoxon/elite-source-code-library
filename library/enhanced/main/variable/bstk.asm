.BSTK

IF NOT(_ELITE_A_VERSION)

 SKIP 1                 \ Bitstik configuration setting
                        \
                        \   * 0 = keyboard or joystick (default)
                        \
                        \   * &FF = Bitstik
                        \
                        \ Toggled by pressing "B" when paused, see the DKS3
                        \ routine for details

ELIF _ELITE_A_VERSION

 SKIP 1                 \ Delta 14B joystick configuration setting
                        \
                        \   * 127 = keyboard
                        \
                        \   * 128 = Delta 14B joystick
                        \
                        \ Elite-A doesn't support the Bitstik, but instead it
                        \ supports the multi-button Voltmace Delta 14B joystick,
                        \ reusing the BSTK variable to determine whether it is
                        \ configured

ENDIF

