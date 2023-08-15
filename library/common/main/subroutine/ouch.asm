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
IF _NES_VERSION
\ Other entry points:
\
\   ouch1               Print the token in A as an in-flight message
\
ENDIF
\ ******************************************************************************

.OUCH

 JSR DORND              \ Set A and X to random numbers

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Label

 BMI out                \ If A < 0 (50% chance), return from the subroutine
                        \ (as out contains an RTS)

 CPX #22                \ If X >= 22 (91% chance), return from the subroutine
 BCS out                \ (as out contains an RTS)

 LDA QQ20,X             \ If we do not have any of item QQ20+X, return from the
 BEQ out                \ subroutine (as out contains an RTS). X is in the range
                        \ 0-21, so this not only checks for cargo, but also for
                        \ E.C.M., fuel scoops, energy bomb, energy unit and
                        \ docking computer, all of which can be destroyed

 LDA DLY                \ If there is already an in-flight message on-screen,
 BNE out                \ return from the subroutine (as out contains an RTS)

ELIF _DISC_FLIGHT

 BMI DK5                \ If A < 0 (50% chance), return from the subroutine
                        \ (as DK5 contains an RTS)

 CPX #22                \ If X >= 22 (91% chance), return from the subroutine
 BCS DK5                \ (as DK5 contains an RTS)

 LDA QQ20,X             \ If we do not have any of item QQ20+X, return from the
 BEQ DK5                \ subroutine (as DK5 contains an RTS). X is in the range
                        \ 0-21, so this not only checks for cargo, but also for
                        \ E.C.M., fuel scoops, energy bomb, energy unit and
                        \ docking computer, all of which can be destroyed

 LDA DLY                \ If there is already an in-flight message on-screen,
 BNE DK5                \ return from the subroutine (as DK5 contains an RTS)

ELIF _ELITE_A_VERSION

 BMI DK5                \ If A < 0 (50% chance), return from the subroutine
                        \ (as DK5 contains an RTS)

 CPX #24                \ If X >= 24 (90% chance), return from the subroutine
 BCS DK5                \ (as DK5 contains an RTS)

 LDA CRGO,X             \ If we do not have any of item CRGO+X, return from the
 BEQ DK5                \ subroutine (as DK5 contains an RTS). X is in the range
                        \ 0-23, so this not only checks for cargo, but also for
                        \ the I.F.F. system, E.C.M. system, fuel scoops,
                        \ hyperspace unit, energy unit, docking computer and
                        \ galactic hyperdrive, all of which can be destroyed

 LDA DLY                \ If there is already an in-flight message on-screen,
 BNE DK5                \ return from the subroutine (as DK5 contains an RTS)

ENDIF

 LDY #3                 \ Set bit 1 of de, the equipment destruction flag, so
 STY de                 \ that when we call MESS below, " DESTROYED" is appended
                        \ to the in-flight message

IF NOT(_ELITE_A_VERSION)

 STA QQ20,X             \ A is 0 (as we didn't branch with the BNE above), so
                        \ this sets QQ20+X to 0, which destroys any cargo or
                        \ equipment we have of that type

 CPX #17                \ If X >= 17 then we just lost a piece of equipment, so
 BCS ou1                \ jump to ou1 to print the relevant message

ELIF _ELITE_A_VERSION

 STA CRGO,X             \ A is 0 (as we didn't branch with the BNE above), so
                        \ this sets CRGO+X to 0, which destroys any cargo or
                        \ equipment we have of that type

 DEX                    \ Decrement X, so X is now in the range -1 to 22, and a
                        \ value of 0 means we just lost some food, 1 means we
                        \ lost some textiles, and so on

 BMI ou1                \ If X is now negative, then we just lost the I.F.F.
                        \ system (as X was 0 before being decremented), so jump
                        \ to ou1 to print the relevant message, which will be
                        \ "I.F.F.SYSTEM DESTROYED" as A = 0 and the C flag is
                        \ clear (as we passed through the BCS above)

 CPX #17                \ If X = 17 then we just lost the E.C.M., so jump to ou1
 BEQ ou1                \ to print the relevant message, which will be
                        \ "E.C.M.SYSTEM DESTROYED" as A = 0 and the C flag is
                        \ set from the CPX

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Minor

 TXA                    \ Print recursive token 48 + A as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 BNE MESS               \ ITEMS") as the C flag is clear, so this prints the
                        \ destroyed item's name, followed by " DESTROYED" (as we
                        \ set bit 1 of the de flag above), and returns from the
                        \ subroutine using a tail call

ELIF _MASTER_VERSION OR _NES_VERSION

 TXA                    \ Print recursive token 48 + A as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 JMP MESS               \ ITEMS") as the C flag is clear, so this prints the
                        \ destroyed item's name, followed by " DESTROYED" (as we
                        \ set bit 1 of the de flag above), and returns from the
                        \ subroutine using a tail call

ELIF _ELITE_A_VERSION

                        \ If we get here then X is in the range 0-16 or 18-22

 TXA                    \ Copy the value of X into A

 BCC cargo_mtok         \ If X < 17 then we just lost some cargo (as opposed to
                        \ equipment), so jump to cargo_mtok to print the name of
                        \ the cargo whose number is in A, plus " DESTROYED", and
                        \ return from the subroutine using a tail call

                        \ If we get here then X (and A) are in the range 18-22

 CMP #18                \ If A is not 18, jump down to equip_mtok with A in the
 BNE equip_mtok         \ range 19-22 and the C flag set from the CMP, to print
                        \ token 113 ("HYPERSPACE UNIT") through 116 ("GALACTIC
                        \ HYPERSPACE")

 LDA #111-107-1         \ Otherwise A is 18, so we have lost the fuel scoops, so
                        \ set A to 111-107-1 = 3 and the C flag set from the CMP
                        \ to print token 111 ("FUEL SCOOPS")

ENDIF

.ou1

IF NOT(_ELITE_A_VERSION)

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

ELIF _ELITE_A_VERSION

 ADC #107-93            \ We can reach here with three values of A and the C
                        \ flag, and then add 93 below to print the following
                        \ tokens:
                        \
                        \   A = 0, C flag clear = token 107 ("I.F.F.SYSTEM")
                        \   A = 0, C flag set   = token 108 ("E.C.M.SYSTEM")
                        \   A = 3, C flag set   = token 111 ("FUEL SCOOPS")

.equip_mtok

 ADC #93                \ We can either reach here from above, or jump straight
                        \ here with A = 19-22 and the C flag set, in which case
                        \ adding 93 will give us token 113 ("HYPERSPACE UNIT")
                        \ through 116 ("GALACTIC HYPERSPACE ")

 INC new_hold           \ We just lost a piece of equipment, so increment the
                        \ amount of free space in the hold

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT \ Minor

 BNE MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JMP MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ELIF _ELITE_A_VERSION

 BNE MESS               \ Print recursive token A as an in-flight message,
                        \ followed by " DESTROYED", and return from the
                        \ subroutine using a tail call

ELIF _NES_VERSION

.ouch1

 JSR MESS               \ Print recursive token A ("ENERGY BOMB", "ENERGY UNIT"
                        \ or "DOCKING COMPUTERS") as an in-flight message,
                        \ followed by " DESTROYED"

 JMP UpdateIconBar_b3   \ ???

.out

 RTS                    \ Return from the subroutine

ENDIF

