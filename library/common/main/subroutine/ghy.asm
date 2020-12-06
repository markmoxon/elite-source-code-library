\ ******************************************************************************
\
\       Name: Ghy
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform a galactic hyperspace jump
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

\JSR TT111              \ This instruction is commented out in the original
                        \ source, and appears in the text cassette code source
                        \ (ELITED.TXT) but not in the BASIC source file on the
                        \ source disc (ELITED). It finds the closest system to
                        \ coordinates (QQ9, QQ10)

IF _CASSETTE_VERSION

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ hy5                \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as hy5 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

 STX QQ8                \ Set the distance to the selected system in (QQ8+1 QQ8)
 STX QQ8+1              \ to 0

ELIF _6502SP_VERSION

 LDX GHYP               \ Fetch GHYP, which tells us whether we own a galactic
 BEQ zZ+1               \ hyperdrive, and if it is zero, which means we don't,
                        \ return from the subroutine (as hy5 contains an RTS)

 INX                    \ We own a galactic hyperdrive, so X is &FF, so this
                        \ instruction sets X = 0

ENDIF

 STX GHYP               \ The galactic hyperdrive is a one-use item, so set GHYP
                        \ to 0 so we no longer have one fitted

 STX FIST               \ Changing galaxy also clears our criminal record, so
                        \ set our legal status in FIST to 0 ("clean")

IF _CASSETTE_VERSION

 JSR wW                 \ Call wW to start the hyperspace countdown

ELIF _6502SP_VERSION

 LDA #2
 JSR wW2

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

IF _6502SP_VERSION

 JSR TT111
 LDX #5

.dumdeedum

 LDA QQ15,X
 STA safehouse,X
 DEX
 BPL dumdeedum
 LDX #0
 STX QQ8
 STX QQ8+1

ENDIF

 LDA #116               \ Print recursive token 116 (GALACTIC HYPERSPACE ")
 JSR MESS               \ as an in-flight message

                        \ Fall through into jmp to set the system to the
                        \ current system and return from the subroutine there

