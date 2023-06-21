\ ******************************************************************************
\
\       Name: DEATH
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display the death screen
\
\ ------------------------------------------------------------------------------
\
\ We have been killed, so display the chaos of our destruction above a "GAME
\ OVER" sign, and clean up the mess ready for the next attempt.
\
\ ******************************************************************************

.DEATH

IF _NES_VERSION

 JSR WaitResetSound     \ ???

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

 JSR EXNO3              \ Make the sound of us dying

ELIF _MASTER_VERSION

 LDY #soexpl            \ Call the NOISE routine with Y = 4 to make the sound of
 JSR NOISE              \ us dying

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

 ASL DELTA              \ Divide our speed in DELTA by 4
 ASL DELTA

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: Group B: The Electron version doesn't hide the dashboard when you die. This effect is implemented in the BBC versions by programming the 6845 CRTC, which isn't present on the Electron

 LDX #24                \ Set the screen to only show 24 text rows, which hides
 JSR DET1               \ the dashboard, setting A to 6 in the process

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform: The Master version has a unique internal view number for the title screen (13)

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 6 (death
                        \ screen)

ELIF _MASTER_VERSION

 LDA #13                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 13 (which
                        \ is not a space view, though I'm not quite sure why
                        \ this value is chosen, as it gets overwritten by the
                        \ next instruction anyway)

 STZ QQ11               \ Set QQ11 to 0, so from here on we are using a space
                        \ view

ENDIF

IF _ELECTRON_VERSION \ Platform

 LDX #50                \ Set the laser count to 50 to act as a counter in the
 STX LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (LASCT decreases by 4 for each
                        \ iteration round the main loop, and we also decrement
                        \ it by 1 below to give a total of 5, so this makes the
                        \ animation last for 10 iterations of the main loop)

ENDIF

IF NOT(_NES_VERSION)

 JSR BOX                \ Call BOX to redraw the same white border (BOX is part
                        \ of TT66), which removes the border as it is drawn
                        \ using EOR logic


ELIF _NES_VERSION

 LDA #0                 \ ???
 STA boxEdge1
 STA boxEdge2
 STA L03EE
 LDA #&C4
 JSR TT66
 JSR subm_BED2_b6
 JSR CopyNameBuffer0To1
 JSR subm_EB86
 LDA #0
 STA L045F
 LDA #&C4
 JSR subm_A7B7_b3
 LDA #0
 STA QQ11
 STA QQ11a
 LDA tileNumber
 STA L00D2
 LDA #&74
 STA L00D8
 LDX #8
 STX L00CC
 LDA #&68
 JSR SetScreenHeight
 LDY #8
 LDA #1

.loop_CB22F

 STA L0374,Y
 DEY
 BNE loop_CB22F

ENDIF

 JSR nWq                \ Create a cloud of stardust containing the correct
                        \ number of dust particles (i.e. NOSTM of them)

IF _NES_VERSION

 JSR DORND              \ ???
 AND #&87
 STA ALPHA
 AND #7
 STA ALP1
 LDA ALPHA
 AND #&80
 STA ALP2
 EOR #&80
 STA ALP2+1

ENDIF

IF _MASTER_VERSION \ Advanced: Group A: In the Master version, the "GAME OVER" message is cyan, while in the 6502SP version it is yellow

 LDA #CYAN              \ Change the current colour to cyan
 STA COL

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Tube

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA YC
 STA XC

ELIF _MASTER_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA XC
 STA YC

ELIF _6502SP_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 JSR DOYC
 JSR DOXC

ENDIF

IF _6502SP_VERSION \ Advanced: See group A

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ change the current colour to yellow

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA #146               \ Print recursive token 146 ("{all caps}GAME OVER")
 JSR ex

ELIF _ELECTRON_VERSION

 LDA #146               \ Print recursive token 146 ("{all caps}GAME OVER")
 STA MCNT               \ and reset the main loop counter to 146, so all
 JSR ex                 \ timer-based calls will be stopped

ENDIF

