\ ******************************************************************************
\
\       Name: TT18
\       Type: Subroutine
\   Category: Flight
\    Summary: Try to initiate a jump into hyperspace
\
\ ------------------------------------------------------------------------------
\
\ Try to go through hyperspace. Called from TT102 in the main loop when the
\ hyperspace countdown has finished.
\
IF _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   hyper_snap          Perform a hyperspace, but without using up any fuel
\
ENDIF
\ ******************************************************************************

.TT18

IF _NES_VERSION

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the music

ENDIF

IF _6502SP_VERSION \ 6502SP: Group A: If infinite jump range is enabled in the Executive version, no fuel is used for jumping

IF _SNG45 OR _SOURCE_DISC

 LDA QQ14               \ Subtract the distance to the selected system (in QQ8)
 SEC                    \ from the amount of fuel in our tank (in QQ14) into A
 SBC QQ8

ELIF _EXECUTIVE

 LDA QQ14               \ Subtract the distance to the selected system (in QQ8)

 BIT JUMP               \ If infinite jump range is configured, then jump down
 BMI IJUMP              \ to IJUMP so we don't subtract any fuel for this jump

 SEC                    \ from the amount of fuel in our tank (in QQ14) into A
 SBC QQ8

ENDIF

ELIF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 LDA QQ14               \ Subtract the distance to the selected system (in QQ8)
 SEC                    \ from the amount of fuel in our tank (in QQ14) into A
 SBC QQ8

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Other: This might be a bug fix? The 6502SP version makes sure we don't end up with a negative fuel amount should we try a hyperspace jump that we don't have enough fuel for, though quite how we would get to this point is not clear

 BCS P%+4               \ If the subtraction didn't overflow, skip the next
                        \ instruction

 LDA #0                 \ The subtraction overflowed, so set A = 0 so we don't
                        \ end up with a negative amount of fuel

ENDIF

 STA QQ14               \ Store the updated fuel amount in QQ14

IF _ELITE_A_VERSION

.hyper_snap

ENDIF

IF _6502SP_VERSION \ 6502SP: See group A

IF _EXECUTIVE

.IJUMP

ENDIF

ENDIF

IF NOT(_NES_VERSION)

 LDA QQ11               \ If the current view is not a space view, jump to ee5
 BNE ee5                \ to skip the following

 JSR TT66               \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 0 (space
                        \ view)

 JSR LL164              \ Call LL164 to show the hyperspace tunnel and make the
                        \ hyperspace sound

ELIF _NES_VERSION

 LDA QQ11               \ If this is not the space view, then jump to hypr1 to
 BNE hypr1              \ skip drawing the hyperspace tunnel, but still make the
                        \ hyperspace sound

 JSR ClearScanner       \ Remove all ships from the scanner and hide the scanner
                        \ sprites

 JSR LL164_b6           \ Call LL164 to show the hyperspace tunnel and make the
                        \ hyperspace sound

 JMP hypr2              \ Jump to hypr2 to skip the following, as we already
                        \ the hyperspace sound in LL164

.hypr1

 JSR MakeHyperSound     \ Make the hyperspace sound for when we are not in the
                        \ space view

.hypr2

 LDA controller1Up      \ If either of the up or down buttons are being pressed,
 ORA controller1Down    \ then jump to MJP to force a mis-jump
 BMI MJP

ENDIF

.ee5

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ELIF _MASTER_VERSION

IF _SNG47

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ELIF _COMPACT

 JSR CTRLmc             \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

ENDIF

ELIF _APPLE_VERSION

 JSR RDKEY              \ Scan the keyboard for a key press and return the ASCII
                        \ code of the key pressed in A and X (or 0 for no key
                        \ press)

 CMP #9                 \ If TAB is not being pressed, jump to nopatg to skip
 BNE nopatg             \ the following

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: The Electron version doesn't support witchspace, so the code for triggering a manual mis-jump is missing

 AND PATG               \ If the game is configured to show the author's names
                        \ on the start-up screen, then PATG will contain &FF,
                        \ otherwise it will be 0

 BMI ptg                \ By now, A will be negative if we are holding down CTRL
                        \ and author names are configured, which is what we have
                        \ to do in order to trigger a manual mis-jump, so jump
                        \ to ptg to do a mis-jump (ptg not only mis-jumps, but
                        \ updates the competition flags, so Acornsoft could tell
                        \ from the competition code whether this feature had
                        \ been used)

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

\JSR TT111              \ This instruction is commented out in the original
                        \ source. It finds the closest system to coordinates
                        \ (QQ9, QQ10), but we don't need to do this as the
                        \ crosshairs will already be on a system by this point

 JSR hyp1+3             \ Jump straight to the system at (QQ9, QQ10) without
                        \ first calculating which system is closest

