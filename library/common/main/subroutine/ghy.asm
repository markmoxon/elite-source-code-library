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

IF _CASSETTE_VERSION \ Comment

\JSR TT111              \ This instruction is commented out in the original
                        \ source, and appears in the text cassette code source
                        \ (ELITED.TXT) but not in the BASIC source file on the
                        \ source disc (ELITED). It finds the closest system to
                        \ coordinates (QQ9, QQ10)

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Label

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ hy5                \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as hy5 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ zZ+1               \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as zZ+1 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ENDIF

IF _CASSETTE_VERSION \ Other

 STX QQ8                \ Set the distance to the selected system in QQ8(1 0)
 STX QQ8+1              \ to 0

ENDIF

 STX GHYP               \ The galactic hyperdrive is a one-use item, so set GHYP
                        \ to 0 so we no longer have one fitted

 STX FIST               \ Changing galaxy also clears our criminal record, so
                        \ set our legal status in FIST to 0 ("clean")

IF _CASSETTE_VERSION OR _DISC_VERSION \ Feature: The original versions of Elite start the galactic hyperspace countdown from 15, just like the normal hyperspace countdown, but the 6502SP version doesn't muck about and starts the galactic hyperspace countdown from 2

 JSR wW                 \ Call wW to start the hyperspace countdown

ELIF _6502SP_VERSION

 LDA #2                 \ Call wW2 with A = 2 to start the hyperspace countdown,
 JSR wW2                \ but starting the countdown from 2

ENDIF

 LDX #5                 \ To move galaxy, we rotate the galaxy's seeds left, so
                        \ set a counter in X for the 6 seed bytes

 INC GCNT               \ Increment the current galaxy number in GCNT

 LDA GCNT               \ Set GCNT = GCNT mod 8, so we jump from galaxy 7 back
 AND #7                 \ to galaxy 0 (shown in-game as going from galaxy 8 back
 STA GCNT               \ to the starting point in galaxy 1)

.G1

 LDA QQ21,X             \ Load the X-th seed byte into A

 ASL A                  \ Set the C flag to bit 7 of the seed

 ROL QQ21,X             \ Rotate the seed in memory, which will add bit 7 back
                        \ in as bit 0, so this rolls the seed around on itself

 DEX                    \ Decrement the counter

 BPL G1                 \ Loop back for the next seed byte, until we have
                        \ rotated them all

\JSR DORND              \ This instruction is commented out in the original
                        \ source, and would set A and X to random numbers, so
                        \ perhaps the original plan was to arrive in each new
                        \ galaxy in a random place?

.zZ

 LDA #&60               \ Set (QQ9, QQ10) to (96, 96), which is where we always
 STA QQ9                \ arrive in a new galaxy (the selected system will be
 STA QQ10               \ set to the nearest actual system later on)

 JSR TT110              \ Call TT110 to show the front space view

IF _DISC_VERSION OR _6502SP_VERSION \ Other

 JSR TT111              \ Call TT111 to set the current system to the nearest
                        \ system to (QQ9, QQ10), and put the seeds of the
                        \ nearest system into QQ15 to QQ15+5

ENDIF

IF _6502SP_VERSION \ Other

 LDX #5                 \ We now want to copy those seeds into safehouse, so we
                        \ so set a counter in Xto copy 6 bytes

.dumdeedum

 LDA QQ15,X             \ Copy the X-th byte of QQ15 into the X-th byte of
 STA safehouse,X        \ safehouse

 DEX                    \ Decrement the loop counter

 BPL dumdeedum          \ Loop back to copy the next byte until we have copied
                        \ all six seed bytes

ENDIF

IF _DISC_VERSION OR _6502SP_VERSION \ Other

 LDX #0                 \ Set the distance to the selected system in QQ8(1 0)
 STX QQ8                \ to 0
 STX QQ8+1

ENDIF

 LDA #116               \ Print recursive token 116 (GALACTIC HYPERSPACE ")
 JSR MESS               \ as an in-flight message

                        \ Fall through into jmp to set the system to the
                        \ current system and return from the subroutine there

