.pointerTimerB

 SKIP 1                 \ A timer used in the PAL version to detect the B button
                        \ being pressed twice in quick succession (a double-tap)
                        \
                        \ The MoveIconBarPointer routine sets pointerTimerB to 1
                        \ and pointerTimer to 40 when it detects a tap on the B
                        \ button
                        \
                        \ In successive calls to MoveIconBarPointer, while
                        \ pointerTimerB is non-zero, the MoveIconBarPointer
                        \ routine keeps a look-out for a second tap of the B
                        \ button, and if it detects one, it's a double-tap
                        \
                        \ When the timer in pointerTimer runs down to zero,
                        \ pointerTimerB is also zeroed, so if a second tap is
                        \ detected within 40 VBlanks, it is deemed to be a
                        \ double-tap

