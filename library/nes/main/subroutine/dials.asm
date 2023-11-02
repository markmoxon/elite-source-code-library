\ ******************************************************************************
\
\       Name: DIALS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the dashboard
\  Deep dive: Sprite usage in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.DIALS

 LDA drawingBitplane    \ If the drawing bitplane is 1, jump to dial1 so we only
 BNE dial1              \ update the bar indicators every other frame, to save
                        \ time

 LDA #HI(nameBuffer0+23*32+2)   \ Set SC(1 0) to the address of the third tile
 STA SC+1                       \ on tile row 23 in nametable buffer 0, which is
 LDA #LO(nameBuffer0+23*32+2)   \ the leftmost tile in the fuel indicator at the
 STA SC                         \ top-left corner of the dashboard

 LDA #0                 \ Set the indicator's safe range from 0 to 255 by
 STA K                  \ setting K to 0 and K+1 to 255, so all values are safe
 LDA #255
 STA K+1

 LDA QQ14               \ Draw the fuel level indicator using a range of 0-63,
 JSR DILX+2             \ and increment SC to point to the next indicator (the
                        \ forward shield)

 LDA #8                 \ Set the indicator's safe range from 8 to 255 by
 STA K                  \ setting K to 8 and K+1 to 255, so all values are safe
 LDA #255               \ except those below 8, which are dangerous
 STA K+1

 LDA FSH                \ Draw the forward shield indicator using a range of
 JSR DILX               \ 0-255, and increment SC to point to the next indicator
                        \ (the aft shield)

 LDA ASH                \ Draw the aft shield indicator using a range of 0-255,
 JSR DILX               \ and increment SC to point to the next indicator (the
                        \ energy banks)

 LDA ENERGY             \ Draw the energy bank indicator using a range of 0-255,
 JSR DILX               \ and increment SC to point to the next indicator (the
                        \ cabin temperature)

 LDA #0                 \ Set the indicator's safe range from 0 to 23 by
 STA K                  \ setting K to 0 and K+1 to 24, so values from 0 to 23
 LDA #24                \ are safe, while values of 24 or more are dangerous
 STA K+1

 LDA CABTMP             \ Draw the cabin temperature indicator using a range of
 JSR DILX               \ 0-255, and increment SC to point to the next indicator
                        \ (the laser temperature)

 LDA GNTMP              \ Draw the laser temperature indicator using a range of
 JSR DILX               \ 0-255

 LDA #HI(nameBuffer0+27*32+28)  \ Set SC(1 0) to the address of the 28th tile
 STA SC+1                       \ on tile row 27 in nametable buffer 0, which is
 LDA #LO(nameBuffer0+27*32+28)  \ the leftmost tile in the speed indicator in
 STA SC                         \ the bottom-right corner of the dashboard

 LDA #0                 \ Set the indicator's safe range from 0 to 255 by
 STA K                  \ setting K to 0 and K+1 to 255, so all values are safe
 LDA #255
 STA K+1

 LDA DELTA              \ Fetch our ship's speed into A, in the range 0-40

 LSR A                  \ Set A = A / 2 + DELTA
 ADC DELTA              \       = 1.5 * DELTA

 JSR DILX+2             \ Draw the speed level indicator using a range of 0-63,
                        \ and increment SC to point to the next indicator
                        \ (altitude)

 LDA #8                 \ Set the indicator's safe range from 8 to 255 by
 STA K                  \ setting K to 8 and K+1 to 255, so all values are safe
 LDA #255               \ except those below 8, which are dangerous
 STA K+1

 LDA ALTIT              \ Draw the altitude indicator using a range of 0-255
 JSR DILX

.dial1

                        \ We now set up sprite 10 to use for the ship status
                        \ indicator

 LDA #186+YPAL          \ Set the y-coordinate of sprite 10 to 186
 STA ySprite10

 LDA #206               \ Set the x-coordinate of sprite 10 to 206
 STA xSprite10

 JSR GetStatusCondition \ Set X to our ship's status condition (0 to 3)

 LDA conditionAttrs,X   \ Set the sprite's attributes to the corresponding
 STA attrSprite10       \ entry from the conditionAttrs table, so the correct
                        \ colour is set for the ship's status condition

 LDA conditionPatts,X   \ Set the pattern to the corresponding entry from the
 STA pattSprite10       \ conditionPatts table, so the correct pattern is used
                        \ for the ship's status condition

                        \ And finally we update the active missile indicator
                        \ and the square targeting reticle

 LDA QQ12               \ If we are docked then QQ12 is non-zero, so jump to
 BNE dial2              \ dial2 to hide the square targeting reticle in sprite 9

 LDA MSTG               \ If MSTG does not contain &FF then the active missile
 BPL dial4              \ has a target lock (and MSTG contains a slot number),
                        \ so jump to dial4 to show the square targeting reticle
                        \ in the middle of the laser sights

 LDA MSAR               \ If MSAR = 0 then the missile is not looking for a
 BEQ dial2              \ target, so jump to dial2 to hide the square targeting
                        \ reticle in sprite 9

                        \ We now flash the active missile indicator between
                        \ black and red, and flash the square targeting reticle
                        \ in sprite 9 on and off, to indicate that the missile
                        \ is searching for a target

 LDX NOMSL              \ Fetch the current number of missiles from NOMSL into X
                        \ (which is also the number of the active missile)

 LDY #109               \ Set Y = 109 to use as the pattern for the red missile
                        \ indicator

 LDA MCNT               \ Fetch the main loop counter and jump to dial3 if bit 3
 AND #%00001000         \ is set, which will be true half of the time, with the
 BNE dial3              \ bit being 0 for eight iterations around the main loop,
                        \ and 1 for the next eight iterations
                        \
                        \ If we jump to dial3 then the indicator is shown in
                        \ red, and if we don't jump it is shown in black, so
                        \ this flashes the missile indicator between red and
                        \ black, changing the colour every eight iterations of
                        \ the main loop

 LDY #108               \ Set the pattern for the missile indicator at position
 JSR MSBAR_b6           \ X to 108, which is a black indicator

.dial2

 LDA #240               \ Hide sprite 9 (the square targeting reticle) by moving
 STA ySprite9           \ sprite 9 to y-coordinate 240, off the bottom of the
                        \ screen

 RTS                    \ Return from the subroutine

.dial3

 JSR MSBAR_b6           \ Set the pattern for the missile indicator at position
                        \ X to pattern Y, which we set to 109 above, so this
                        \ sets the indicator to red

.dial4
                        \ If we get here then our missile is targeted, so show
                        \ the square targeting reticle in the middle of the
                        \ laser sights

 LDA #248               \ Set the pattern for sprite 9 to 248, which is a square
 STA pattSprite9        \ outline

 LDA #%00000001         \ Set the attributes for sprite 9 as follows:
 STA attrSprite9        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #126               \ Set the x-coordinate for sprite 9 to 126
 STA xSprite9

 LDA #83+YPAL           \ Set the y-coordinate for sprite 9 to 126
 STA ySprite9

 RTS                    \ Return from the subroutine

