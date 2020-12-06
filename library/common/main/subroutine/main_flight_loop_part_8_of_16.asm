\ ******************************************************************************
\
\       Name: Main flight loop (Part 8 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Process us potentially scooping this item
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Continue looping through all the ships in the local bubble, and for each
\     one:
\
\     * Process us potentially scooping this item
\
\ ******************************************************************************

IF _CASSETTE_VERSION

 LDA #3                 \ Set A to 3 to denote we may be scooping an escape pod

 CPX #TGL               \ If ship type < Thargon, i.e. it's a canister, jump
 BCC oily               \ to oily to randomly decide the canister's contents

 BNE slvy2              \ If ship type <> Thargon, i.e. it's an escape pod,
                        \ jump to slvy2 with A set to 3, so we scoop up the
                        \ escape pod as slaves

 LDA #16                \ Otherwise this is a Thargon, so jump to slvy2 with
 BNE slvy2              \ A set to 16, so we scoop up the Thargon as alien items
                        \ (this BNE is effectively a JMP as A will never be
                        \ zero)

ELIF _6502SP_VERSION

 CPX #OIL
 BEQ oily
 LDY #0
 LDA (XX0),Y
 LSR A
 LSR A
 LSR A
 LSR A
 BEQ MA58
 ADC #1
 BNE slvy2

ENDIF

.oily

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #7                 \ random number in the range 0-7

.slvy2

                        \ By the time we get here, we are scooping, and A
                        \ contains the type of item we are scooping (a random
                        \ number 0-7 if we are scooping a cargo canister, 3 if
                        \ we are scooping an escape pod, or 16 if we are
                        \ scooping a Thargon). These numbers correspond to the
                        \ relevant market items (see QQ23 for a list), so a
                        \ cargo canister can contain anything from food to
                        \ computers, while escape pods contain slaves, and
                        \ Thargons become alien items when scooped

IF _CASSETTE_VERSION

 STA QQ29               \ Call tnpr with the scooped cargo type stored in QQ29
 LDA #1                 \ and A set to 1, to work out whether we have room in
 JSR tnpr               \ the hold for the scooped item (A is preserved by this
                        \ call, and the C flag contains the result)

ELIF _6502SP_VERSION

 JSR tnpr1

ENDIF

 LDY #78                \ This instruction has no effect, so presumably it used
                        \ to do something, but didn't get removed

 BCS MA59               \ If the C flag is set then we have no room in the hold
                        \ for the scooped item, so jump down to MA59 make a
                        \ sound to indicate failure, before destroying the
                        \ canister

 LDY QQ29               \ Scooping was successful, so set Y to the type of
                        \ item we just scooped, which we stored in QQ29 above

 ADC QQ20,Y             \ Add A (which we set to 1 above) to the number of items
 STA QQ20,Y             \ of type Y in the cargo hold, as we just successfully
                        \ scooped one canister of type Y

 TYA                    \ Print recursive token 48 + A as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 JSR MESS               \ ITEMS"), so this prints the scooped item's name

IF _CASSETTE_VERSION

 JMP MA60               \ We are done scooping, so jump down to MA60 to set the
                        \ kill flag on the canister, as it no longer exists in
                        \ the local bubble

ELIF _6502SP_VERSION

 ASL NEWB
 SEC
 ROR NEWB

ENDIF

.MA65

 JMP MA26               \ If we get here, then the ship we are processing was
                        \ too far away to be scooped, docked or collided with,
                        \ so jump to MA26 to skip over the collision routines
                        \ and move on to missile targeting

