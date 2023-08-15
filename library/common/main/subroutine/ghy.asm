\ ******************************************************************************
\
\       Name: Ghy
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform a galactic hyperspace jump
\  Deep dive: Twisting the system seeds
\             Galaxy and system seeds
\
\ ------------------------------------------------------------------------------
\
\ Engage the galactic hyperdrive. Called from the hyp routine above if CTRL-H is
\ being pressed.
\
\ This routine also updates the galaxy seeds to point to the next galaxy. Using
\ a galactic hyperdrive rotates each seed byte to the left, rolling each byte
\ left within itself like this:
\
\   01234567 -> 12345670
\
\ to get the seeds for the next galaxy. So after 8 galactic jumps, the seeds
\ roll round to those of the first galaxy again.
\
\ We always arrive in a new galaxy at galactic coordinates (96, 96), and then
\ find the nearest system and set that as our location.
\
\ Other entry points:
\
\   zZ+1                Contains an RTS
\
\ ******************************************************************************

.Ghy

IF _CASSETTE_VERSION \ Other: Group B: The cassette version has a bug where performing a galactic hyperspace can drop you in the middle of nowhere in the next galaxy, with no escape. The bug is in the source disc, but the text sources contain an attempted fix for the bug, which doesn't work, but which was refined in the other versions to fix the issue.

IF _TEXT_SOURCES

 JSR TT111              \ Call TT111 to set the current system to the nearest
                        \ system to (QQ9, QQ10), and put the seeds of the
                        \ nearest system into QQ15 to QQ15+5
                        \
                        \ This appears to be a failed attempt to fix a bug in
                        \ the cassette version, where the galactic hyperdrive
                        \ will take us to coordinates (96, 96) in the new
                        \ galaxy, even if there isn't actually a system there,
                        \ so if we jump when you are low on fuel, it is
                        \ possible to get stuck in the middle of nowhere when
                        \ changing galaxy
                        \
                        \ All the other versions contain a fix for this bug that
                        \ involves adding an extra JSR TT111 instruction after
                        \ the coordinates are set to (96, 96) below, which finds
                        \ the nearest system to those coordinates  and sets that
                        \ as the current system
                        \
                        \ The cassette version on the original source disc
                        \ doesn't contain this instruction, and although the
                        \ text sources do, it's in the wrong place at the start
                        \ of the Ghy routine, as the fix only works if it's done
                        \ after the new coordinates are set, not before

ENDIF

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED OR _NES_VERSION \ Label

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ hy5                \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as hy5 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ELIF _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ zZ+1               \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as zZ+1 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ELIF _ELITE_A_VERSION

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ zZ+1               \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as zZ+1 contains an RTS)

 INC new_hold           \ Free up one tonne of space in the hold, as we have
                        \ just used up the galactic hyperdrive

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ENDIF

IF _CASSETTE_VERSION \ Other: Group A: Part of the bug fix for the "hyperspace while docking" bug (see below)

 STX QQ8                \ Set the distance to the selected system in QQ8(1 0)
 STX QQ8+1              \ to 0

ELIF _MASTER_VERSION OR _6502SP_VERSION

\STX QQ8                \ These instructions are commented out in the original
\STX QQ8+1              \ source

ENDIF

 STX GHYP               \ The galactic hyperdrive is a one-use item, so set GHYP
                        \ to 0 so we no longer have one fitted

 STX FIST               \ Changing galaxy also clears our criminal record, so
                        \ set our legal status in FIST to 0 ("clean")

IF _ELITE_A_VERSION

 STX cmdr_cour          \ Reset the special cargo delivery mission timer in
 STX cmdr_cour+1        \ cmdr_cour(1 0)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The original versions of Elite start the galactic hyperspace countdown from 15, just like the normal hyperspace countdown, but the advanced versions don't muck about and start the galactic hyperspace countdown from 2

 JSR wW                 \ Call wW to start the hyperspace countdown

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #2                 \ Call wW2 with A = 2 to start the hyperspace countdown,
 JSR wW2                \ but starting the countdown from 2

ELIF _NES_VERSION

 JSR UpdateIconBar_b3   \ ???

 LDA #1
 JSR wW2

