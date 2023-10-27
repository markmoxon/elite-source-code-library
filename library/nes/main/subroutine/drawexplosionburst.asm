\ ******************************************************************************
\
\       Name: DrawExplosionBurst
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw an exploding ship along with an explosion burst made up of
\             colourful sprites
\
\ ******************************************************************************

.DrawExplosionBurst

 LDY #0                 \ Set burstSpriteIndex = 0 to use as an index into the
 STY burstSpriteIndex   \ sprite buffer when drawing the four explosion sprites
                        \ below

 LDA cloudSize          \ Fetch the cloud size that we stored above, and store
 STA Q                  \ it in Q

 LDA INWK+34            \ Fetch byte #34 of the ship data block, which contains
                        \ the cloud counter

 BPL P%+4               \ If the cloud counter < 128, then we are in the first
                        \ half of the cloud's existence, so skip the next
                        \ instruction

 EOR #&FF               \ Flip the value of A so that in the second half of the
                        \ cloud's existence, A counts down instead of up

 LSR A                  \ Divide A by 16 so that is has a maximum value of 7
 LSR A
 LSR A
 LSR A

 ORA #1                 \ Make sure A is at least 1 and store it in U, to
 STA U                  \ give us the number of particles in the explosion for
                        \ each vertex

 LDY #7                 \ Fetch byte #7 of the ship blueprint, which contains
 LDA (XX0),Y            \ the explosion count for this ship (i.e. the number of
 STA TGT                \ vertices used as origins for explosion clouds) and
                        \ store it in TGT

 LDA RAND+1             \ Fetch the current random number seed in RAND+1 and
 PHA                    \ store it on the stack, so we can re-randomise the
                        \ seeds when we are done

 LDY #6                 \ Set Y = 6 to point to the byte before the first vertex
                        \ coordinate we stored on the XX3 heap above (we
                        \ increment it below so it points to the first vertex)

.burs1

 LDX #3                 \ We are about to fetch a pair of coordinates from the
                        \ XX3 heap, so set a counter in X for 4 bytes

.burs2

 INY                    \ Increment the index in Y so it points to the next byte
                        \ from the coordinate we are copying

 LDA XX3-7,Y            \ Copy byte Y-7 from the XX3 heap to the X-th byte of K3
 STA K3,X

 DEX                    \ Decrement the loop counter

 BPL burs2              \ Keep copying vertex coordinates into K3 until we have
                        \ copied all six coordinates

                        \ The above loop copies the vertex coordinates from the
                        \ XX3 heap to K3, reversing them as we go, so it sets
                        \ the following:
                        \
                        \   K3+3 = x_lo
                        \   K3+2 = x_hi
                        \   K3+1 = y_lo
                        \   K3+0 = y_hi

 STY CNT                \ Set CNT to the index that points to the next vertex on
                        \ the XX3 heap

                        \ We now draw the explosion burst, which consists of
                        \ four colourful sprites that appear for the first part
                        \ of the explosion only
                        \
                        \ We use sprites 59 to 62 for the explosion burst

 LDA burstSpriteIndex   \ Set burstSpriteIndex = burstSpriteIndex + 4
 CLC                    \
 ADC #4                 \ So it points to the next sprite in the sprite buffer
                        \ (as each sprite takes up four bytes)

 CMP #16                \ If burstSpriteIndex >= 16 then we have already
 BCS burs5              \ processed all four sprites, so jump to burs5 to move
                        \ on to drawing the explosion cloud

 STA burstSpriteIndex   \ Update burstSpriteIndex to the new value

 TAY                    \ Set Y to the burst sprite index so we can use it as an
                        \ index into the sprite buffer

 LDA K3                 \ If either of y_hi or x_hi are non-zero, jump to burs3
 ORA K3+2               \ to hide this explosion sprite, as the explosion is off
 BNE burs3              \ the sides of the screen

 LDA K3+3               \ Set A = x_lo - 4
 SBC #3                 \
                        \ As each explosion burst sprite is eight pixels wide,
                        \ this calculates the x-coordinate of the centre of the
                        \ sprite
                        \
                        \ The SBC #3 actually subtracts 4 as we know the C flag
                        \ is clear, as we passed through a BCS above

 BCC burs3              \ If the subtraction underflowed then the centre of the
                        \ sprite is off the top of the screen, so jump to burs3
                        \ to hide this explosion sprite

 STA xSprite58,Y        \ Set the x-coordinate for the explosion burst sprite
                        \ to A (starting from sprite 59, as Y is a minimum of 4)

 LDA #%00000010         \ Set the attributes for the sprite as follows:
 STA attrSprite58,Y     \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA K3+1               \ Set A = y_lo

 CMP #128               \ If A < 128 then the sprite is within the space view,
 BCC burs4              \ so jump to burs4 to configure the rest of the sprite

                        \ Otherwise the sprite is not in the space view, so fall
                        \ through into burs3 to hide this explosion sprite

