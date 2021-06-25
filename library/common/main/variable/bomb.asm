.BOMB

IF NOT(_ELITE_A_VERSION)
 SKIP 1                 \ Energy bomb
ELIF _ELITE_A_VERSION
 SKIP 1                 \ Hyperspace unit
ENDIF
                        \
                        \   * 0 = not fitted
                        \
                        \   * &7F = fitted
IF _ELITE_A_VERSION
                        \
                        \ Elite-A replaces the energy bomb with the hyperspace
                        \ unit, reusing the BOMB variable to determine whether
                        \ one is fitted
ENDIF