ENDIF

 LDX #5                 \ To move galaxy, we rotate the galaxy's seeds left, so
                        \ set a counter in X for the 6 seed bytes

 INC GCNT               \ Increment the current galaxy number in GCNT

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the Master version, the internal galaxy number can be set to be greater than 16, and it will stay high even if you jump to the next galaxy (though it isn't clear what this is for, as the game doesn't set the galaxy to more than 7 at any point, so perhaps this was for an expansion that never happened)

 LDA GCNT               \ Set GCNT = GCNT mod 8, so we jump from galaxy 7 back
 AND #7                 \ to galaxy 0 (shown in-game as going from galaxy 8 back
 STA GCNT               \ to the starting point in galaxy 1)

ELIF _MASTER_VERSION OR _NES_VERSION

 LDA GCNT               \ Clear bit 3 of GCNT, so we jump from galaxy 7 back
 AND #%11110111         \ to galaxy 0 (shown in-game as going from galaxy 8 back
 STA GCNT               \ to the starting point in galaxy 1). We also retain any
                        \ set bits in the high nibble, so if the galaxy number
                        \ is manually set to 16 or higher, it will stay high
                        \ (though the upper nibble doesn't seem to get set by
                        \ the game at any point, so it isn't clear what this is
                        \ for, though Lave in galaxy 16 does show a unique
                        \ system description override, so something is going on
                        \ here...)

ENDIF

.G1

 LDA QQ21,X             \ Load the X-th seed byte into A

 ASL A                  \ Set the C flag to bit 7 of the seed

 ROL QQ21,X             \ Rotate the seed in memory, which will add bit 7 back
                        \ in as bit 0, so this rolls the seed around on itself

 DEX                    \ Decrement the counter

 BPL G1                 \ Loop back for the next seed byte, until we have
                        \ rotated them all

IF _CASSETTE_VERSION OR _MASTER_VERSION OR _6502SP_VERSION \ Comment

\JSR DORND              \ This instruction is commented out in the original
                        \ source, and would set A and X to random numbers, so
                        \ perhaps the original plan was to arrive in each new
                        \ galaxy in a random place?

ENDIF

.zZ

 LDA #96                \ Set (QQ9, QQ10) to (96, 96), which is where we always
 STA QQ9                \ arrive in a new galaxy (the selected system will be
 STA QQ10               \ set to the nearest actual system later on)

 JSR TT110              \ Call TT110 to show the front space view

IF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Other: See group B

 JSR TT111              \ Call TT111 to set the current system to the nearest
                        \ system to (QQ9, QQ10), and put the seeds of the
                        \ nearest system into QQ15 to QQ15+5
                        \
                        \ This call fixes a bug in the cassette version, where
                        \ the galactic hyperdrive will take us to coordinates
                        \ (96, 96) in the new galaxy, even if there isn't
                        \ actually a system there, so if we jump when we are
                        \ low on fuel, it is possible to get stuck in the
                        \ middle of nowhere when changing galaxy
                        \
                        \ This call sets the current system correctly, so we
                        \ always arrive at the nearest system to (96, 96)

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Other: See group A

 LDX #5                 \ We now want to copy those seeds into safehouse, so we
                        \ so set a counter in X to copy 6 bytes

.dumdeedum

 LDA QQ15,X             \ Copy the X-th byte of QQ15 into the X-th byte of
 STA safehouse,X        \ safehouse

 DEX                    \ Decrement the loop counter

 BPL dumdeedum          \ Loop back to copy the next byte until we have copied
                        \ all six seed bytes

ENDIF

IF _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Other: See group A

 LDX #0                 \ Set the distance to the selected system in QQ8(1 0)
 STX QQ8                \ to 0
 STX QQ8+1

ENDIF

IF NOT(_NES_VERSION)

 LDA #116               \ Print recursive token 116 (GALACTIC HYPERSPACE ")
 JSR MESS               \ as an in-flight message

ELIF _NES_VERSION

 LDY #&16               \ ???
 JSR NOISE

ENDIF

                        \ Fall through into jmp to set the system to the
                        \ current system and return from the subroutine there

IF _ELITE_A_6502SP_PARA

 JMP jmp                \ Set the current system to the selected system and
                        \ return from the subroutine using a tail call

ENDIF

