\ ******************************************************************************
\
\       Name: SHPPT
\       Type: Subroutine
\   Category: Drawing ships
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Draw a distant ship as a point rather than a full wireframe
ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA
\    Summary: Draw a distant ship as a point in the middle of the screen
ENDIF
\
\ ******************************************************************************

.SHPPT

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: Group A: When drawing a distant ship as a dot, the cassette, disc and 6502SP versions erase the entire on-screen ship before redrawing it, while the Master version erases and redraws each ship one line at a time

 JSR EE51               \ Call EE51 to remove the ship's wireframe from the
                        \ screen, if there is one

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Platform

 JSR PROJ               \ Project the ship onto the screen, returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate
                        \   * A = K4+1

 ORA K3+1               \ If either of the high bytes of the screen coordinates
 BNE nono               \ are non-zero, jump to nono as the ship is off-screen

 LDA K4                 \ Set A = the y-coordinate of the dot

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LDA #Y                 \ Set A = the y-coordinate of a dot halfway down the
                        \ screen

ELIF _NES_VERSION

 JSR PROJ               \ Project the ship onto the screen, returning:
                        \
                        \   * K3(1 0) = the screen x-coordinate
                        \   * K4(1 0) = the screen y-coordinate
                        \   * A = K4+1

 ORA K3+1               \ If either of the high bytes of the screen coordinates
 BNE nono               \ are non-zero, jump to nono as the ship is off-screen

 LDY K4                 \ Set Y = the y-coordinate of the dot

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment

 CMP #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 CMP #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view. This will
                        \ never happen, but this code is copied from the flight
                        \ code, where A can contain any y-coordinate

