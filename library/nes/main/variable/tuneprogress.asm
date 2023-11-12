.tuneProgress

 SKIP 1                 \ A variable for keeping track of progress while playing
                        \ the current tune, so we send data to the APU at the
                        \ correct time over multiple iterations of the MakeMusic
                        \ routine, according to the tune speed in tuneSpeed

