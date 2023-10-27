\ ******************************************************************************
\
\       Name: ResetStardust
\       Type: Subroutine
\   Category: Stardust
\    Summary: Hide the sprites for the stardust
\
\ ******************************************************************************

.ResetStardust

 LDX #NOST              \ Set X to the maximum number of stardust particles, so
                        \ we loop through all the particles of stardust in the
                        \ following, hiding them all

 LDY #152               \ Set Y to the starting index in the sprite buffer, so
                        \ we start hiding from sprite 152 / 4 = 38 (as each
                        \ sprite in the buffer consists of four bytes)

.rest1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #240               \ Set A to the y-coordinate that's just below the bottom
                        \ of the screen, so we can hide the required sprites by
                        \ moving them off-screen

 STA ySprite0,Y         \ Set the y-coordinate for sprite Y / 4 to 240 to hide
                        \ it (the division by four is because each sprite in the
                        \ sprite buffer has four bytes of data)

 LDA #210               \ Set the sprite to use pattern number 210 for the
 STA pattSprite0,Y      \ largest particle of stardust (the stardust particle
                        \ patterns run from pattern 210 to 214, decreasing in
                        \ size as the number increases)

 TXA                    \ Take the particle number, which is between 1 and 20
 LSR A                  \ (as NOST is 20), and rotate it around from %76543210
 ROR A                  \ to %10xxxxx3 (where x indicates a zero), storing the
 ROR A                  \ result as the sprite attribute
 AND #%11100001         \
 STA attrSprite0,Y      \ This sets the flip horizontally and flip vertically
                        \ attributes to bits 0 and 1 of the particle number, and
                        \ the palette to bit 3 of the particle number, so the
                        \ reset stardust particles have a variety of reflections
                        \ and palettes

 INY                    \ Add 4 to Y so it points to the next sprite's data in
 INY                    \ the sprite buffer
 INY
 INY

 DEX                    \ Decrement the loop counter in X

 BNE rest1              \ Loop back until we have hidden X sprites

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR SIGHT_b3           \ Draw the laser crosshairs

                        \ Fall through into SetupSpaceView to finish setting up
                        \ the space view's NMI configuration

