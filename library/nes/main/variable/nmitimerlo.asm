.nmiTimerLo

 SKIP 1                 \ Low byte of a counter that's incremented by 1 every
                        \ time nmiTimer wraps
                        \
                        \ On PAL systems nmiTimer(Hi Lo) counts seconds
                        \
                        \ On NTSC it increments up every 0.8333 seconds

