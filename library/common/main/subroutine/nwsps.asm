\ ******************************************************************************
\
\       Name: NWSPS
\       Type: Subroutine
\   Category: Universe
\    Summary: Add a new space station to our local bubble of universe
\
\ ******************************************************************************

.NWSPS

IF NOT(_NES_VERSION)

 JSR SPBLB              \ Light up the space station bulb on the dashboard

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Space stations in the enhanced versions are always set to be aggressive if attacked, but they start out friendly; in the cassette and Electron versions, they have no aggression at all until they are attacked

 LDX #%00000001         \ Set the AI flag in byte #32 to %00000001 (friendly, no
 STX INWK+32            \ AI, has an E.C.M.)

 DEX                    \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 LDX #%10000001         \ Set the AI flag in byte #32 to %10000001 (hostile,
 STX INWK+32            \ no AI, has an E.C.M.)

 LDX #0                 \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

 STX NEWB               \ Set NEWB to %00000000, though this gets overridden by
                        \ the default flags from E% in NWSHP below

ELIF _ELITE_A_VERSION

 LDX #%10000001         \ Set the AI flag in byte #32 to %10000001 (hostile,
 STX INWK+32            \ no AI, has an E.C.M.)

 LDX #255               \ Set the roll counter to 255 (maximum anti-clockwise
 STX INWK+29            \ roll with no damping)

 INX                    \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

ENDIF

IF _CASSETTE_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _6502SP_VERSION \ Comment

\STX INWK+31            \ This instruction is commented out in the original
                        \ source. It would set the exploding state and missile
                        \ count to 0

ENDIF

 STX FRIN+1             \ Set the second slot in the FRIN table to 0, so when we
                        \ fall through into NWSHP below, the new station that
                        \ gets created will go into slot FRIN+1, as this will be
                        \ the first empty slot that the routine finds

IF NOT(_ELITE_A_VERSION)

 DEX                    \ Set the roll counter to 255 (maximum anti-clockwise
 STX INWK+29            \ roll with no damping)

ELIF _ELITE_A_VERSION

 STX INWK+33            \ As part of the setup, we want to point INWK(34 33) to
                        \ LSO, the line heap for the space station. LSO is at
                        \ &0E00, so this sets the low byte at byte #33 to 0 (we
                        \ set the high byte below)

 LDA FIST               \ If bit 7 of FIST is clear, i.e. FIST < 128, then jump
 BPL n_enemy            \ to n_enemy with X = 0 to skip the following
                        \ instruction and set the NEWB flags to 0 (so the
                        \ station is not hostile)

 LDX #%00000100         \ Bit 7 of FIST is set, i.e. FIST >= 128 (so our
                        \ "fugitive/innocent status" is very bad!), so set bit
                        \ #3 of X so we the following sets the NEWB flags to
                        \ make the station hostile

.n_enemy

 STX NEWB               \ Set the station's NEWB flag with the value in X, so it
                        \ be hostile if FIST > 127, or friendly otherwise

ENDIF

 LDX #10                \ Call NwS1 to flip the sign of nosev_x_hi (byte #10)
 JSR NwS1

 JSR NwS1               \ And again to flip the sign of nosev_y_hi (byte #12)

IF _ELITE_A_VERSION

                        \ NwS1 increments X by 2 for each call, so at this point
                        \ the value of X is 10 + 2 + 2 = 14 = &E, which we can
                        \ use to set the correct INWK+34 value in the following

 STX INWK+34            \ As part of the setup, we want to point INWK(34 33) to
                        \ LSO, the line heap for the space station. LSO is at
                        \ &0E00, so this sets the high byte at byte #34 to &0E
                        \ (we already set the low byte above)

ENDIF

 JSR NwS1               \ And again to flip the sign of nosev_z_hi (byte #14)

IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 LDA spasto             \ Copy the address of the Coriolis space station's ship
 STA XX21+2*SST-2       \ blueprint from spasto to the #SST entry in the
 LDA spasto+1           \ blueprint lookup table at XX21, so when we spawn a
 STA XX21+2*SST-1       \ ship of type #SST, it will be a Coriolis station

 LDA tek                \ If the system's tech level in tek is less than 10,
 CMP #10                \ jump to notadodo, so tech levels 0 to 9 have Coriolis
 BCC notadodo           \ stations, while 10 and above will have Dodo stations

 LDA XX21+2*DOD-2       \ Copy the address of the Dodo space station's ship
 STA XX21+2*SST-2       \ blueprint from spasto to the #SST entry in the
 LDA XX21+2*DOD-1       \ blueprint lookup table at XX21, so when we spawn a
 STA XX21+2*SST-1       \ ship of type #SST, it will be a Dodo station

.notadodo

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 LDA #LO(LSO)           \ Set bytes #33 and #34 to point to LSO for the ship
 STA INWK+33            \ line heap for the space station
 LDA #HI(LSO)
 STA INWK+34

ENDIF

IF NOT(_NES_VERSION)

 LDA #SST               \ Set A to the space station type, and fall through
                        \ into NWSHP to finish adding the space station to the
                        \ universe

ELIF _NES_VERSION

 LDA #SST               \ Set A to the space station type, and fall through
                        \ into NWSHP to finish adding the space station to the
                        \ universe

 JSR NWSHP              \ Call NWSHP to add the space station to the universe

 LDX XX21+2*SST-2       \ Set (Y X) to the address of the Coriolis station's
 LDY XX21+2*SST-1       \ ship blueprint

 LDA tek                \ If the system's tech level in tek is less than 10,
 CMP #10                \ jump to notadodo, so tech levels 0 to 9 have Coriolis
 BCC notadodo           \ stations, while 10 and above will have Dodo stations

 LDX XX21+2*DOD-2       \ Set (Y X) to the address of the Dodo station's ship
 LDY XX21+2*DOD-1       \ blueprint

.notadodo

 STX spasto             \ Store the address of the space station in spasto(1 0)
 STY spasto+1           \ so we spawn the correct type of station in part 4 of
                        \ the main flight loop

 JMP UpdateIconBar_b3   \ Update the icon bar so the docking computer icon gets
                        \ displayed to reflect that we are in the station's safe
                        \ zone, returning from the subroutine using a tail call

ENDIF

