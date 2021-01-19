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

 JSR EXNO3              \ Make the sound of us dying

 JSR RES2               \ Reset a number of flight variables and workspaces

 ASL DELTA              \ Divide our speed in DELTA by 4
 ASL DELTA

 LDX #24                \ Set the screen to only show 24 text rows, which hides
 JSR DET1               \ the dashboard, setting A to 6 in the process

 JSR TT66               \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 6 (death
                        \ screen)

 JSR BOX                \ Call BOX to redraw the same white border (BOX is part
                        \ of TT66), which removes the border as it is drawn
                        \ using EOR logic

 JSR nWq                \ Create a cloud of stardust containing the correct
                        \ number of dust particles (i.e. NOSTM of them)

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA YC
 STA XC

ELIF _6502SP_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 JSR DOYC
 JSR DOXC

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ change the current colour to yellow

ENDIF

 LDA #146               \ Print recursive token 146 ("{all caps}GAME OVER")
 JSR ex

.D1

 JSR Ze                 \ Call Ze to initialise INWK to a potentially hostile
                        \ ship, and set A and X to random values

 LSR A                  \ Set A = A / 4, so A is now between 0 and 63, and
 LSR A                  \ store in byte #0 (x_lo)
 STA INWK

 LDY #0                 \ Set the following to 0: the current view in QQ11
 STY QQ11               \ (space view), x_hi, y_hi, z_hi and the AI flag (no AI
 STY INWK+1             \ or E.C.M. and not hostile)
 STY INWK+4
 STY INWK+7
 STY INWK+32

 DEY                    \ Set Y = 255

 STY MCNT               \ Reset the main loop counter to 255, so all timer-based
                        \ calls will be stopped

IF _CASSETTE_VERSION OR _DISC_VERSION

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

 TXA                    \ Set A to the random number in X and keep bits 0-3 and
 AND #%10001111         \ the bit 7 to get a number between -15 and +15, and
 STA INWK+29            \ store in byte #29 (roll counter) to give our ship a
                        \ gentle roll with damping

IF _6502SP_VERSION

 STY LASCT              \ Set the laser count to 127 to act as a counter in the
 LSR LASCT              \ D2 loop below, so this setting determines how long the
                        \ death animation lasts (it's 127 iterations of the main
                        \ flight loop)

ENDIF

 ROR A                  \ The C flag is randomly set from the above call to Ze,
 AND #%10000111         \ so this sets A to a number between -7 and +7, which
 STA INWK+30            \ we store in byte #30 (the pitch counter) to give our
                        \ ship a very gentle pitch with damping

IF _CASSETTE_VERSION

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

ELIF _6502SP_VERSION OR _DISC_VERSION

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

ENDIF

 JSR U%                 \ Clear the key logger, which also sets A = 0

 STA DELTA              \ Set our speed in DELTA to 3, so all the cargo
                        \ canisters we just added drift away from us

.D2

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA LASCT              \ Loop back to D2 to run the main flight loop until
 BNE D2                 \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard

                        \ Fall through into DEATH2 to reset and restart the game

ELIF _6502SP_VERSION

 DEC LASCT              \ Decrement the counter in LASCT, which we set above

 BNE D2                 \ Loop back to call the main flight loop again, until we
                        \ have called it 127 times

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard, and fall through into DEATH2 to reset
                        \ and restart the game

ENDIF

IF _6502SP_VERSION OR _DISC_VERSION

 JMP DEATH2             \ Jump to DEATH2 to reset and restart the game

ENDIF

