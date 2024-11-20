.KY2

IF NOT(_NES_VERSION OR _C64_VERSION)

 SKIP 1                 \ Space is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "5"               \ Space is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _NES_VERSION

 SKIP 1                 \ One pilot is configured and the up and B buttons are
                        \ both being pressed on controller 1
                        \
                        \ Or two pilots are configured and the A button is being
                        \ pressed on controller 2
                        \
                        \   * 0 = no
                        \
                        \   * &FF = yes

ENDIF

