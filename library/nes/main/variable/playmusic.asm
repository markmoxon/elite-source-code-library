.playMusic

 SKIP 1                 \ Controls whether to keep playing the current tune:
                        \
                        \   * 0 = do not keep playing the current tune
                        \
                        \   * &FF do keep playing the current tune
                        \
                        \ The &FE note command stops the current tune and zeroes
                        \ this flag, and the only way to restart the music is
                        \ via the ChooseMusic routine
                        \
                        \ A value of zero in this flag also prevents the
                        \ EnableSound routine from having any effect

