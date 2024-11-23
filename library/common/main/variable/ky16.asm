.KY16

IF NOT(_C64_VERSION)

 SKIP 1                 \ "M" is being pressed (fire missile)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "D"               \ "M" is being pressed (fire missile)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

