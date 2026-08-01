.nmiTimerHi

 SKIP 1                 \ High byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps
                        \
                        \ On PAL systems nmiTimer(Hi Lo) counts seconds
                        \
                        \ On NTSC it increments up every 0.8333 seconds

