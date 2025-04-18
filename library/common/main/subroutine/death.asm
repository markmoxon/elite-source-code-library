\ ******************************************************************************
\
\       Name: DEATH
\       Type: Subroutine
\   Category: Start and end
\    Summary: Display the death screen
IF _NES_VERSION
\  Deep dive: Splitting the main loop in the NES version
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ We have been killed, so display the chaos of our destruction above a "GAME
\ OVER" sign, and clean up the mess ready for the next attempt.
\
\ ******************************************************************************

.DEATH

IF _NES_VERSION

 JSR ResetMusicAfterNMI \ Wait for the next NMI before resetting the current
                        \ tune to 0 (no tune) and stopping the music

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

 JSR EXNO3              \ Make the sound of us dying

ELIF _MASTER_VERSION

 LDY #soexpl            \ Call the NOISE routine with Y = 4 to make the sound of
 JSR NOISE              \ us dying

ELIF _APPLE_VERSION

 LDY #210               \ Call the SOEXPL routine with Y = 210 to make the sound
 JSR SOEXPL             \ of us dying

ENDIF

 JSR RES2               \ Reset a number of flight variables and workspaces

 ASL DELTA              \ Divide our speed in DELTA by 4
 ASL DELTA

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Electron: Group B: The Electron version doesn't hide the dashboard when you die. This effect is implemented in the BBC versions by programming the 6845 CRTC, which isn't present on the Electron

 LDX #24                \ Set the screen to only show 24 text rows, which hides
 JSR DET1               \ the dashboard, setting A to 6 in the process

ELIF _APPLE_VERSION

\LDX #24                \ These instructions are commented out in the original
\JSR DET1               \ source (they would hide the dashboard)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform: The Master version has a unique view type for the title screen (13)

 JSR TT66               \ Clear the top part of the screen, draw a border box,
                        \ and set the current view type in QQ11 to 6 (death
                        \ screen)

ELIF _MASTER_VERSION

 LDA #13                \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 13 (which
                        \ is not a space view, though I'm not quite sure why
                        \ this value is chosen, as it gets overwritten by the
                        \ next instruction anyway)

 STZ QQ11               \ Set QQ11 to 0, so from here on we are using a space
                        \ view

ELIF _APPLE_VERSION

 LDA #0                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 0, so from
                        \ here on we are using a space view

ENDIF

IF _ELECTRON_VERSION \ Platform

 LDX #50                \ Set the laser count to 50 to act as a counter in the
 STX LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (LASCT decreases by 4 for each
                        \ iteration round the main loop, and we also decrement
                        \ it by 1 below to give a total of 5, so this makes the
                        \ animation last for 10 iterations of the main loop)

ENDIF

IF NOT(_NES_VERSION OR _APPLE_VERSION)

 JSR BOX                \ Call BOX to redraw the same border box (BOX is part
                        \ of TT66), which removes the border as it is drawn
                        \ using EOR logic

ELIF _NES_VERSION

 LDA #0                 \ Set the tile number for the left edge of the box to
 STA boxEdge1           \ the blank tile, so the box around the space view
                        \ disappears

 STA boxEdge2           \ Set the tile number for the right edge of the box to
                        \ the blank tile, so the box around the space view
                        \ disappears

 STA autoPlayDemo       \ Disable auto-play by setting autoPlayDemo to zero, in
                        \ case we die during the auto-play combat demo

 LDA #&C4               \ Clear the screen and set the view type in QQ11 to &95
 JSR TT66               \ (Game Over screen)

 JSR ClearDashEdge_b6   \ Clear the right edge of the dashboard

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

 LDA #0                 \ Set showIconBarPointer to 0 to indicate that we should
 STA showIconBarPointer \ hide the icon bar pointer

 LDA #&C4               \ Configure the PPU for view type &C4 (Game Over screen)
 JSR SendViewToPPU_b3

 LDA #&00               \ Set the view type in QQ11 to &00 (Space view with no
 STA QQ11               \ font loaded)

 STA QQ11a              \ Set the old view type in QQ11a to &00 (Space view with
                        \ no fonts loaded)

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries from the
 STA firstPattern       \ first free pattern onwards, so we don't waste time
                        \ resending the static patterns we have already sent

 LDA #116               \ Tell the NMI handler to only clear nametable entries
 STA maxNameTileToClear \ up to tile 116 * 8 = 800 (i.e. up to the end of tile
                        \ row 28)

 LDX #8                 \ Tell the NMI handler to send nametable entries from
 STX firstNameTile      \ tile 8 * 8 = 64 onwards (i.e. from the start of tile
                        \ row 2)

 LDA #104               \ Set the screen height variables for a screen height of
 JSR SetScreenHeight    \ 208 (i.e. 2 * 104)

                        \ Next we fill the scannerNumber table with non-zero
                        \ entries so when we spawn ships for the death screen,
                        \ they don't appear on the scanner because the scanner
                        \ number table doesn't have any free slots

 LDY #8                 \ Set an index in Y to work through the eight entries
                        \ in the scannerNumber table

 LDA #1                 \ Set A = 1 to use as the value for every ship in the
                        \ scannerNumber table, which is non-zero so the NWSHP
                        \ routine will skip the scanner configuration for any
                        \ ships we spawn

