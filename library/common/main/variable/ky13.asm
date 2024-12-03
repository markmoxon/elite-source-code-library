.KY13

IF NOT(_C64_VERSION)

 SKIP 1                 \ ESCAPE is being pressed (launch escape pod)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "8"               \ Left arrow is being pressed (launch escape pod,
                        \ KLO+&7)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF
