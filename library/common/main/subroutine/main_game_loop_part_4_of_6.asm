\ ******************************************************************************
\
IF NOT(_ELITE_A_6502SP_PARA)
\       Name: Main game loop (Part 4 of 6)
ELIF _ELITE_A_6502SP_PARA
\       Name: Main game loop for flight (Part 4 of 6)
ENDIF
\       Type: Subroutine
\   Category: Main loop
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Potentially spawn a lone bounty hunter, a Thargoid, or up to four
\             pirates
ELIF _ELECTRON_VERSION
\    Summary: Potentially spawn a lone bounty hunter or up to four pirates
ENDIF
\  Deep dive: Program flow of the main game loop
\             Ship data blocks
\
\ ------------------------------------------------------------------------------
\
\ This section covers the following:
\
IF _CASSETTE_VERSION \ Comment
\   * Potentially spawn (35% chance) either a lone bounty hunter (a Mamba,
\     Python or Cobra Mk III), a Thargoid, or a group of up to 4 pirates
\     (Sidewinders and/or Mambas)
ELIF _ELECTRON_VERSION
\   * Potentially spawn (35% chance) either a lone bounty hunter (a Mamba,
\     Python or Cobra Mk III), or a group of up to 4 pirates (Sidewinders and/or
\     Mambas)
ELIF _DISC_FLIGHT OR _ELITE_A_VERSION
\   * Potentially spawn (47% chance) either a lone bounty hunter (a Cobra Mk
\     III, Asp Mk II, Python or Fer-de-lance), a Thargoid, or a group of up to 4
\     pirates (a mix of Sidewinders, Mambas, Kraits, Adders, Geckos, Cobras Mk I
\     and III, and Worms)
\
\   * Also potentially spawn a Constrictor if this is the mission 1 endgame, or
\     Thargoids if mission 2 is in progress
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   * Potentially spawn (35% chance) either a lone bounty hunter (a Cobra Mk
\     III, Asp Mk II, Python or Fer-de-lance), a Thargoid, or a group of up to 4
\     pirates (a mix of Sidewinders, Mambas, Kraits, Adders, Geckos, Cobras Mk I
\     and III, and Worms)
\
\   * Also potentially spawn a Constrictor if this is the mission 1 endgame, or
\     Thargoids if mission 2 is in progress
ENDIF
\
IF _ELITE_A_VERSION
\ Other entry points:
\
\   hordes              Spawn a pack of ships, made up of ships from type A to
\                       type A + X, with the pack size normally being one to
\                       four ships, but rarely being up to eight ships
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 DEC EV                 \ Decrement EV, the extra vessels spawning delay, and
 BPL MLOOP              \ jump to MLOOP if it is still positive, so we only
                        \ do the following when the EV counter runs down

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 DEC EV                 \ Decrement EV, the extra vessels spawning delay, and
 BPL MLOOPS             \ jump to MLOOPS if it is still positive, so we only
                        \ do the following when the EV counter runs down

ENDIF

 INC EV                 \ EV is negative, so bump it up again, setting it back
                        \ to 0

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Enhanced: In mission 2, after picking up the plans, there's an extra 22% chance that a Thargoid will spawn (this is on top of the normal spawning rate of pirates, bounty hunters and Thargoids)

 LDA TP                 \ Fetch bits 2 and 3 of TP, which contain the status of
 AND #%00001100         \ mission 2

 CMP #%00001000         \ If bit 3 is set and bit 2 is clear, keep going to
 BNE nopl               \ spawn a Thargoid as we are transporting the plans in
                        \ mission 2 and the Thargoids are trying to stop us,
                        \ otherwise jump to nopl to skip spawning a Thargoid

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Master: In the disc and 6502SP versions there's a 22% chance of spawning a Thargoid during the spawning loop in part 4, while it's a 14% chance in the Master version

 JSR DORND              \ Set A and X to random numbers

 CMP #200               \ If the random number in A < 200 (78% chance), jump to
 BCC nopl               \ nopl to skip spawning a Thargoid

.fothg2

 JSR GTHG               \ Call GTHG to spawn a Thargoid ship and a Thargon
                        \ companion

.nopl

ELIF _MASTER_VERSION

 JSR DORND              \ Set A and X to random numbers

 CMP #220               \ If the random number in A < 220 (86% chance), jump to
 BCC nopl               \ nopl to skip spawning a Thargoid

.fothg2

 JSR GTHG               \ Call GTHG to spawn a Thargoid ship and a Thargon
                        \ companion

.nopl

ENDIF

 JSR DORND              \ Set A and X to random numbers

 LDY gov                \ If the government of this system is 0 (anarchy), jump
 BEQ LABEL_2            \ straight to LABEL_2 to start spawning pirates or a
                        \ lone bounty hunter

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the disc there's a 47% chance of spawning a group of pirates or a lone bounty hunter, while in the other versions there's a 35% chance

 CMP #90                \ If the random number in A >= 90 (65% chance), jump to
 BCS MLOOP              \ MLOOP to stop spawning (so there's a 35% chance of
                        \ spawning pirates or a lone bounty hunter)

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION

 CMP #120               \ If the random number in A >= 120 (53% chance), jump to
 BCS MLOOPS             \ MLOOPS to stop spawning (so there's a 47% chance of
                        \ spawning pirates or a lone bounty hunter)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 CMP #90                \ If the random number in A >= 90 (65% chance), jump to
 BCS MLOOPS             \ MLOOPS to stop spawning (so there's a 35% chance of
                        \ spawning pirates or a lone bounty hunter)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 AND #7                 \ Reduce the random number in A to the range 0-7, and
 CMP gov                \ if A is less than government of this system, jump
 BCC MLOOP              \ to MLOOP to stop spawning (so safer governments with
                        \ larger gov numbers have a greater chance of jumping
                        \ out, which is another way of saying that more
                        \ dangerous systems spawn pirates and bounty hunters
                        \ more often)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

 AND #7                 \ Reduce the random number in A to the range 0-7, and
 CMP gov                \ if A is less than government of this system, jump
 BCC MLOOPS             \ to MLOOPS to stop spawning (so safer governments with
                        \ larger gov numbers have a greater chance of jumping
                        \ out, which is another way of saying that more
                        \ dangerous systems spawn pirates and bounty hunters
                        \ more often)

ENDIF

.LABEL_2

