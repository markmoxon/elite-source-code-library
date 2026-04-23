\ ******************************************************************************
\
\       Name: RefineApproach
\       Type: Subroutine
\   Category: Demo
\    Summary: Refine our approach using pitch and roll to aim for the target
\
\ ******************************************************************************

.RefineApproach

                        \ From DOCKIT, PH3

 LDX #0                 \ Set RAT2 = 0
 STX RAT2

 STX INWK+30            \ Set the pitch counter to 0 to stop any pitching

 EOR XX15               \ A is negative, so this sets the sign of A to the same
 EOR XX15+1             \ as -XX15 * XX15+1, or -ship_x * ship_y

 ASL A                  \ Shift the sign bit into the C flag, so the C flag has
                        \ the following sign:
                        \
                        \   * Positive if ship_x and ship_y have different signs
                        \   * Negative if ship_x and ship_y have the same sign

 LDA #2                 \ Set A = +2 or -2, giving it the sign in the C flag,
 ROR A                  \ and store it in byte #29, the roll counter, so that
 STA INWK+29            \ the ship rolls towards the target

 LDA XX15               \ If |ship_x * 2| >= 12, i.e. |ship_x| >= 6, then set
 ASL A                  \ the C flag so when we return from the subroutine, we
 CMP #12                \ jump to to PH22 to slow right down, as the target is
                        \ not in our sights

 RTS                    \ Return from the subroutine

