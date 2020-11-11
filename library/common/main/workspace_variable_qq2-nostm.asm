.QQ2

 SKIP 6                 \ The three 16-bit seeds for the current system, i.e.
                        \ the one we are currently in
                        \
                        \ See the deep dives on "Galaxy and system seeds" and
                        \ "Twisting the system seeds" for more details

.QQ3

 SKIP 1                 \ The selected system's economy (0-7)
                        \
                        \ See the deep dive on "Generating system data" for more
                        \ information on economies

.QQ4

 SKIP 1                 \ The selected system's government (0-7)
                        \
                        \ See the deep dive on "Generating system data" for more
                        \ details of the various government types

.QQ5

 SKIP 1                 \ The selected system's tech level (0-14)
                        \
                        \ See the deep dive on "Generating system data" for more
                        \ information on tech levels

.QQ6

 SKIP 2                 \ The selected system's population in billions * 10
                        \ (1-71), so the maximum population is 7.1 billion
                        \
                        \ See the deep dive on "Generating system data" for more
                        \ details on population levels

.QQ7

 SKIP 2                 \ The selected system's productivity in M CR (96-62480)
                        \
                        \ See the deep dive on "Generating system data" for more
                        \ details about productivity levels

.QQ8

 SKIP 2                 \ The distance from the current system to the selected
                        \ system in light years * 10, stored as a 16-bit number
                        \
                        \ The distance will be 0 if the selected sysyem is the
                        \ current system
                        \
                        \ The galaxy chart is 102.4 light years wide and 51.2
                        \ light years tall (see the intra-system distance
                        \ calculations in routine TT111 for details), which
                        \ equates to 1024 x 512 in terms of QQ8

.QQ9

 SKIP 1                 \ The galactic x-coordinate of the crosshairs in the
                        \ galaxy chart (and, most of the time, the selected
                        \ system's galactic x-coordinate)

.QQ10

 SKIP 1                 \ The galactic y-coordinate of the crosshairs in the
                        \ galaxy chart (and, most of the time, the selected
                        \ system's galactic y-coordinate)

.NOSTM

 SKIP 1                 \ The number of stardust particles shown on screen,
                        \ which is 18 (#NOST) for normal space, and 3 for
                        \ witchspace
