.KY17

IF NOT(_C64_VERSION)

 SKIP 1                 \ "E" is being pressed (activate E.C.M.)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "3"               \ "E" is being pressed (activate E.C.M., KLO+&32)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