.burs3

 LDA #240               \ Hide this explosion burst sprite by setting its
 STA ySprite58,Y        \ y-coordinate to 240, which is off the bottom of the
                        \ screen

 BNE burs5              \ Jump to burs5 to move on to drawing the explosion
                        \ cloud (this BNE is effectively a JMP as A is never
                        \ zero)

.burs4

 ADC #10+YPAL           \ Set the pixel y-coordinate of the explosion sprite to
 STA ySprite58,Y        \ A + 10

 LDA #245               \ Set the sprite's pattern number to 245, which is a
 STA pattSprite58,Y     \ fairly messy explosion pattern

.burs5

                        \ This next part copies bytes #37 to #40 from the ship
                        \ data block into the four random number seeds in RAND
                        \ to RAND+3, EOR'ing them with the vertex index so they
                        \ are different for every vertex. This enables us to
                        \ generate random numbers for drawing each vertex that
                        \ are random but repeatable, which we need when we
                        \ redraw the cloud to remove it
                        \
                        \ We set the values of bytes #37 to #40 randomly in the
                        \ LL9 routine before calling DOEXP, so the explosion
                        \ cloud is random but repeatable

 LDY #37                \ Set Y to act as an index into the ship data block for
                        \ byte #37

 LDA (INF),Y            \ Set the seed at RAND to byte #37, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND               \ vertex

 INY                    \ Increment Y to point to byte #38

 LDA (INF),Y            \ Set the seed at RAND+1 to byte #38, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+1             \ vertex

 INY                    \ Increment Y to point to byte #39

 LDA (INF),Y            \ Set the seed at RAND+2 to byte #39, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+2             \ vertex

 INY                    \ Increment Y to point to byte #40

 LDA (INF),Y            \ Set the seed at RAND+3 to byte #49, EOR'd with the
 EOR CNT                \ vertex index, so the seeds are different for each
 STA RAND+3             \ vertex

 LDY U                  \ Set Y to the number of particles in the explosion for
                        \ each vertex, which we stored in U above. We will now
                        \ use this as a loop counter to iterate through all the
                        \ particles in the explosion

.burs6

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DORND2             \ Set ZZ to a random number, making sure the C flag
 STA ZZ                 \ doesn't affect the outcome

 LDA K3+1               \ Set (A R) = (y_hi y_lo)
 STA R                  \           = y
 LDA K3

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = y +/- random * cloud size

 BNE burs8              \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to burs8 to do
                        \ the next particle

 CPX Yx2M1              \ If X > the y-coordinate of the bottom of the screen
 BCS burs8              \ (which is in Yx2M1) then the particle is off the
                        \ bottom of the screen, so jump to burs8 to do the next
                        \ particle

                        \ Otherwise X contains a random y-coordinate within the
                        \ cloud

 STX Y1                 \ Set Y1 = our random y-coordinate within the cloud

 LDA K3+3               \ Set (A R) = (x_hi x_lo)
 STA R
 LDA K3+2

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = x +/- random * cloud size

 BNE burs7              \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to burs8 to do
                        \ the next particle

                        \ Otherwise X contains a random x-coordinate within the
                        \ cloud

 LDA Y1                 \ Set A = our random y-coordinate within the cloud

 JSR PIXEL              \ Draw a point at screen coordinate (X, A) with the
                        \ point size determined by the distance in ZZ

.burs7

 DEY                    \ Decrement the loop counter for the next particle

 BPL burs6              \ Loop back to burs6 until we have done all the
                        \ particles in the cloud

 LDY CNT                \ Set Y to the index that points to the next vertex on
                        \ the XX3 heap

 CPY TGT                \ If Y < TGT, which we set to the explosion count for
 BCS P%+5               \ this ship (i.e. the number of vertices used as origins
 JMP burs1              \ for explosion clouds), loop back to burs1 to do a
                        \ cloud for the next vertex

 PLA                    \ Restore the current random number seed to RAND+1 that
 STA RAND+1             \ we stored at the start of the routine

 LDA K%+6               \ Store the z_lo coordinate for the planet (which will
 STA RAND+3             \ be pretty random) in the RAND+3 seed

 RTS                    \ Return from the subroutine

.burs8

 JSR DORND2             \ Set A and X to random numbers, making sure the C flag
                        \ doesn't affect the outcome

 JMP burs7              \ Jump up to burs7 to move on to the next particle