IF _6502SP_VERSION \ Label

                        \ In the 6502 Second Processor version, the LABEL_2
                        \ label is actually ` (a backtick), but that doesn't
                        \ compile in BeebAsm and it's pretty cryptic, so
                        \ instead this version sticks with the label LABEL_2
                        \ from the cassette version

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \ Now to spawn a lone bounty hunter, a Thargoid or a
                        \ group of pirates
ELIF _ELECTRON_VERSION
                        \ Now to spawn a lone bounty hunter or a group of
                        \ pirates
ENDIF

IF NOT(_ELITE_A_VERSION)

 JSR Ze                 \ Call Ze to initialise INWK to a potentially hostile
                        \ ship, and set A and X to random values

ENDIF

IF _CASSETTE_VERSION \ Standard: In the cassette version there's a 13% chance of spawning a group of pirates, while in the other versions there's a 61% chance

 CMP #200               \ If the random number in A >= 200 (13% chance), jump
 BCS mt1                \ to mt1 to spawn pirates, otherwise keep going to
                        \ spawn a lone bounty hunter or a Thargoid

ELIF _ELECTRON_VERSION

 CMP #200               \ If the random number in A >= 200 (13% chance), jump
 BCS mt1                \ to mt1 to spawn pirates, otherwise keep going to
                        \ spawn a lone bounty hunter

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 CMP #100               \ If the random number in A >= 100 (61% chance), jump
 BCS mt1                \ to mt1 to spawn pirates, otherwise keep going to
                        \ spawn a lone bounty hunter or a Thargoid

ELIF _ELITE_A_VERSION

 CPX #&64               \ AJD
 BCS mt1

ENDIF

 INC EV                 \ Increase the extra vessels spawning counter, to
                        \ prevent the next attempt to spawn extra vessels

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: In the enhanced versions, lone bounty hunters can be in a Cobra Mk III (pirate), Asp Mk II, Python (pirate) or Fer-de-lance, while in the cassette version they can be in a Mamba, Python or Cobra Mk III

 AND #3                 \ Set A = Y = random number in the range 3-6, which
 ADC #3                 \ we will use to determine the type of ship
 TAY

                        \ We now build the AI flag for this ship in A

 TXA                    \ First, copy the random number in X to A

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 AND #3                 \ Set A = random number in the range 0-3, which we
                        \ will now use to determine the type of ship

 ADC #CYL2              \ Add A to #CYL2 (we know the C flag is clear as we
                        \ passed through the BCS above), so A is now one of the
                        \ lone bounty hunter ships, i.e. Cobra Mk III (pirate),
                        \ Asp Mk II, Python (pirate) or Fer-de-lance

 TAY                    \ Copy the new ship type to Y

 JSR THERE              \ Call THERE to see if we are in the Constrictor's
                        \ system in mission 1

 BCC NOCON              \ If the C flag is clear then we are not in the
                        \ Constrictor's system, so skip to NOCON

 LDA #%11111001         \ Set the AI flag of this ship so that it has E.C.M.,
 STA INWK+32            \ has a very high aggression level of 28 out of 31, is
                        \ hostile, and has AI enabled - nasty stuff!

 LDA TP                 \ Fetch bits 0 and 1 of TP, which contain the status of
 AND #%00000011         \ mission 1

 LSR A                  \ Shift bit 0 into the C flag

 BCC NOCON              \ If bit 0 is clear, skip to NOCON as mission 1 is not
                        \ in progress

 ORA MANY+CON           \ Bit 0 of A now contains bit 1 of TP, so this will be
                        \ set if we have already completed mission 1, so this OR
                        \ will be non-zero if we have either completed mission
                        \ 1, or there is already a Constrictor in our local
                        \ bubble of universe (in which case MANY+CON will be
                        \ non-zero)

 BEQ YESCON             \ If A = 0 then mission 1 is in progress, we haven't
                        \ completed it yet, and there is no Constrictor in the
                        \ vicinity, so jump to YESCON to spawn the Constrictor

.NOCON

ELIF _ELITE_A_VERSION

 AND #3                 \ Set A = random number in the range 0-3, which we
                        \ will now use to determine the type of ship

 ADC #CYL2+1            \ Add A to #CYL2 (we know the C flag is clear as we
                        \ passed through the BCS above), so A is now one of the
                        \ lone bounty hunter ships, i.e. Cobra Mk III (pirate),
                        \ Asp Mk II, Python (pirate) or Fer-de-lance AJD

 TAY                    \ Copy the new ship type to Y

 JSR THERE              \ Call THERE to see if we are in the Constrictor's
                        \ system in mission 1

 BCC NOCON              \ If the C flag is clear then we are not in the
                        \ Constrictor's system, so skip to NOCON

 LDA #%11111001         \ Set the AI flag of this ship so that it has E.C.M.,
 STA INWK+32            \ has a very high aggression level of 28 out of 31, is
                        \ hostile, and has AI enabled - nasty stuff!

 LDA TP                 \ Fetch bits 0 and 1 of TP, which contain the status of
 AND #%00000011         \ mission 1

 LSR A                  \ Shift bit 0 into the C flag

 BCC NOCON              \ If bit 0 is clear, skip to NOCON as mission 1 is not
                        \ in progress

 ORA MANY+CON           \ Bit 0 of A now contains bit 1 of TP, so this will be
                        \ set if we have already completed mission 1, so this OR
                        \ will be non-zero if we have either completed mission
                        \ 1, or there is already a Constrictor in our local
                        \ bubble of universe (in which case MANY+CON will be
                        \ non-zero)

 BEQ YESCON             \ If A = 0 then mission 1 is in progress, we haven't
                        \ completed it yet, and there is no Constrictor in the
                        \ vicinity, so jump to YESCON to spawn the Constrictor

.NOCON

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: In the advanced versions, lone bounty hunters are always spawned as hostile

 LDA #%00000100         \ Set bit 2 of the NEWB flags and clear all other bits,
 STA NEWB               \ so the ship we are about to spawn is hostile

                        \ We now build the AI flag for this ship in A

 JSR DORND              \ Set A and X to random numbers

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Standard: Lone bounty hunters in the disc version don't have E.C.M., while in the other versions they have a a 22% chance of having E.C.M.

 CMP #200               \ First, set the C flag if X >= 200 (22% chance)

 ROL A                  \ Set bit 0 of A to the C flag (i.e. there's a 22%
                        \ chance of this ship having E.C.M.)

 ORA #%11000000         \ Set bits 6 and 7 of A, so the ship is hostile (bit 6)
                        \ and has AI (bit 7)

ENDIF

IF _CASSETTE_VERSION \ Platform

 CPY #6                 \ If Y = 6 (i.e. a Thargoid), jump down to the tha
 BEQ tha                \ routine in part 6 to decide whether or not to spawn it
                        \ (where there's a 22% chance of this happening)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 STA INWK+32            \ Store A in the AI flag of this ship

 TYA                    \ Add a new ship of type Y to the local bubble, so
 JSR NWSHP              \ that's a Mamba, Cobra Mk III or Python

ELIF _6502SP_VERSION OR _MASTER_VERSION

 STA INWK+32            \ Store A in the AI flag of this ship

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Enhanced: The Constrictor only spawns in its home system, during the mission 1 endgame, and then it only spawns once... though it can still appear in the ship hanger from time to time

 TYA

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &1F, or BIT &1FA9, which does nothing apart
                        \ from affect the flags

.YESCON

 LDA #CON               \ If we jump straight here, we are in the mission 1
                        \ endgame and it's time to spawn the Constrictor, so
                        \ set A to the Constrictor's type

.focoug

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Comment

 JSR NWSHP              \ Spawn the new ship, whether it's a pirate, Thargoid or
                        \ Constrictor

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR NWSHP              \ Spawn the new ship, whether it's a pirate, Thargoid,
                        \ Cougar or Constrictor

ENDIF

.mj1

IF NOT(_ELITE_A_6502SP_PARA)

 JMP MLOOP              \ Jump down to MLOOP, as we are done spawning ships

ELIF _ELITE_A_6502SP_PARA

 JMP MLOOP_FLIGHT       \ Jump down to MLOOP_FLIGHT, as we are done spawning
                        \ ships

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: When considering spawning a Cougar or a Thargoid instead of a cop, the advanced versions spawn a Thargoid 96.8% of the time, and a Cougar 3.2% of the time

.fothg

 LDA K%+6               \ Fetch the z_lo coordinate of the first ship in the K%
 AND #%00111110         \ block (i.e. the planet) and extract bits 1-5

 BNE fothg2             \ If any of bits 1-5 are set (96.8% chance), jump up to
                        \ fothg2 to spawn a Thargoid

                        \ If we get here then we're going to spawn a Cougar, a
                        \ very rare event indeed. How rare? Well, all the
                        \ following have to happen in sequence:
                        \
                        \  * Main loop iteration = 0 (1 in 256 iterations)
                        \  * Skip asteroid spawning (87% chance)
                        \  * Skip cop spawning (0.4% chance)
                        \  * Skip Thargoid spawning (3.2% chance)
                        \
                        \ so the chances of spawning a Cougar on any single main
                        \ loop iteration are slim, to say the least

 LDA #18                \ Give the ship we're about to spawn a speed of 27
 STA INWK+27

 LDA #%01111001         \ Give it an E.C.M., and make it hostile and pretty
 STA INWK+32            \ aggressive (though don't give it AI)

 LDA #COU               \ Set the ship type to a Cougar and jump up to focoug
 BNE focoug             \ to spawn it

ENDIF

.mt1

IF NOT(_ELITE_A_VERSION)

 AND #3                 \ It's time to spawn a group of pirates, so set A to a
                        \ random number in the range 0-3, which will be the
                        \ loop counter for spawning pirates below (so we will
                        \ spawn 1-4 pirates)

 STA EV                 \ Delay further spawnings by this number

 STA XX13               \ Store the number in XX13, the pirate counter

.mt3

 JSR DORND              \ Set A and X to random numbers

ELIF _ELITE_A_VERSION

 LDA #SH3               \ Fall through into hordes to spawn a pack of ships from
 LDX #7                 \ type 17 to 24, i.e. Sidewinder to Cobra Mk III
                        \ (pirate)

.hordes

                        \ This routine spawns a pack of ships, made up of ships
                        \ from type A to type A + X, with the pack size normally
                        \ being one to four ships, but rarely being up to eight
                        \ ships
                        \
                        \ Let's call A the "base ship type", and X the "ship
                        \ type range"

 STA horde_base+1       \ Modify the ADC instruction at horde_base so that it
                        \ adds the base ship type given in A

 STX horde_mask+1       \ Modify the ADC instruction at horde_mask so that it
                        \ ANDs the ship type range given in X

 JSR DORND              \ Set A and X to random numbers

 CMP #248               \ If A >= 248 (3.1% chance), jump to horde_large so we
 BCS horde_large        \ potentially spawn a larger pack (i.e. up to 8 ships)

 STA XX13               \ We are going to spawn a smaller pack (i.e. up to 4
 TXA                    \ ships), so set:
 AND XX13               \
 AND #3                 \   A = A AND X AND 3
                        \
                        \ to give a random pack size of 0-3, with a greater
                        \ chance of the smaller numbers than the larger ones
                        \ (due to the AND). This will be our pack size, which
                        \ won't be affected further by the following AND
                        \ instruction

.horde_large

 AND #7                 \ If we are going to spawn a larger pack, reduce the
                        \ random number in A to the range 0-7, with an equal
                        \ chance of each of the numbers. This will be our pack
                        \ size

                        \ By this point our pack size is in A, and is either
                        \ 0-3 or 0-7

 STA EV                 \ Delay further spawnings by this number

 STA XX13               \ Store the number in XX13, the pack size counter

.mt3

 JSR DORND              \ Set A and X to random numbers

 STA T                  \ Set A = A AND X
 TXA                    \
 AND T                  \ which is in the range 0-255, but with a greater chance
                        \ of being a smaller number (due to the AND)

.horde_mask

 AND #&FF               \ This instruction gets modified so that it ANDs the
                        \ ship type range given in the argument X to the
                        \ hordes routine, i.e. it turns into AND #type_range,
                        \ which reduces our random number to be between 0 and
                        \ the ship type range (so if we add this number to the
                        \ base ship type, it will pick a random ship type from
                        \ within the range A to A + X, where A and X are the
                        \ arguments to the original call to hordes

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: When spawning a pack of pirates in the enhanced versions, the chances of each ship type appearing in the pack are slightly different, with the most likely candidates appearing first in this list: Sidewinder, Mamba, Krait, Adder, Gecko, Cobra Mk I, Worm or Cobra Mk III (pirate)

 AND #3                 \ Set A to a random number in the range 0-3

 ORA #1                 \ Set A to %01 or %11 (Sidewinder or Mamba)

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 STA T                  \ Set T to a random number

 JSR DORND              \ Set A and X to random numbers

 AND T                  \ Set A to the AND of two random numbers, so each bit
                        \ has 25% chance of being set which makes the chances
                        \ of a smaller number higher

 AND #7                 \ Reduce A to a random number in the range 0-7, though
                        \ with a bigger chance of a smaller number in this range

ENDIF

IF _DISC_FLIGHT \ Platform

 STA CPIR               \ Set CPIR to this random number in the range 0-7

.more

 LDA CPIR               \ Set A to the ship type in CPIR

ELIF _ELITE_A_VERSION

 STA CPIR               \ Set CPIR to our random number in the range 0 to
                        \ the ship type

.more

 LDA CPIR               \ Set A to the ship type in CPIR

ENDIF

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Enhanced: In the enhanced versions, a pack-hunting pirate will fly a Sidewinder, Mamba, Krait, Adder, Gecko, Cobra Mk I, Worm or Cobra Mk III (pirate), while in the cassette version you'll only find them in the cockpit of a Sidewinder or Mamba

 ADC #PACK              \ #PACK is set to #SH3, the ship type for a Sidewinder,
                        \ so this sets our new ship type to one of the pack
                        \ hunters, namely a Sidewinder, Mamba, Krait, Adder,
                        \ Gecko, Cobra Mk I, Worm or Cobra Mk III (pirate)

ELIF _ELITE_A_VERSION

 CLC                    \ Clear the C flag for the addition below

.horde_base

 ADC #0                 \ This instruction gets modified so that it adds the
                        \ ship type given in the argument A to the hordes
                        \ routine, i.e. it turns into ADC #ship_type, so this
                        \ sets A to a ship type in the range we want

 INC INWK+27            \ Increment the speed of the ship we are about to spawn,
                        \ so later ships in the pack go faster

 INC INWK+1             \ Increment the x_hi coordinate of the ship we are about
                        \ to spawn, so later ships in the pack are spread out to
                        \ the sides

 INC INWK+4             \ Increment the y_hi coordinate of the ship we are about
                        \ to spawn, so later ships in the pack are spread out
                        \ to the top and bottom

ENDIF

 JSR NWSHP              \ Try adding a new ship of type A to the local bubble

IF _ELITE_A_VERSION

 CMP #24                \ This compares the value of A (which is set to the
                        \ x_sign value of the spawned ship by NWSHP), but the
                        \ result isn't used anywhere, as CMP affects the Z and N
                        \ flags (not the C flag), and these same flags will be
                        \ overwritten by the two DEC instructions below... so
                        \ instruction has no effect

ENDIF

IF _DISC_FLIGHT \ Platform

 BCS P%+7               \ If the ship was successfully added, skip the following
                        \ two instructions

 DEC CPIR               \ The ship wasn't added, which might be because the ship
                        \ blueprint for this ship type isn't in the currently
                        \ loaded ship blueprints file, so decrement CPIR to
                        \ point to the previous ship type, so we can try
                        \ spawning that type of pirate instead

 BPL more               \ Loop back to more to have another go at spawning this
                        \ pirate, until we have tried spawning a Sidewinder when
                        \ CPIR is 0, in which case give up and move on to the
                        \ next pirate to spawn

ELIF _ELITE_A_VERSION

 BCS P%+7               \ If the ship was successfully added, skip the following
                        \ two instructions

 DEC CPIR               \ The ship wasn't added, which might be because the ship
                        \ blueprint for this ship type isn't in the currently
                        \ loaded ship blueprints file, so decrement CPIR to
                        \ point to the previous ship type, so we can try
                        \ spawning that type of ship instead

 BPL more               \ Loop back to more to have another go at spawning this
                        \ ship, until CPIR is 0, in which case we have tried
                        \ spawning all the ship types in the range, so give up
                        \ and move on to the next pirate to spawn

ENDIF

IF NOT(_ELITE_A_VERSION)

 DEC XX13               \ Decrement the pirate counter

 BPL mt3                \ If we need more pirates, loop back up to mt3,
                        \ otherwise we are done spawning, so fall through into
                        \ the end of the main loop at MLOOP

ELIF _ELITE_A_VERSION

 DEC XX13               \ Decrement the pack size counter

 BPL mt3                \ If we need more ships, loop back up to mt3,
                        \ otherwise we are done spawning, so fall through into
                        \ the end of the main loop at MLOOP

ENDIF