.deaf1

 STA scannerNumber,Y    \ Set the Y-th scannerNumber entry to 1

 DEY                    \ Decrement the index in Y

 BNE deaf1              \ Loop back until we have set entries 1 to 8 in the
                        \ table to 1, so nothing spawns on the scanner

ENDIF

IF _C64_VERSION

 LDA #0                 \ The BOX routine sets these addresses in the screen
 STA SCBASE+&1F1F       \ bitmap to &FF and 1 respectively, but it doesn't use
 STA SCBASE+&118        \ EOR logic to do this, so we need to manually set them
                        \ to 0 to remove the corresponding pixels from the
                        \ screen, as the call we just made to BOX won't do this

ENDIF

 JSR nWq                \ Create a cloud of stardust containing the correct
                        \ number of dust particles (i.e. NOSTM of them)

IF _NES_VERSION

                        \ We now give our ship a random amount of roll by
                        \ setting all the various alpha angle variables

 JSR DORND              \ Set A and X to random numbers

 AND #%10000111         \ Set the roll angle in ALPHA to the random number,
 STA ALPHA              \ reduced to the range 0 to 7, and with a random sign

 AND #7                 \ Set the magnitude of roll angle alpha in ALP1 to the
 STA ALP1               \ same value, but with the sign bit cleared (so ALP1
                        \ contains the magnitude of the roll)

 LDA ALPHA              \ Set the sign of the roll angle alpha in ALP2 to the
 AND #%10000000         \ sign of ALPHA (so ALP2 contains the sign of the roll)
 STA ALP2

 EOR #%10000000         \ Set the sign of the roll angle alpha in ALP2+1 to the
 STA ALP2+1             \ flipped sign of ALPHA (so ALP2 contains the flipped
                        \ sign of the roll)

ENDIF

IF _MASTER_VERSION \ Advanced: Group A: In the Master version, the "GAME OVER" message is cyan, while in the 6502SP version it is yellow

 LDA #CYAN              \ Change the current colour to cyan
 STA COL

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Tube

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA YC
 STA XC

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA XC
 STA YC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 JSR DOYC
 JSR DOXC

ENDIF

IF _6502SP_VERSION \ Advanced: See group A

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ change the current colour to yellow

ELIF _C64_VERSION

\LDA #YELLOW            \ These instructions are commented out in the original
\JSR DOCOL              \ source

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

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

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Electron: In the Electron version, the cargo canisters we see when we die always spawn at an x-coordinate of magnitude 32, so canisters appear on either side of the view but never in the centre. It's much more random in the other versions

 LSR A                  \ Set A = A / 4, so A is now between 0 and 63, and
 LSR A                  \ store in byte #0 (x_lo)
 STA INWK

ELIF _ELECTRON_VERSION

 LDA #32                \ Set x_lo = 32
 STA INWK

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 LDY #0                 \ Set the following to 0: the current view in QQ11
 STY QQ11               \ (space view), x_hi, y_hi, z_hi and the AI flag (no AI
 STY INWK+1             \ or E.C.M. and not hostile)
 STY INWK+4
 STY INWK+7
 STY INWK+32

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDY #0                 \ Set the following to 0: x_hi, y_hi, z_hi and the AI
 STY INWK+1             \ flag (no AI or E.C.M. and not hostile)
 STY INWK+4
 STY INWK+7
 STY INWK+32

