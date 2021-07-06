.BOMB

IF NOT(_ELITE_A_VERSION)

 SKIP 1                 \ Energy bomb
                        \
                        \   * 0 = not fitted
                        \
                        \   * &7F = fitted

ELIF _ELITE_A_VERSION

 SKIP 1                 \ Hyperspace unit
                        \
                        \   * 0 = not fitted
                        \
                        \   * &FF = fitted
                        \
                        \ Elite-A replaces the energy bomb with the hyperspace
                        \ unit, reusing the BOMB variable to determine whether
                        \ one is fitted
ENDIF

