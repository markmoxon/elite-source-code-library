\ ******************************************************************************
\
\       Name: NWSPS
\       Type: Subroutine
\   Category: Universe
\    Summary: Add a new space station to our local bubble of universe
\
\ ******************************************************************************

.NWSPS

 JSR SPBLB              \ Light up the space station bulb on the dashboard

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Space stations in the enhanced versions are always set to be aggressive if attacked, but they start out friendly; in the cassette version, they have no aggression at all until they are attacked

 LDX #%00000001         \ Set the AI flag in byte #32 to %00000001 (friendly, no
 STX INWK+32            \ AI, has an E.C.M.)

 DEX                    \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDX #%10000001         \ Set the AI flag in byte #32 to %10000001 (hostile,
 STX INWK+32            \ no AI, has an E.C.M.)

 LDX #0                 \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

 STX NEWB               \ Set NEWB to %00000000, though this gets overridden by
                        \ the default flags from E% in NWSHP below

ENDIF

\STX INWK+31            \ This instruction is commented out in the original
                        \ source. It would set the exploding state and missile
                        \ count to 0

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 STX FRIN+1             \ Set the sun/space station slot at FRIN+1 to 0, to
                        \ indicate we should show the space station rather than
                        \ the sun

ELIF _ELECTRON_VERSION

 STX FRIN+1             \ Set the space station slot at FRIN+1 to 0, to indicate
                        \ we should show the space station

ENDIF

 DEX                    \ Set roll counter to 255 (maximum roll with no
 STX INWK+29            \ damping)

 LDX #10                \ Call NwS1 to flip the sign of nosev_x_hi (byte #10)
 JSR NwS1

 JSR NwS1               \ And again to flip the sign of nosev_y_hi (byte #12)

 JSR NwS1               \ And again to flip the sign of nosev_z_hi (byte #14)

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

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

 LDA #LO(LSO)           \ Set bytes #33 and #34 to point to LSO for the ship
 STA INWK+33            \ line heap for the space station
 LDA #HI(LSO)
 STA INWK+34

 LDA #SST               \ Set A to the space station type, and fall through
                        \ into NWSHP to finish adding the space station to the
                        \ universe