.D1

 JSR Ze                 \ Call Ze to initialise INWK to a potentially hostile
                        \ ship, and set A and X to random values

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: In the Electron version, the cargo canisters we see when we die always spawn at an x-coordinate of magnitude 32, so canisters appear on either side of the view but never in the centre. It's much more random in the other versions

 LSR A                  \ Set A = A / 4, so A is now between 0 and 63, and
 LSR A                  \ store in byte #0 (x_lo)
 STA INWK

ELIF _ELECTRON_VERSION

 LDA #32                \ Set x_lo = 32
 STA INWK

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Platform

 LDY #0                 \ Set the following to 0: the current view in QQ11
 STY QQ11               \ (space view), x_hi, y_hi, z_hi and the AI flag (no AI
 STY INWK+1             \ or E.C.M. and not hostile)
 STY INWK+4
 STY INWK+7
 STY INWK+32

ELIF _MASTER_VERSION

 LDY #0                 \ Set the following to 0: x_hi, y_hi, z_hi and the AI
 STY INWK+1             \ flag (no AI or E.C.M. and not hostile)
 STY INWK+4
 STY INWK+7
 STY INWK+32

ENDIF

 DEY                    \ Set Y = 255

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

 STY MCNT               \ Reset the main loop counter to 255, so all timer-based
                        \ calls will be stopped

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 STY LASCT              \ Set the laser count to 255 to act as a counter in the
                        \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 5.1 seconds, as LASCT is
                        \ decremented every vertical sync, or 50 times a second,
                        \ and 255 / 50 = 5.1)

ENDIF

 EOR #%00101010         \ Flip bits 1, 3 and 5 in A (x_lo) to get another number
 STA INWK+3             \ between 48 and 63, and store in byte #3 (y_lo)

 ORA #%01010000         \ Set bits 4 and 6 of A to bump it up to between 112 and
 STA INWK+6             \ 127, and store in byte #6 (z_lo)

IF _ELITE_A_6502SP_PARA

 TYA                    \ Tell the I/O processor to set its copy of LASCT to
 JSR write_0346         \ 255, to act as a counter in the D2 loop below, so this
                        \ setting determines how long the death animation lasts
                        \ (it's 5.1 seconds, as LASCT is decremented every
                        \ vertical sync, or 50 times a second, and
                        \ 255 / 50 = 5.1)

ENDIF

 TXA                    \ Set A to the random number in X and keep bits 0-3 and
 AND #%10001111         \ the bit 7 to get a number between -15 and +15, and
 STA INWK+29            \ store in byte #29 (roll counter) to give our ship a
                        \ gentle roll with damping

IF _6502SP_VERSION \ Platform

 STY LASCT              \ Set the laser count to 127 to act as a counter in the
 LSR LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 127 iterations of the main
                        \ flight loop)

ELIF _MASTER_VERSION OR _NES_VERSION

 LDY #64                \ Set the laser count to 64 to act as a counter in the
 STY LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 64 * 2 iterations of the
                        \ main flight loop)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: In the cassette, disc and 6502SP versions, our ship is given a gentle pitch up or down when we die; the same is true in the Master version, but the pitch is always downwards so the detritus of our death always rises to the top of the screen

 ROR A                  \ The C flag is randomly set from the above call to Ze,
 AND #%10000111         \ so this sets A to a number between -7 and +7, which
 STA INWK+30            \ we store in byte #30 (the pitch counter) to give our
                        \ ship a very gentle pitch with damping

