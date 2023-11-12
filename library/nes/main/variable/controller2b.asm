.controller2B

 SKIP 1                 \ A shift register for recording presses of the B button
                        \ on controller 2
                        \
                        \ The controller is scanned every NMI and the result is
                        \ right-shifted into bit 7, with a 1 indicating a button
                        \ press and a 0 indicating no button press

