\ ******************************************************************************
\
\       Name: MVEIT_FLIGHT (Part 1 of 6)
\       Type: Subroutine
\   Category: Moving
\    Summary: Move current ship (flight version)
\
\ ******************************************************************************

.MVEIT_FLIGHT

 LDA INWK+31            \ If bit 5 or 7 of ship byte #31 is set, jump to MV30
 AND #%10100000         \ as the ship is either exploding or has been killed, so
 BNE MV30               \ we don't need to tidy its orientation vectors or apply
                        \ tactics

 LDA MCNT               \ Fetch the main loop counter

 EOR XSAV               \ Fetch the slot number of the ship we are moving, EOR
 AND #15                \ with the loop counter and apply mod 15 to the result.
 BNE P%+5               \ The result will be zero when "counter mod 15" matches
                        \ the slot number, so this makes sure we call TIDY 12
                        \ times every 16 main loop iterations, like this:
                        \
                        \   Iteration 0, tidy the ship in slot 0
                        \   Iteration 1, tidy the ship in slot 1
                        \   Iteration 2, tidy the ship in slot 2
                        \     ...
                        \   Iteration 11, tidy the ship in slot 11
                        \   Iteration 12, do nothing
                        \   Iteration 13, do nothing
                        \   Iteration 14, do nothing
                        \   Iteration 15, do nothing
                        \   Iteration 16, tidy the ship in slot 0
                        \     ...
                        \
                        \ and so on

 JSR TIDY               \ Call TIDY to tidy up the orientation vectors, to
                        \ prevent the ship from getting elongated and out of
                        \ shape due to the imprecise nature of trigonometry
                        \ in assembly language