ELIF _NES_VERSION

 LDY #&00               \ Set the view type in QQ11 to &00 (Space view with no
 STY QQ11               \ font loaded)

 STY INWK+1             \ Set the following to 0: x_hi, y_hi, z_hi and the AI
 STY INWK+4             \ flag (no AI or E.C.M. and not hostile)
 STY INWK+7
 STY INWK+32

ENDIF

 DEY                    \ Set Y = 255

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform

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
 AND #%10001111         \ the sign in bit 7 to get a number between -15 and +15,
 STA INWK+29            \ and store in byte #29 (roll counter) to give our ship
                        \ a gentle roll with damping

IF _6502SP_VERSION \ Platform

 STY LASCT              \ Set the laser count to 127 to act as a counter in the
 LSR LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 127 iterations of the main
                        \ flight loop)

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

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

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 SEC                    \ Set the C flag

 ROR A                  \ This sets A to a number between 0 and +7, which we
 AND #%10000111         \ store in byte #30 (the pitch counter) to give our ship
 STA INWK+30            \ a very gentle downwards pitch with damping

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: On death, the cassette and Electron versions show your ship explosion along with up to four cargo canisters; in the enhanced versions, it shows up to five items, which can be a mix of cargo canisters and alloy plates

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

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

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
                        \ we have added seven of them

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

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Platform

 JSR U%                 \ Clear the key logger, which also sets A = 0

 STA DELTA              \ Set our speed in DELTA to 0, as we aren't going
                        \ anywhere any more

ELIF _MASTER_VERSION OR _APPLE_VERSION

\JSR U%                 \ This instruction is commented out in the original
                        \ source

 LDA #0                 \ Set our speed in DELTA to 0, as we aren't going
 STA DELTA              \ anywhere any more

ELIF _NES_VERSION

 LDA #8                 \ Set our speed in DELTA to 8, so the camera moves
 STA DELTA              \ forward slowly

 LDA #12                \ Set the text row for in-flight messages in the space
 STA messYC             \ view to row 12

 LDA #146               \ Print recursive token 146 ("{all caps}GAME OVER") in
 LDY #120               \ the middle of the screen and leave it there for 120
 JSR PrintMessage       \ ticks of the DLY counter

 JSR HideMostSprites    \ Hide all sprites except for sprite 0 and the icon bar
                        \ pointer

 LDA #30                \ Set the laser count to 30 to act as a counter in the
 STA LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts

ENDIF

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about, as well as decrementing the
                        \ value in LASCT

\JSR NOSPRITES          \ This instruction is commented out in the original
                        \ source

ELIF _C64_VERSION

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about, as well as decrementing the
                        \ value in LASCT

 JSR NOSPRITES          \ Call NOSPRITES to disable all sprites and remove them
                        \ from the screen

ENDIF

.D2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Comment

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about, as well as decrementing the
                        \ value in LASCT

ELIF _NES_VERSION

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 JSR FlightLoop4To16    \ Display in-flight messages, call parts 4 to 12 of the
                        \ main flight loop for each ship slot, and finish off
                        \ with parts 13 to 16 of the main flight loop

 JSR ClearDashEdge_b6   \ Clear the right edge of the dashboard

 LDA #%11001100         \ Set the bitplane flags for the drawing bitplane to the
 JSR SetDrawPlaneFlags  \ following:
                        \
                        \   * Bit 2 set   = send tiles up to end of the buffer
                        \   * Bit 3 set   = clear buffers after sending data
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 set   = send both pattern and nametable data
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ This configures the NMI to send nametable and pattern
                        \ data for the drawing bitplane to the PPU during VBlank

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Platform

 LDA LASCT              \ Loop back to D2 to run the main flight loop until
 BNE D2                 \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

ELIF _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

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

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Electron: See group B

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard

ELIF _APPLE_VERSION

\LDX #31                \ These instructions are commented out in the original
\JSR DET1               \ source (they would show the dashboard)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

                        \ Fall through into DEATH2 to reset and restart the game

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 JMP DEATH2             \ Jump to DEATH2 to reset and restart the game

ENDIF

