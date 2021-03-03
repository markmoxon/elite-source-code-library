\ ******************************************************************************
\
\       Name: SHPPT
\       Type: Subroutine
\   Category: Drawing ships
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Comment
\    Summary: Draw a distant ship as a point rather than a full wireframe
ELIF _DISC_DOCKED
\    Summary: Draw a distant ship as a point in the middle of the screen
ENDIF
\
\ ******************************************************************************

.SHPPT

 JSR EE51               \ Call EE51 to remove the ship's wireframe from the
                        \ screen, if there is one

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 JSR PROJ               \ Project the ship onto the screen, returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate
                        \   * A = K4+1

 ORA K3+1               \ If either of the high bytes of the screen coordinates
 BNE nono               \ are non-zero, jump to nono as the ship is off-screen

 LDA K4                 \ Set A = the y-coordinate of the dot

ELIF _DISC_DOCKED

 LDA #Y                 \ Set A = the y-coordinate of a dot halfway down the
                        \ screen

ENDIF

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Comment

 CMP #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view

ELIF _DISC_DOCKED

 CMP #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view. This will
                        \ never happen, but this code is copied from the flight
                        \ code, where A can contain any y-coordinate

ENDIF

 LDY #2                 \ Call Shpt with Y = 2 to set up bytes 1-4 in the ship
 JSR Shpt               \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ first row of the dot (i.e. a four-pixel dash)

 LDY #6                 \ Set Y to 6 for the next call to Shpt

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 LDA K4                 \ Set A = y-coordinate of dot + 1 (so this is the second
 ADC #1                 \ row of the two-pixel-high dot)

ELIF _DISC_DOCKED

 LDA #Y                 \ Set A = #Y + 1 (so this is the second row of the
 ADC #1                 \ two-pixel-high dot halfway down the screen)

ENDIF

 JSR Shpt               \ Call Shpt with Y = 6 to set up bytes 5-8 in the ship
                        \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ second row of the dot (i.e. another four-pixel dash,
                        \ on the row below the first one)

 LDA #%00001000         \ Set bit 3 of the ship's byte #31 to record that we
 ORA XX1+31             \ have now drawn something on-screen for this ship
 STA XX1+31

IF _CASSETTE_VERSION OR _DISC_VERSION \ Advanced

 LDA #8                 \ Set A = 8 so when we call LL18+2 next, byte #0 of the
                        \ heap gets set to 8, for the 8 bytes we just stuck on
                        \ the heap

ELIF _6502SP_VERSION

 LDA #9                 \ Set A = 9 so when we call LL18+2 next, byte #0 of the
                        \ heap gets set to 9, to cover the 9 bytes we just stuck
                        \ on the heap

ENDIF

 JMP LL81+2             \ Call LL81+2 to draw the ship's dot, returning from the
                        \ subroutine using a tail call

 PLA                    \ Pull the return address from the stack, so the RTS
 PLA                    \ below actually returns from the subroutine that called
                        \ LL9 (as we called SHPPT from LL9 with a JMP)
.nono

 LDA #%11110111         \ Clear bit 3 of the ship's byte #31 to record that
 AND XX1+31             \ nothing is being drawn on-screen for this ship
 STA XX1+31

 RTS                    \ Return from the subroutine

.Shpt

                        \ This routine sets up four bytes in the ship line heap,
                        \ from byte Y-1 to byte Y+2. If the ship's screen point
                        \ turns out to be off-screen, then this routine aborts
                        \ the entire call to LL9, exiting via nono. The four
                        \ bytes define a horizontal 4-pixel dash, for either the
                        \ top or the bottom of the ship's dot

 STA (XX19),Y           \ Store A in byte Y of the ship line heap

 INY                    \ Store A in byte Y+2 of the ship line heap
 INY
 STA (XX19),Y

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT \ Platform

 LDA K3                 \ Set A = screen x-coordinate of the ship dot

ELIF _DISC_DOCKED

 LDA #X                 \ Set A = x-coordinate of the middle of the screen

ENDIF

 DEY                    \ Store A in byte Y+1 of the ship line heap
 STA (XX19),Y

 ADC #3                 \ Set A = screen x-coordinate of the ship dot + 3

 BCS nono-2             \ If the addition pushed the dot off the right side of
                        \ the screen, jump to nono-2 to return from the parent
                        \ subroutine early (i.e. LL9). This works because we
                        \ called Shpt from above with a JSR, so nono-2 removes
                        \ that return address from the stack, leaving the next
                        \ return address exposed. LL9 called SHPPT with a JMP.
                        \ so the next return address is the one that was put on
                        \ the stack by the original call to LL9. So the RTS in
                        \ nono will actually return us from the original call
                        \ to LL9, thus aborting the entire drawing process

 DEY                    \ Store A in byte Y-1 of the ship line heap
 DEY
 STA (XX19),Y

 RTS                    \ Return from the subroutine

