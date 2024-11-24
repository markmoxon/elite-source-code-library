.KY4

IF NOT(_NES_VERSION OR _C64_VERSION)

 SKIP 1                 \ ">" is being pressed (roll right)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "5"               \ ">" is being pressed (roll right, KLO+&14)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _NES_VERSION

 SKIP 1                 \ One pilot is configured and the right button is being
                        \ pressed on controller 1 (and the B button is not being
                        \ pressed)
                        \
                        \ Or two pilots are configured and the right button is
                        \ being pressed on controller 2
                        \
                        \   * 0 = no
                        \
                        \   * &FF = yes

ENDIF

