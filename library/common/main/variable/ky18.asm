.KY18

IF NOT(_C64_VERSION)

 SKIP 1                 \ "J" is being pressed (in-system jump)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "F"               \ "J" is being pressed (in-system jump, KLO+&1E)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

