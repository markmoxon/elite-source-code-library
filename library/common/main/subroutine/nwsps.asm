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

IF _CASSETTE_VERSION

 LDX #1                 \ Set the AI flag in byte #32 to 1 (friendly, no AI, has
 STX INWK+32            \ E.C.M.)

 DEX                    \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

ELIF _6502SP_VERSION

 LDX #&81
 STX INWK+32

 LDX #0                 \ Set pitch counter to 0 (no pitch, roll only)
 STX INWK+30

 STX NEWB

ENDIF

\STX INWK+31            \ This instruction is commented out in the original
                        \ source. It would set the exploding state and missile
                        \ count to 0

 STX FRIN+1             \ Set the sun/space station slot at FRIN+1 to 0, to
                        \ indicate we should show the space station rather than
                        \ the sun

 DEX                    \ Set roll counter to 255 (maximum roll with no
 STX INWK+29            \ damping)

 LDX #10                \ Call NwS1 to flip the sign of nosev_x_hi (byte #10)
 JSR NwS1

 JSR NwS1               \ And again to flip the sign of nosev_y_hi (byte #12)

 JSR NwS1               \ And again to flip the sign of nosev_z_hi (byte #14)

IF _6502SP_VERSION

 LDA spasto
 STA XX21+2*SST-2
 LDA spasto+1
 STA XX21+2*SST-1
 LDA tek
 CMP #10
 BCC notadodo
 LDA XX21+2*DOD-2
 STA XX21+2*SST-2
 LDA XX21+2*DOD-1
 STA XX21+2*SST-1

.notadodo

ENDIF

 LDA #LO(LSO)           \ Set bytes #33 and #34 to point to LSO for the ship
 STA INWK+33            \ line heap for the space station
 LDA #HI(LSO)
 STA INWK+34

 LDA #SST               \ Set A to the space station type, and fall through
                        \ into NWSHP to finish adding the space station to the
                        \ universe

