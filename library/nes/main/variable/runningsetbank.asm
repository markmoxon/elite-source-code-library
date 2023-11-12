.runningSetBank

 SKIP 1                 \ A flag that records whether we are in the process of
                        \ switching ROM banks in the SetBank routine when the
                        \ NMI handler is called
                        \
                        \   * 0 = we are not in the process of switching ROM
                        \         banks
                        \
                        \   * Non-zero = we are not in the process of switching
                        \                ROM banks
                        \
                        \ This is used to control whether the NMI handler calls
                        \ the MakeSounds routine to make the current sounds
                        \ (music and sound effects), as this can only happen if
                        \ we are not in the middle of switching ROM banks (if
                        \ we are, then MakeSounds is only called once the
                        \ bank-switching is done - see the SetBank routine for
                        \ details)

