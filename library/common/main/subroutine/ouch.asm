\ ******************************************************************************
\
\       Name: OUCH
\       Type: Subroutine
\   Category: Flight
\    Summary: Potentially lose cargo or equipment following damage
\
\ ------------------------------------------------------------------------------
\
\ Our shields are dead and we are taking damage, so there is a small chance of
\ losing cargo or equipment.
\
\ ******************************************************************************

.OUCH

 JSR DORND              \ Set A and X to random numbers

 BMI out                \ If A < 0 (50% chance), return from the subroutine
                        \ (as out contains an RTS)

 CPX #22                \ If X >= 22 (89% chance), return from the subroutine
 BCS out                \ (as out contains an RTS)

 LDA QQ20,X             \ If we do not have any of item QQ20+X, return from the
 BEQ out                \ subroutine (as out contains an RTS). X is in the range
                        \ 0-21, so this not only checks for cargo, but also for
                        \ E.C.M., fuel scoops, energy bomb, energy unit and
                        \ docking computer, all of which can be destroyed

 LDA DLY                \ If there is already an in-flight message on-screen,
 BNE out                \ return from the subroutine (as out contains an RTS)

 LDY #3                 \ Set bit 1 of de, the equipment destruction flag, so
 STY de                 \ that when we call MESS below, " DESTROYED" is appended
                        \ to the in-flight message

 STA QQ20,X             \ A is 0 (as we didn't branch with the BNE above), so
                        \ this sets QQ20+X to 0, which destroys any cargo or
                        \ equipment we have of that type

 CPX #17                \ If X >= 17 then we just lost a piece of equipment, so
 BCS ou1                \ jump to ou1 to print the relevant message

 TXA                    \ Print recursive token 48 + A as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 BNE MESS               \ ITEMS") as the C flag is clear, so this prints the
                        \ destroyed item's name, followed by " DESTROYED" (as we
                        \ set bit 1 of the de flag above), and returns from the
                        \ subroutine using a tail call

.ou1

 BEQ ou2                \ If X = 17, jump to ou2 to print "E.C.M.SYSTEM
                        \ DESTROYED" and return from the subroutine using a tail
                        \ call

 CPX #18                \ If X = 18, jump to ou3 to print "FUEL SCOOPS
 BEQ ou3                \ DESTROYED" and return from the subroutine using a tail
                        \ call

 TXA                    \ Otherwise X is in the range 19 to 21 and the C flag is
 ADC #113-20            \ set (as we got here via a BCS to ou1), so we set A as
                        \ follows:
                        \
                        \   A = 113 - 20 + X + C
                        \     = 113 - 19 + X
                        \     = 113 to 115

IF _CASSETTE_VERSION

 BNE MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ELIF _6502SP_VERSION

 JMP MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ENDIF

