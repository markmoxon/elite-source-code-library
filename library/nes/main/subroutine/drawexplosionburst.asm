\ ******************************************************************************
\
\       Name: DrawExplosionBurst
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw an exploding ship
\
\ ******************************************************************************

.DrawExplosionBurst

 LDY #0                 \ ???
 STY burstSpriteIndex

 LDA cloudSize
 STA Q
 LDA INWK+34

                        \ The following code is avery similar to the PTCLS
                        \ routine

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

 LDY #7                 \ ???

 LDA (XX0),Y            \ Fetch byte #2 of the ship line heap, which contains
 STA TGT                \ the explosion count for this ship (i.e. the number of
                        \ vertices used as origins for explosion clouds) and
                        \ store it in TGT ???

 LDA RAND+1             \ Fetch the current random number seed in RAND+1 and
 PHA                    \ store it on the stack, so we can re-randomise the
                        \ seeds when we are done

 LDY #6                 \ Set Y = 6 to point to the byte before the first vertex
                        \ coordinate we stored on the ship line heap above (we
                        \ increment it below so it points to the first vertex)

.burs1

 LDX #3                 \ We are about to fetch a pair of coordinates from the
                        \ ship line heap, so set a counter in X for 4 bytes

.burs2

 INY                    \ Increment the index in Y so it points to the next byte
                        \ from the coordinate we are copying

 LDA XX3-7,Y            \ Copy the Y-th byte from the ship line heap to the X-th
 STA K3,X               \ byte of K3 ???

 DEX                    \ Decrement the X index

 BPL burs2              \ Loop back to burs2 until we have copied all four bytes

                        \ The above loop copies the vertex coordinates from the
                        \ ship line heap to K3, reversing them as we go, so it
                        \ sets the following:
                        \
                        \   K3+3 = x_lo
                        \   K3+2 = x_hi
                        \   K3+1 = y_lo
                        \   K3+0 = y_hi

 STY CNT                \ Set CNT to the index that points to the next vertex on
                        \ the ship line heap

 LDA burstSpriteIndex   \ ???
 CLC
 ADC #4
 CMP #&10
 BCS burs5
 STA burstSpriteIndex
 TAY
 LDA XX2
 ORA XX2+2
 BNE burs3
 LDA XX2+3
 SBC #3
 BCC burs3
 STA xSprite58,Y
 LDA #2
 STA attrSprite58,Y
 LDA K3+1
 CMP #&80
 BCC burs4

.burs3

 LDA #&F0
 STA ySprite58,Y
 BNE burs5

.burs4

 ADC #10+YPAL

 STA ySprite58,Y
 LDA #&F5
 STA tileSprite58,Y

.burs5

 LDY #&25               \ See PTCLS
 LDA (INF),Y
 EOR CNT
 STA RAND
 INY
 LDA (INF),Y
 EOR CNT
 STA RAND+1
 INY
 LDA (INF),Y
 EOR CNT
 STA RAND+2
 INY
 LDA (INF),Y
 EOR CNT
 STA RAND+3

                        \ The following code is avery similar to the EXL4
                        \ section of the DOEXP routine

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

 CPX Yx2M1              \ If X > the y-coordinate of the bottom of the screen,
 BCS burs8              \ the particle is off the bottom of the screen, so jump
                        \ to burs8 to do the next particle ???

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

 BPL burs6              \ Loop back to burs6 until we have done all the particles
                        \ in the cloud

 LDY CNT                \ Set Y to the index that points to the next vertex on
                        \ the ship line heap

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

 JMP burs7              \ ???
