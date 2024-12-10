\ ******************************************************************************
\
\       Name: Main flight loop (Part 8 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: For each nearby ship: Process us potentially scooping this item
\  Deep dive: Program flow of the main game loop
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

IF _CASSETTE_VERSION \ Enhanced: In the enhanced versions, the high nibble of the first byte of each ship blueprint defines whether a ship is scoopable, and the type of item that we get when we scoop it (so scooping Thargons gives alien items, and so on). The cassette version implements this functionality using hard-coded conditional statements, while the enhanced versions support more flexibility by using the ship data block to determine scoopability

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

ELIF _ELECTRON_VERSION

 LDA #3                 \ Set A to 3 to denote we may be scooping an escape pod

 CPX #ESC               \ If this is not an escape pod, jump to oily to randomly
 BNE oily               \ decide the canister's contents

 BEQ slvy2              \ This is an escape pod, so jump to slvy2 with A set to
                        \ 3, so we scoop up the escape pod as slaves

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 CPX #OIL               \ If this is a cargo canister, jump to oily to randomly
 BEQ oily               \ decide the canister's contents

 LDY #0                 \ Fetch byte #0 of the ship's blueprint
 LDA (XX0),Y

 LSR A                  \ Shift it right four times, so A now contains the high
 LSR A                  \ nibble (i.e. bits 4-7)
 LSR A
 LSR A

 BEQ MA58               \ If A = 0, jump to MA58 to skip all the docking and
                        \ scooping checks

                        \ Only the Thargon, alloy plate, splinter and escape pod
                        \ have non-zero high nibbles in their blueprint byte #0
                        \ so if we get here, our ship is one of those, and the
                        \ high nibble gives the market item number of the item
                        \ when scooped, less 1

 ADC #1                 \ Add 1 to the high nibble to get the market item
                        \ number

 BNE slvy2              \ Skip to slvy2 so we scoop the ship as a market item

ELIF _NES_VERSION

 CPX #OIL               \ If this is a cargo canister, jump to oily to randomly
 BEQ oily               \ decide the canister's contents

 CPX #ESC               \ If this is an escape pod, jump to MA58 to skip all the
 BEQ MA58               \ docking and scooping checks

 LDY #0                 \ Fetch byte #0 of the ship's blueprint
 JSR GetShipBlueprint

 LSR A                  \ Shift it right four times, so A now contains the high
 LSR A                  \ nibble (i.e. bits 4-7)
 LSR A
 LSR A

 BEQ MA58               \ If A = 0, jump to MA58 to skip all the docking and
                        \ scooping checks

                        \ Only the Thargon, alloy plate, splinter and escape pod
                        \ have non-zero high nibbles in their blueprint byte #0
                        \ so if we get here, our ship is one of those, and the
                        \ high nibble gives the market item number of the item
                        \ when scooped, less 1

 ADC #1                 \ Add 1 to the high nibble to get the market item
                        \ number

 BNE slvy2              \ Skip to slvy2 so we scoop the ship as a market item

ENDIF

.oily

IF NOT(_ELITE_A_VERSION)

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #7                 \ random number in the range 0-7

ELIF _ELITE_A_VERSION

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #15                \ random number in the range 0-15

ENDIF

.slvy2

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment

                        \ By the time we get here, we are scooping, and A
                        \ contains the type of item we are scooping (a random
                        \ number 0-7 if we are scooping a cargo canister, 3 if
                        \ we are scooping an escape pod, or 16 if we are
                        \ scooping a Thargon). These numbers correspond to the
                        \ relevant market items (see QQ23 for a list), so a
                        \ cargo canister can contain anything from food to
                        \ computers, while escape pods contain slaves, and
                        \ Thargons become alien items when scooped

ELIF _ELECTRON_VERSION

                        \ By the time we get here, we are scooping, and A
                        \ contains the type of item we are scooping (a random
                        \ number 0-7 if we are scooping a cargo canister, or 3
                        \ if we are scooping an escape pod). These numbers
                        \ correspond to the relevant market items (see QQ23
                        \ for a list), so a cargo canister can contain
                        \ anything from food to computers, while escape pods
                        \ contain slaves

ELIF _ELITE_A_VERSION

                        \ By the time we get here, we are scooping, and A
                        \ contains the type of item we are scooping (a random
                        \ number 0-15 if we are scooping a cargo canister, 3 if
                        \ we are scooping an escape pod, or 16 if we are
                        \ scooping a Thargon). These numbers correspond to the
                        \ relevant market items (see QQ23 for a list), so a
                        \ cargo canister can contain anything from food to
                        \ gem-stones, while escape pods contain slaves, and
                        \ Thargons become alien items when scooped

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 STA QQ29               \ Call tnpr with the scooped cargo type stored in QQ29
 LDA #1                 \ and A set to 1, to work out whether we have room in
 JSR tnpr               \ the hold for the scooped item (A is preserved by this
                        \ call, and the C flag contains the result)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JSR tnpr1              \ Call tnpr1 with the scooped cargo type stored in A
                        \ to work out whether we have room in the hold for one
                        \ tonne of this cargo (A is set to 1 by this call, and
                        \ the C flag contains the result)

ELIF _ELITE_A_VERSION

 TAX                    \ Copy the type of cargo we are scooping into X

 JSR tnpr1              \ Call tnpr1 to work out whether we have room in the
                        \ hold for the scooped item (the C flag contains the
                        \ result)

ENDIF

IF NOT(_ELITE_A_VERSION)

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

 TYA                    \ Print recursive token 48 + Y as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 JSR MESS               \ ITEMS"), so this prints the scooped item's name

ELIF _ELITE_A_VERSION

 BCS MA58               \ If the C flag is set then we have no room in the hold
                        \ for the scooped item, so jump down to MA58 to skip all
                        \ the docking and scooping checks

 INC QQ20,X             \ Scooping was successful, so increment the number of
                        \ items of type X that we have in the hold

 TXA                    \ Print recursive token 48 + X as an in-flight token,
 ADC #208               \ which will be in the range 48 ("FOOD") to 64 ("ALIEN
 JSR MESS               \ ITEMS"), so this prints the scooped item's name

ENDIF

IF _NES_VERSION

 JSR MakeScoopSound     \ Make the sound of the fuel scoops working

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: In the enhanced version there is a difference between a ship that has been killed and a ship that has docked or been scooped, unlike in the cassette and Electron versions where they are the same thing

 JMP MA60               \ We are done scooping, so jump down to MA60 to set the
                        \ kill flag on the canister, as it no longer exists in
                        \ the local bubble

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 ASL NEWB               \ The item has now been scooped, so set bit 7 of its
 SEC                    \ NEWB flags to indicate this
 ROR NEWB

ELIF _ELITE_A_VERSION

 JSR top_6a             \ The item has now been scooped, so call top_6a to set
                        \ bit 7 of its NEWB flags to indicate this

ENDIF

.MA65

 JMP MA26               \ If we get here, then the ship we are processing was
                        \ too far away to be scooped, docked or collided with,
                        \ so jump to MA26 to skip over the collision routines
                        \ and move on to missile targeting