ELIF _MASTER_VERSION OR _NES_VERSION

 SEC                    \ Set the C flag

 ROR A                  \ This sets A to a number between 0 and +7, which we
 AND #%10000111         \ store in byte #30 (the pitch counter) to give our ship
 STA INWK+30            \ a very gentle downwards pitch with damping

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: On death, the cassette version shows your ship explosion along with up to four cargo canisters; in the enhanced versions, it shows up to five items, which can be a mix of cargo canisters and alloy plates

 PHP                    \ Store the processor flags

 LDX #OIL               \ Call fq1 with X set to #OIL, which adds a new cargo
 JSR fq1                \ canister to our local bubble of universe and points it
                        \ away from us with double DELTA speed (i.e. 6, as DELTA
                        \ was set to 3 by the call to RES2 above). INF is set to
                        \ point to the canister's ship data block in K%

 PLP                    \ Restore the processor flags, including our random C
                        \ flag from before

 LDA #0                 \ Set bit 7 of A to our random C flag and store in byte
 ROR A                  \ #31 of the ship's data block, so this has a 50% chance
 LDY #31                \ of marking our new canister as being killed (so it
 STA (INF),Y            \ will explode)

 LDA FRIN+3             \ The call we made to RES2 before we entered the loop at
 BEQ D1                 \ D1 will have reset all the ship slots at FRIN, so this
                        \ checks to see if the fourth slot is empty, and if it
                        \ is we loop back to D1 to add another canister, until
                        \ we have added four of them

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION

 LDX #OIL               \ Set X to #OIL, the ship type for a cargo canister

 LDA XX21-1+2*PLT       \ Fetch the byte from location XX21 - 1 + 2 * PLT, which
                        \ equates to XX21 + 7 (the high byte of the address of
                        \ SHIP_PLATE), which seems a bit odd. It might make more
                        \ sense to do LDA (XX21-2+2*PLT) as this would fetch the
                        \ first byte of the alloy plate's blueprint (which
                        \ determines what happens when alloys are destroyed),
                        \ but there aren't any brackets, so instead this always
                        \ returns &D0, which is never zero, so the following
                        \ BEQ is never true. (If the brackets were there, then
                        \ we could stop plates from spawning on death by setting
                        \ byte #0 of the blueprint to 0... but then scooping
                        \ plates wouldn't give us alloys, so who knows what this
                        \ is all about?)

 BEQ D3                 \ If A = 0, jump to D3 to skip the following instruction

 BCC D3                 \ If the C flag is clear, which will be random following
                        \ the above call to Ze, jump to D3 to skip the following
                        \ instruction

 DEX                    \ Decrement X, which sets it to #PLT, the ship type for
                        \ an alloy plate

.D3

 JSR fq1                \ Call fq1 with X set to #OIL or #PLT, which adds a new
                        \ cargo canister or alloy plate to our local bubble of
                        \ universe and points it away from us with double DELTA
                        \ speed (i.e. 6, as DELTA was set to 3 by the call to
                        \ RES2 above). INF is set to point to the new arrival's
                        \ ship data block in K%

 JSR DORND              \ Set A and X to random numbers and extract bit 7 from A
 AND #%10000000

 LDY #31                \ Store this in byte #31 of the ship's data block, so it
 STA (INF),Y            \ has a 50% chance of marking our new arrival as being
                        \ killed (so it will explode)

 LDA FRIN+4             \ The call we made to RES2 before we entered the loop at
 BEQ D1                 \ D1 will have reset all the ship slots at FRIN, so this
                        \ checks to see if the fifth slot is empty, and if it
                        \ is we loop back to D1 to add another canister, until
                        \ we have added five of them

ELIF _NES_VERSION

 LDX #OIL               \ Set X to #OIL, the ship type for a cargo canister

 LDA XX21-1+2*PLT       \ Fetch the byte from location XX21 - 1 + 2 * PLT, which
                        \ equates to XX21 + 7 (the high byte of the address of
                        \ SHIP_PLATE), which seems a bit odd. It might make more
                        \ sense to do LDA (XX21-2+2*PLT) as this would fetch the
                        \ first byte of the alloy plate's blueprint (which
                        \ determines what happens when alloys are destroyed),
                        \ but there aren't any brackets, so instead this always
                        \ returns &D0, which is never zero, so the following
                        \ BEQ is never true. (If the brackets were there, then
                        \ we could stop plates from spawning on death by setting
                        \ byte #0 of the blueprint to 0... but then scooping
                        \ plates wouldn't give us alloys, so who knows what this
                        \ is all about?)

 BEQ D3                 \ If A = 0, jump to D3 to skip the following instruction

 BCC D3                 \ If the C flag is clear, which will be random following
                        \ the above call to Ze, jump to D3 to skip the following
                        \ instruction

 DEX                    \ Decrement X, which sets it to #PLT, the ship type for
                        \ an alloy plate

