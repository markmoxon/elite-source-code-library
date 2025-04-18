\ ******************************************************************************
\
\       Name: DIALS (Part 4 of 4)
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard: shields, fuel, laser & cabin temp, altitude
\  Deep dive: The dashboard indicators
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Screen

 LDA #&78               \ Set SC(1 0) = &7810, which is the screen address for
 STA SC+1               \ the character block containing the left end of the
 LDA #&10               \ top indicator in the left part of the dashboard, the
 STA SC                 \ one showing the forward shield

ELIF _ELECTRON_VERSION

 LDA #&76               \ Set SC(1 0) = &7630, which is the screen address for
 STA SC+1               \ the character block containing the left end of the
 LDA #&30               \ top indicator in the left part of the dashboard, the
 STA SC                 \ one showing the forward shield

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #&70               \ Set SC(1 0) = &7020, which is the screen address for
 STA SC+1               \ the character block containing the left end of the
 LDA #&20               \ top indicator in the left part of the dashboard, the
 STA SC                 \ one showing the forward shield

ELIF _C64_VERSION

 LDA #LO(DLOC%+8*6)     \ Set SC(1 0) to the screen bitmap address for the
 STA SC                 \ character block containing the left end of the top
 LDA #HI(DLOC%+8*6)     \ indicator in the left part of the dashboard, the one
 STA SC+1               \ showing the forward shield
                        \
                        \ DLOC% is the screen address of the dashboard (which
                        \ starts on character row 18) so this sets the address
                        \ to character 8 on that row

ENDIF

IF _C64_VERSION

 LDA #YELLOW            \ Set K (the colour we should show for high values) to
 STA K                  \ yellow

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ yellow, so the fuel indicator always shows in this
                        \ colour

ELIF _APPLE_VERSION

 LDA #16                \ Set K = 16 to use as the pixel x-coordinate of the
 STA K                  \ left end of the indicators in the left half of the
                        \ dashboard, which we draw now

ENDIF

IF NOT(_ELITE_A_DOCKED OR _APPLE_VERSION)

 LDA FSH                \ Draw the forward shield indicator using a range of
 JSR DILX               \ 0-255, and increment SC to point to the next indicator
                        \ (the aft shield)

 LDA ASH                \ Draw the aft shield indicator using a range of 0-255,
 JSR DILX               \ and increment SC to point to the next indicator (the
                        \ fuel level)

ELIF _APPLE_VERSION

 LDA FSH                \ Draw the forward shield indicator using a range of
 JSR DIS1               \ 0-255

 LDA ASH                \ Draw the aft shield indicator using a range of 0-255
 JSR DIS1

ELIF _ELITE_A_DOCKED

 LDA #255               \ Draw the forward shield indicator as fully charged,
 JSR DILX               \ and increment SC to point to the next indicator (the
                        \ aft shield)

 LDA #255               \ Draw the aft shield indicator as fully charged, and
 JSR DILX               \ increment SC to point to the next indicator (the fuel
                        \ level)

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA #YELLOW2           \ Set K (the colour we should show for high values) to
 STA K                  \ yellow

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ yellow, so the fuel indicator always shows in this
                        \ colour

ENDIF

IF NOT(_APPLE_VERSION)

 LDA QQ14               \ Draw the fuel level indicator using a range of 0-63,
 JSR DILX+2             \ and increment SC to point to the next indicator (the
                        \ cabin temperature)

ELIF _APPLE_VERSION

 LDA QQ14               \ Draw the fuel level indicator using a range of 0-63
 JSR DIS1+2

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Screen

 JSR PZW                \ Call PZW to set A to the colour for dangerous values
                        \ and X to the colour for safe values

ELIF _6502SP_VERSION OR _MASTER_VERSION

 JSR PZW2               \ Call PZW2 to set A to the colour for dangerous values
                        \ and X to the colour for safe values, suitable for
                        \ non-striped indicators

ELIF _ELECTRON_VERSION

 SEC                    \ Call NEXTR with the C flag set to move the screen
 JSR NEXTR              \ address in SC(1 0) down by one character row

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Electron: The Electron version doesn't include suns, so although there is a cabin temperature indicator in the dashboard, it never registers any temperature increases as the relevant code is missing

 STX K+1                \ Set K+1 (the colour we should show for low values) to
                        \ X (the colour to use for safe values)

 STA K                  \ Set K (the colour we should show for high values) to
                        \ A (the colour to use for dangerous values)

                        \ The above sets the following indicators to show red
                        \ for high values and yellow/white for low values, which
                        \ we use for the cabin and laser temperature bars

 LDX #11                \ Set T1 to 11, the threshold at which we change the
 STX T1                 \ cabin and laser temperature indicators' colours

 LDA CABTMP             \ Draw the cabin temperature indicator using a range of
 JSR DILX               \ 0-255, and increment SC to point to the next indicator
                        \ (the laser temperature)

ELIF _APPLE_VERSION

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255
 JSR DIS1

 LDA CABTMP             \ Draw the cabin temperature indicator using a range of
 JSR DIS1               \ 0-255

ENDIF

IF NOT(_APPLE_VERSION)

 LDA GNTMP              \ Draw the laser temperature indicator using a range of
 JSR DILX               \ 0-255, and increment SC to point to the next indicator
                        \ (the altitude)

ELIF _APPLE_VERSION

 LDA GNTMP              \ Draw the laser temperature indicator using a range of
 JSR DIS1               \ 0-255

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment

 LDA #240               \ Set T1 to 240, the threshold at which we change the
 STA T1                 \ altitude indicator's colour. As the altitude has a
                        \ range of 0-255, pixel 16 will not be filled in, and
                        \ 240 would change the colour when moving between pixels
                        \ 15 and 16, so this effectively switches off the colour
                        \ change for the altitude indicator

ELIF _ELECTRON_VERSION

 LDA #240               \ Set T1 to 240, which would set the threshold at which
 STA T1                 \ we change the altitude indicator's colour in the other
                        \ versions, but it has no effect here, as the Electron
                        \ version doesn't support indicator colour changes

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA #YELLOW2           \ Set K (the colour we should show for high values) to
 STA K                  \ yellow

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _MASTER_VERSION \ Minor

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ 240, or &F0 (dashboard colour 2, yellow/white), so the
                        \ altitude indicator always shows in this colour

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255
 JSR DILX

ELIF _ELECTRON_VERSION

 STA K+1                \ This sets K+1 to 240, which would set the colour to
                        \ show for low values in the other versions, but it has
                        \ no effect here, as the Electron version doesn't
                        \ support indicator colour changes

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255
 JSR DILX

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ 240, or &F0 (dashboard colour 2, yellow/white), so the
                        \ altitude indicator always shows in this colour

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255,
 JMP DILX               \ returning from the subroutine using a tail call

ELIF _6502SP_VERSION

 STA K+1                \ Set K+1 (the colour we should show for low values) to
                        \ yellow, so the altitude indicator always shows in this
                        \ colour

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255,
 JMP DILX               \ returning from the subroutine using a tail call

ELIF _C64_VERSION

\STA K+1                \ This instruction is commented out in the original
                        \ source

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255
 JSR DILX

ENDIF

IF _MASTER_VERSION \ Platform

 LDA #%00001001         \ Clear bits 1 and 2 of the Access Control Register at
 STA VIA+&34            \ SHEILA &34 to switch main memory back into &3000-&7FFF

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 JMP COMPAS             \ We have now drawn all the indicators, so jump to
                        \ COMPAS to draw the compass, returning from the
                        \ subroutine using a tail call

ENDIF

