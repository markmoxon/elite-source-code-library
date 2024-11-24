.KY20

IF NOT(_C64_VERSION)

 SKIP 1                 \ "P" is being pressed (deactivate docking computer)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ELIF _C64_VERSION

 EQUS "8"               \ "P" is being pressed (deactivate docking computer,
                        \ KLO+&17)
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

ENDIF

