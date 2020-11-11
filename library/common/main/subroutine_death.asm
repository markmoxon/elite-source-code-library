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

IF _CASSETTE_VERSION

 LDA #12                \ Move the text cursor to column 12 on row 12
 STA YC
 STA XC

ELIF _6502SP_VERSION

 LDA #12
 JSR DOYC
 JSR DOXC
 LDA #YELLOW
 JSR DOCOL

ENDIF

 LDA #146               \ Print recursive token 146 ("{switch to all caps}GAME
 JSR ex                 \ OVER"

.D1

 JSR Ze                 \ Initialise INWK workspace, set X and T1 to a random
                        \ value, and A to a random value between 192 and 255 and
                        \ the C flag randomly

 LSR A                  \ Set A = A / 4, so A is now between 48 and 63, and
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

IF _CASSETTE_VERSION

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

 STY LASCT
 LSR LASCT

ENDIF

 ROR A                  \ C is random from above call to Ze, so this sets A to a
 AND #%10000111         \ number between -7 and +7, which we store in byte #30
 STA INWK+30            \ (pitch counter) to give our ship a very gentle pitch
                        \ with damping

IF _CASSETTE_VERSION

 PHP                    \ Store the processor flags

 LDX #OIL               \ Call fq1 with X set to OIL, which adds a new cargo
 JSR fq1                \ canister to our local bubble of universe and points it
                        \ away from us with double DELTA speed (i.e. 6, as DELTA
                        \ was set to 3 by the call to RES2 above). INF is set to
                        \ point to the ship's data block in K%

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

ELIF _6502SP_VERSION

 LDX #OIL
 LDA XX21-1+2*PLT
 BEQ D3
 BCC D3
 DEX

.D3

 JSR fq1
 JSR DORND
 AND #128
 LDY #31
 STA (INF),Y
 LDA FRIN+4
 BEQ D1

ENDIF

 JSR U%                 \ Clear the key logger, which also sets A = 0

 STA DELTA              \ Set our speed in DELTA to 3, so all the cargo
                        \ canisters we just added drift away from us

.D2

 JSR M%                 \ Call the M% routine to do the main flight loop once,
                        \ which will display our exploding canister scene and
                        \ move everything about

IF _CASSETTE_VERSION

 LDA LASCT              \ Loop back to D2 to run the main flight loop until
 BNE D2                 \ LASCT reaches zero (which will take 5.1 seconds, as
                        \ explained above)

 LDX #31                \ Set the screen to show all 31 text rows, which shows
 JSR DET1               \ the dashboard, and fall through into DEATH2 to reset
                        \ and restart the game

ELIF _6502SP_VERSION

 DEC LASCT
 BNE D2
 LDX #31
 JSR DET1
 JMP DEATH2

ENDIF


