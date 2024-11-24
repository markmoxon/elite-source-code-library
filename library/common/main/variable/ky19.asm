.KY19

IF NOT(_C64_VERSION)

 SKIP 1                 \ "C" is being pressed (activate docking computer)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "D"               \ "C" is being pressed (activate docking computer,
                        \ KLO+&2C)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

