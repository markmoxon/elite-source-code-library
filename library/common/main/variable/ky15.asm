.KY15

IF NOT(_C64_VERSION)

 SKIP 1                 \ "U" is being pressed (unarm missile)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "3"               \ "U" is being pressed (unarm missile)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

