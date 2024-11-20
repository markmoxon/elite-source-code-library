.KY14

IF NOT(_C64_VERSION)

 SKIP 1                 \ "T" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "B"               \ "T" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

