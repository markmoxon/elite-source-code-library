.KY1

IF NOT(_NES_VERSION or _C64_VERSION)

 SKIP 1                 \ "?" is being pressed (slow down)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "A"               \ "?" is being pressed (slow down)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _NES_VERSION

 SKIP 1                 \ One pilot is configured and the down and B buttons are
                        \ both being pressed on controller 1
                        \
                        \ Or two pilots are configured and the B button is being
                        \ pressed on controller 2
                        \
                        \   * 0 = no
                        \
                        \   * &FF = yes

ENDIF

