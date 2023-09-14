.KY5

IF NOT(_NES_VERSION)

 SKIP 1                 \ "X" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _NES_VERSION

 SKIP 1                 \ One pilot is configured and the down button is being
                        \ pressed on controller 1 (and the B button is not being
                        \ pressed)
                        \
                        \ Or two pilots are configured and the down button is
                        \ being pressed on controller 2
                        \
                        \   * 0 = no
                        \
                        \   * &FF = yes

ENDIF

