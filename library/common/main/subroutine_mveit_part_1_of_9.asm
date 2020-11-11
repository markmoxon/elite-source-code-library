\ ******************************************************************************
\
\       Name: MVEIT (Part 1 of 9)
\       Type: Subroutine
\   Category: Moving
\    Summary: Move current ship: Tidy the orientation vectors
\  Deep dive: Orientation vectors
\
\ ------------------------------------------------------------------------------
\
\ This routine has multiple stages. This stage does the following:
\
\   * Tidy the orientation vectors for one of the ship slots
\
\ Arguments:
\
\   INWK                The current ship/planet/sun's data block
\
\   XSAV                The slot number of the current ship/planet/sun
\
\   TYPE                The type of the current ship/planet/sun
\
\ ******************************************************************************

.MVEIT

 LDA INWK+31            \ If bits 5 or 7 are set, jump to MV30 as the ship is
 AND #%10100000         \ either exploding or has been killed, so we don't need
 BNE MV30               \ to tidy its orientation vectors or apply tactics

 LDA MCNT               \ Fetch the main loop counter

 EOR XSAV               \ Fetch the slot number of the ship we are moving, EOR
 AND #15                \ with the loop counter and apply mod 15 to the result.
 BNE MV3                \ The result will be zero when "counter mod 15" matches
                        \ the slot number, so this makes sure we call TIDY 13
                        \ times every 16 main loop iteration, like this:
                        \
                        \   Iteration 0, tidy the ship in slot 0
                        \   Iteration 1, tidy the ship in slot 1
                        \   Iteration 2, tidy the ship in slot 2
                        \     ...
                        \   Iteration 11, tidy the ship in slot 11
                        \   Iteration 12, tidy the ship in slot 12
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