ELIF _NES_VERSION

 CPY #Y*2-2             \ If the y-coordinate is bigger than the y-coordinate of
 BCS nono               \ the bottom of the screen, jump to nono as the ship's
                        \ dot is off the bottom of the space view

                        \ The C flag is clear at this point as we just passed
                        \ through a BCS, so we call Shpt with the C flag clear

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: See group A

 LDY #2                 \ Call Shpt with Y = 2 to set up bytes 1-4 in the ship
 JSR Shpt               \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ first row of the dot (i.e. a four-pixel dash)

 LDY #6                 \ Set Y to 6 for the next call to Shpt

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 JSR Shpt               \ Call Shpt to draw a horizontal four-pixel dash for the
                        \ first row of the dot (i.e. a four-pixel dash)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _C64_VERSION \ Platform

 LDA K4                 \ Set A = y-coordinate of dot + 1 (so this is the second
 ADC #1                 \ row of the two-pixel high dot)
                        \
                        \ The addition works as the Shpt routine clears the C
                        \ flag

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA K4                 \ Set A = y-coordinate of dot + 1 (so this is the second
 CLC                    \ row of the two-pixel high dot)
 ADC #1

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LDA #Y                 \ Set A = #Y + 1 (so this is the second row of the
 ADC #1                 \ two-pixel high dot halfway down the screen)
                        \
                        \ The addition works as the Shpt routine clears the C
                        \ flag

ELIF _NES_VERSION

 INY                    \ Increment Y to the next row (so this is the second row
                        \ of the two-pixel high dot)

 CLC                    \ Clear the C flag to pass to Shpt

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION  \ Comment

 JSR Shpt               \ Call Shpt with Y = 6 to set up bytes 5-8 in the ship
                        \ lines space, aborting the call to LL9 if the dot is
                        \ off the side of the screen. This call sets up the
                        \ second row of the dot (i.e. another four-pixel dash,
                        \ on the row below the first one)

ELIF _MASTER_VERSION OR _APPLE_VERSION OR _NES_VERSION

 JSR Shpt               \ Call Shpt to draw a horizontal four-pixel dash for the
                        \ second row of the dot (i.e. a four-pixel dash)

ENDIF

IF NOT(_NES_VERSION)

 LDA #%00001000         \ Set bit 3 of the ship's byte #31 to record that we
 ORA XX1+31             \ have now drawn something on-screen for this ship
 STA XX1+31

ELIF _NES_VERSION

 BIT XX1+31             \ If bit 6 of the ship's byte #31 is clear, then there
 BVC nono               \ are no lasers firing, so jump to nono to record that
                        \ we didn't draw anything and return from the subroutine

 LDA XX1+31             \ Clear 6 in the ship's byte #31 to denote that there
 AND #%10111111         \ are no lasers firing (bit 6), as we are about to draw
 STA XX1+31             \ the laser line and this will ensure it flickers off in
                        \ the next iteration

                        \ We now draw the laser line, from the ship dot at
                        \ (X1, Y1), as set in the call to Shpt, to a point on
                        \ the edge of the screen

 LDX #1                 \ Set X = 1 to use as the x-coordinate for the end of
                        \ the laser line for when z_lo < 128 (so the ship fires
                        \ to our left)

 LDA XX1+6              \ Set A = z_lo

 BPL shpt1              \ If z_lo < 128, jump to shpt1 to leave X = 1

 LDX #255               \ Set X = 255 to use as the x-coordinate for the end of
                        \ the laser line for when z_lo >= 128 (so the ship fires
                        \ to our left)
                        \
                        \ This makes the ship fire to our left and right as it
                        \ gets closer to us, as z_lo reduces from 255 to 0 for
                        \ each reduction in z_hi

.shpt1

 STX X2                 \ Set X2 to the x-coordinate of the end of the laser
                        \ line

 AND #63                \ Set Y2 = z_lo, reduced to the range 0 to 63, plus 32
 ADC #32                \
 STA Y2                 \ So the end of the laser line moves up and down the
                        \ edge of the screen (between y-coordinate 32 and 95) as
                        \ the ship gets closer to us, as z_lo reduces from 255
                        \ to 0 for each reduction in z_hi

 JSR LOIN               \ Draw the laser line from (X1, Y1) to (X2, Y2)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION \ Advanced: Ships in the advanced versions each have their own colour, including when they are shown as points

 LDA #8                 \ Set A = 8 so when we call LL18+2 next, byte #0 of the
                        \ heap gets set to 8, for the 8 bytes we just stuck on
                        \ the heap

ELIF _6502SP_VERSION

 LDA #9                 \ Set A = 9 so when we call LL18+2 next, byte #0 of the
                        \ heap gets set to 9, to cover the 9 bytes we just stuck
                        \ on the heap

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: See group A

 JMP LL81+2             \ Call LL81+2 to draw the ship's dot, returning from the
                        \ subroutine using a tail call

 PLA                    \ Pull the return address from the stack, so the RTS
 PLA                    \ below actually returns from the subroutine that called
                        \ LL9 (as we called SHPPT from LL9 with a JMP)

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JMP LSCLR              \ Jump to LSCLR to draw any remaining lines that are
                        \ still in the ship line heap and return from the
                        \ subroutine using a tail call

ENDIF

.nono

 LDA #%11110111         \ Clear bit 3 of the ship's byte #31 to record that
 AND XX1+31             \ nothing is being drawn on-screen for this ship
 STA XX1+31

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Master: See group A

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION OR _APPLE_VERSION

 JMP LSCLR              \ Jump to LSCLR to draw any remaining lines that are
                        \ still in the ship line heap and return from the
                        \ subroutine using a tail call

ENDIF

.Shpt

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _C64_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group A

                        \ This routine sets up four bytes in the ship line heap,
                        \ from byte Y-1 to byte Y+2. If the ship's screen point
                        \ turns out to be off-screen, then this routine aborts
                        \ the entire call to LL9, exiting via nono. The four
                        \ bytes define a horizontal four-pixel dash, for either
                        \ the top or the bottom of the ship's dot

 STA (XX19),Y           \ Store A in byte Y of the ship line heap (i.e. Y1)

 INY                    \ Store A in byte Y+2 of the ship line heap (i.e. Y2)
 INY
 STA (XX19),Y

ELIF _MASTER_VERSION

                        \ This routine draws a horizontal four-pixel dash, for
                        \ either the top or the bottom of the ship's dot

 STA Y1                 \ Store A in both y-coordinates, as this is a horizontal
 STA Y2                 \ dash at y-coordinate A

ELIF _APPLE_VERSION

                        \ This routine draws a horizontal four-pixel dash, for
                        \ either the top or the bottom of the ship's dot

 STA XX15+1             \ Store A in both y-coordinates, as this is a horizontal
 STA XX15+3             \ dash at y-coordinate A

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA K3                 \ Set A = screen x-coordinate of the ship dot

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LDA #X                 \ Set A = x-coordinate of the middle of the screen

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION \ Master: The Master implements flicker-free ship drawing using the LSPUT routine, which is used both for drawing wireframes and for drawing distant ships as dots

 DEY                    \ Store A in byte Y+1 of the ship line heap (i.e. X2)
 STA (XX19),Y

 ADC #3                 \ Set A = screen x-coordinate of the ship dot + 3

 BCS nono-2             \ If the addition pushed the dot off the right side of
                        \ the screen, jump to nono-2 to return from the parent
                        \ subroutine early (i.e. LL9). This works because we
                        \ called Shpt from above with a JSR, so nono-2 removes
                        \ that return address from the stack, leaving the next
                        \ return address exposed. LL9 called SHPPT with a JMP,
                        \ so the next return address is the one that was put on
                        \ the stack by the original call to LL9. So the RTS in
                        \ nono will actually return us from the original call
                        \ to LL9, thus aborting the entire drawing process

 DEY                    \ Store A in byte Y-1 of the ship line heap (i.e. X1)
 DEY
 STA (XX19),Y

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 STA X1                 \ Store the x-coordinate of the ship dot in X1, as this
                        \ is where the dash starts

 CLC                    \ Set A = screen x-coordinate of the ship dot + 3
 ADC #3

 BCC P%+4               \ If the addition overflowed, set A = 255, the
 LDA #255               \ x-coordinate of the right edge of the screen

 STA X2                 \ Store the x-coordinate of the ship dot in X1, as this
                        \ is where the dash starts

 JMP LSPUT              \ Draw this edge using flicker-free animation, by first
                        \ drawing the ship's new line and then erasing the
                        \ corresponding old line from the screen, and return
                        \ from the subroutine using a tail call

ELIF _APPLE_VERSION

 STA XX15               \ Store the x-coordinate of the ship dot in X1, as this
                        \ is where the dash starts

 CLC                    \ Set A = screen x-coordinate of the ship dot + 3
 ADC #3

 BCC P%+4               \ If the addition overflowed, set A = 255, the
 LDA #255               \ x-coordinate of the right edge of the screen

 STA XX15+2             \ Store the x-coordinate of the ship dot in X1, as this
                        \ is where the dash starts

 JMP LSPUT              \ Draw this edge using flicker-free animation, by first
                        \ drawing the ship's new line and then erasing the
                        \ corresponding old line from the screen, and return
                        \ from the subroutine using a tail call

ELIF _NES_VERSION

                        \ This routine draws a horizontal four-pixel dash, for
                        \ either the top or the bottom of the ship's dot
                        \
                        \ We always call this routine with the C flag clear

 LDA K3                 \ Set A = screen x-coordinate of the ship dot

 STA X1                 \ Set X1 to the screen x-coordinate of the ship dot

 ADC #3                 \ Set A = screen x-coordinate of the ship dot + 3
                        \ (this works because we know the C flag is clear)

 BCS shpt2              \ If the addition overflowed, jump to shpt2 to return
                        \ from the subroutine without drawing the dash

 STA X2                 \ Store the x-coordinate of the ship dot in X1, as this
                        \ is where the dash starts

 STY Y1                 \ Store Y in both y-coordinates, as this is a horizontal
 STY Y2                 \ dash at y-coordinate Y

 JMP LOIN               \ Draw the dash from (X1, Y1) to (X2, Y2), returning
                        \ from the subroutine using a tail call

.shpt2

 PLA                    \ Pull the return address from the stack, so the RTS
 PLA                    \ below actually returns from the subroutine that called
                        \ LL9 (as we called SHPPT from LL9 with a JMP)

 JMP nono               \ Jump to nono to record that we didn't draw anything
                        \ and return from the subroutine

ENDIF

