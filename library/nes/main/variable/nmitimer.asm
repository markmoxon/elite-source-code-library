.nmiTimer

 SKIP 1                 \ A counter that gets decremented each time the NMI
                        \ interrupt is called, starting at 50 and counting down
                        \ to zero, at which point it jumps back up to 50 again
                        \ and triggers an increment of (nmiTimerHi nmiTimerLo)
                        \
                        \ On PAL system there are 50 frames per second, so this
                        \ means nmiTimer ticks down from 50 once a second, so
                        \ (nmiTimerHi nmiTimerLo) counts up in seconds
                        \
                        \ On NTSC there are 60 frames per second, so nmiTimer
                        \ counts down in 5/6 of a second, or 0.8333 seconds,
                        \ so (nmiTimerHi nmiTimerLo) counts up every 0.8333
                        \ seconds

