.KY20

IF NOT(_C64_VERSION)

 SKIP 1                 \ "P" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "8"               \ "P" is being pressed
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