.D3

 JSR fq1                \ Call fq1 with X set to #OIL or #PLT, which adds a new
                        \ cargo canister or alloy plate to our local bubble of
                        \ universe and points it away from us with double DELTA
                        \ speed (i.e. 6, as DELTA was set to 3 by the call to
                        \ RES2 above). INF is set to point to the new arrival's
                        \ ship data block in K%

 JSR DORND              \ Set A and X to random numbers and extract bit 7 from A
 AND #%10000000

 LDY #31                \ Store this in byte #31 of the ship's data block, so it
 STA (INF),Y            \ has a 50% chance of marking our new arrival as being
                        \ killed (so it will explode)

 LDA FRIN+6             \ The call we made to RES2 before we entered the loop at
 BEQ D1                 \ D1 will have reset all the ship slots at FRIN, so this
                        \ checks to see if the seventh slot is empty, and if it
                        \ is we loop back to D1 to add another canister, until
                        \ we have added seven of them ???

ELIF _ELITE_A_6502SP_PARA

 LDX #OIL               \ Set X to #OIL, the ship type for a cargo canister

 BCC D3                 \ If the C flag is clear, which will be random following
                        \ the above call to Ze, jump to D3 to skip the following
                        \ instruction

 DEX                    \ Decrement X, which sets it to #PLT, the ship type for
                        \ an alloy plate

.D3

 JSR fq1                \ Call fq1 with X set to #OIL or #PLT, which adds a new
                        \ cargo canister or alloy plate to our local bubble of
                        \ universe and points it away from us with double DELTA
                        \ speed (i.e. 6, as DELTA was set to 3 by the call to
                        \ RES2 above). INF is set to point to the new arrival's
                        \ ship data block in K%

 JSR DORND              \ Set A and X to random numbers and extract bit 7 from A
 AND #%10000000

 LDY #31                \ Store this in byte #31 of the ship's data block, so it
 STA (INF),Y            \ has a 50% chance of marking our new arrival as being
                        \ killed (so it will explode)

 LDA FRIN+4             \ The call we made to RES2 before we entered the loop at
 BEQ D1                 \ D1 will have reset all the ship slots at FRIN, so this
                        \ checks to see if the fifth slot is empty, and if it
                        \ is we loop back to D1 to add another canister, until
                        \ we have added five of them

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 JSR U%                 \ Clear the key logger, which also sets A = 0

 STA DELTA              \ Set our speed in DELTA to 0, as we aren't going
                        \ anywhere any more

ELIF _MASTER_VERSION

\JSR U%                 \ This instruction is commented out in the original
                        \ source

 LDA #0                 \ Set our speed in DELTA to 0, as we aren't going
 STA DELTA              \ anywhere any more

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about, as well as decrementing the
                        \ value in LASCT

\JSR NOSPRITES          \ This instruction is commented out in the original
                        \ source

ELIF _NES_VERSION

 LDA #8                 \ Set our speed in DELTA to 8, so the camera moves
 STA DELTA              \ forward slowly

 LDA #12                \ ???
 STA L00B5

 LDA #146
 LDY #120
 JSR subm_B77A

 JSR HideSprites5To63

 LDA #30
 STA LASCT

ENDIF

.D2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Comment

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about, as well as decrementing the
                        \ value in LASCT

ELIF _NES_VERSION

 JSR ChangeDrawingPhase \ ???
 JSR subm_MA23
 JSR subm_BED2_b6
 LDA #&CC
 JSR subm_D977

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 LDA LASCT              \ Loop back to D2 to run the main flight loop until
 BNE D2                 \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

ELIF _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION

 DEC LASCT              \ Decrement the counter in LASCT, which we set above,
                        \ so for each loop around D2, we decrement LASCT by 5
                        \ (the main loop decrements it by 4, and this one makes
                        \ it 5)

 BNE D2                 \ Loop back to call the main flight loop again, until we
                        \ have called it 127 times

ELIF _ELITE_A_6502SP_PARA

 JSR read_0346          \ Get the value of the I/O processor's copy of LASCT

 BNE D2                 \ Loop back to D2 to run the main flight loop until
                        \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: See group B

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

                        \ Fall through into DEATH2 to reset and restart the game

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JMP DEATH2             \ Jump to DEATH2 to reset and restart the game

ENDIF

