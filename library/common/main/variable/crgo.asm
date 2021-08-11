.CRGO

IF NOT(_ELITE_A_VERSION)

 SKIP 1                 \ Our ship's cargo capacity
                        \
                        \   * 22 = standard cargo bay of 20 tonnes
                        \
                        \   * 37 = large cargo bay of 35 tonnes
                        \
                        \ The value is two greater than the actual capacity to
                        \ make the maths in tnpr slightly more efficient

ELIF _ELITE_A_VERSION

 SKIP 1                 \ I.F.F. system
                        \
                        \   * 0 = not fitted
                        \
                        \   * &FF = fitted
                        \
                        \ Elite-A doesn't sell the large cargo bay as you can
                        \ buy different ships with different capacities, so we
                        \ reuse the CRGO variable to determine whether an I.F.F.
                        \ system is fitted

ENDIF

