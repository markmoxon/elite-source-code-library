.KY6

IF NOT(_NES_VERSION OR _C64_VERSION)

 SKIP 1                 \ "S" is being pressed (pitch down)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "4"               \ "S" is being pressed (pitch down)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _NES_VERSION

 SKIP 1                 \ One pilot is configured and the up button is being
                        \ pressed on controller 1 (and the B button is not being
                        \ pressed)
                        \
                        \ Or two pilots are configured and the up button is
                        \ being pressed on controller 2
                        \
                        \   * 0 = no
                        \
                        \   * &FF = yes

ENDIF