ELIF _DISC_FLIGHT

 AND PATG               \ If the game is configured to show the author's names
                        \ on the start-up screen, then PATG will contain &FF,
                        \ otherwise it will be 0

 BMI ptg                \ By now, A will be negative if we are holding down CTRL
                        \ and author names are configured, which is what we have
                        \ to do in order to trigger a manual mis-jump, so jump
                        \ to ptg to do a mis-jump (ptg not only mis-jumps, but
                        \ updates the competition flags, so Acornsoft could tell
                        \ from the competition code whether this feature had
                        \ been used)

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

 JSR hyp1+3             \ Jump straight to the system at (QQ9, QQ10) without
                        \ first calculating which system is closest

ELIF _ELECTRON_VERSION

 JSR hyp1               \ Jump straight to the system at (QQ9, QQ10)

ELIF _ELITE_A_FLIGHT OR _NES_VERSION

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

 JSR hyp1               \ Jump straight to the system at (QQ9, QQ10)

ELIF _ELITE_A_6502SP_PARA

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

 JSR hyp1_FLIGHT        \ Jump straight to the system at (QQ9, QQ10)

ELIF _C64_VERSION

 AND PATG               \ If the game is configured to show the author's names
                        \ on the start-up screen, then PATG will contain &FF,
                        \ otherwise it will be 0

 BMI ptg                \ By now, A will be negative if we are holding down CTRL
                        \ and author names are configured, which is what we have
                        \ to do in order to trigger a manual mis-jump, so jump
                        \ to ptg to do a mis-jump (ptg not only mis-jumps, but
                        \ updates the competition flags, so Firebird could tell
                        \ from the competition code whether this feature had
                        \ been used)

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

\JSR TT111              \ This instruction is commented out in the original
                        \ source. It finds the closest system to coordinates
                        \ (QQ9, QQ10), but we don't need to do this as the
                        \ crosshairs will already be on a system by this point

 JSR hyp1+3             \ Jump straight to the system at (QQ9, QQ10) without
                        \ first calculating which system is closest

ELIF _APPLE_VERSION

 LDA PATG               \ If the game is configured to show the author's names
                        \ on the start-up screen, then PATG will contain &FF,
                        \ otherwise it will be 0

 BMI ptg                \ We only get here if we are holding down TAB, so this
                        \ checks to see whether author names are configured, and
                        \ if they are, then we have what we need to trigger a
                        \ manual mis-jump, so jump to ptg to do a mis-jump (ptg
                        \ not only mis-jumps, but updates the competition flags,
                        \ so Firebird could tell from the competition code
                        \ whether this feature had been used)

.nopatg

 JSR DORND              \ Set A and X to random numbers

 CMP #253               \ If A >= 253 (0.78% chance) then jump to MJP to trigger
 BCS MJP                \ a mis-jump into witchspace

\JSR TT111              \ This instruction is commented out in the original
                        \ source. It finds the closest system to coordinates
                        \ (QQ9, QQ10), but we don't need to do this as the
                        \ crosshairs will already be on a system by this point

 JSR hyp1+3             \ Jump straight to the system at (QQ9, QQ10) without
                        \ first calculating which system is closest

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform: In the cassette and Electron versions, hyp1 doesn't fall through into GVL, so we need to call it

 JSR GVL                \ Calculate the availability for each market item in the
                        \ new system

ENDIF

IF _NES_VERSION

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment

 JSR SOLAR              \ Halve our legal status, update the missile indicators,
                        \ and set up data blocks and slots for the planet and
                        \ sun

ELIF _ELECTRON_VERSION

 JSR SOLAR              \ Halve our legal status, update the missile indicators,
                        \ and set up the data block and slot for the planet

ENDIF

IF _MASTER_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment

\JSR CATLOD             \ These instructions are commented out in the original
\                       \ source
\JSR LOMOD

ENDIF

IF _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 JSR LOMOD              \ Call LOMOD to load a new ship blueprints file

ELIF _ELITE_A_6502SP_PARA

 JSR LOMOD              \ Call LOMOD to populate the ship blueprints table
                        \ with a random selection of ships

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA QQ11               \ If the current view in QQ11 is not a space view (0) or
 AND #%00111111         \ one of the charts (64 or 128), return from the
 BNE hyR                \ subroutine (as hyR contains an RTS)

ELIF _DISC_FLIGHT

 LDA QQ11               \ If the current view in QQ11 is not a space view (0) or
 AND #%00111111         \ one of the charts (64 or 128), return from the
 BNE TT113              \ subroutine (as TT113 contains an RTS)

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA QQ11               \ If the current view in QQ11 is not a space view (0) or
 AND #%00111111         \ one of the charts (64 or 128), return from the
 BNE RTS111             \ subroutine (as RTS111 contains an RTS)

ENDIF

IF NOT(_NES_VERSION)

 JSR TTX66              \ Otherwise clear the screen and draw a border box

 LDA QQ11               \ If the current view is one of the charts, jump to
 BNE TT114              \ TT114 (from which we jump to the correct routine to
                        \ display the chart)

 INC QQ11               \ This is a space view, so increment QQ11 to 1

                        \ Fall through into TT110 to show the front space view

ENDIF

