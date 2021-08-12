.ENGY

 SKIP 1                 \ Energy unit
                        \
                        \   * 0 = not fitted
                        \
                        \   * Non-zero = fitted
                        \
                        \ The actual value determines the refresh rate of our
                        \ energy banks, as they refresh by ENGY+1 each time (so
                        \ our ship's energy level goes up by 2 each time if we
                        \ have an energy unit fitted, otherwise it goes up by 1)
IF _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \
                        \ The enhanced versions of Elite set ENGY to 2 as the
                        \ reward for completing mission 2, where we receive a
                        \ naval energy unit that recharges 50% faster than a
                        \ standard energy unit, i.e. by 3 each time

ELIF _ELITE_A_VERSION
                        \
                        \ In Elite-A, the value of ENGY depends on the ship type
                        \ so some ships recharge faster than others

ENDIF

