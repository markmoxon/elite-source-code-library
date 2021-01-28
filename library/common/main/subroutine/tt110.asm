\ ******************************************************************************
\
\       Name: TT110
\       Type: Subroutine
\   Category: Flight
\    Summary: Launch from a station or show the front space view
\
\ ------------------------------------------------------------------------------
\
\ Launch the ship (if we are docked), or show the front space view (if we are
\ already in space).
\
\ Called when red key f0 is pressed while docked (launch), after we arrive in a
\ new galaxy, or after a hyperspace if the current view is a space view.
\
\ ******************************************************************************

.TT110

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 LDX QQ12               \ If we are not docked (QQ12 = 0) then jump to NLUNCH
 BEQ NLUNCH

 JSR LAUN               \ Show the space station launch tunnel

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 INC INWK+8             \ Increment z_sign ready for the call to SOS, so the
                        \ planet appears at a z_sign of 1 in front of us when
                        \ we launch

 JSR SOS1               \ Call SOS1 to set up the planet's data block and add it
                        \ to FRIN, where it will get put in the first slot as
                        \ it's the first one to be added to our local bubble of
                        \ universe following the call to RES2 above

 LDA #128               \ For the space station, set z_sign to &80, so it's
 STA INWK+8             \ behind us (&80 is negative)

 INC INWK+7             \ And increment z_hi, so it's only just behind us

 JSR NWSPS              \ Add a new space station to our local bubble of
                        \ universe

 LDA #12                \ Set our launch speed in DELTA to 12
 STA DELTA

 JSR BAD                \ Call BAD to work out how much illegal contraband we
                        \ are carrying in our hold (A is up to 40 for a
                        \ standard hold crammed with contraband, up to 70 for
                        \ an extended cargo hold full of narcotics and slaves)

 ORA FIST               \ OR the value in A with our legal status in FIST to
                        \ get a new value that is at least as high as both
                        \ values, to reflect the fact that launching with a
                        \ hold full of contraband can only make matters worse

 STA FIST               \ Update our legal status with the new value

ELIF _DISC_DOCKED

 LDX #&3F               \ ????

.L2E94

 LDA QQ16,X
 STA QQ16_FLIGHT,X
 DEX
 BPL &2E94

 JSR &0D7A

 LDX #LO(RDLI)
 LDY #HI(RDLI)
 JMP OSCLI

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT

 LDA #255               \ Set the view number in QQ11 to 255
 STA QQ11

 JSR HFS1               \ Call HFS1 to draw 8 concentric rings

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

.NLUNCH

 LDX #0                 \ Set QQ12 to 0 to indicate we are not docked
 STX QQ12

 JMP LOOK1              \ Jump to LOOK1 to switch to the front view (X = 0),
                        \ returning from the subroutine using a tail call

ENDIF

