\ ******************************************************************************
\
\       Name: PTCLS2
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw the explosion along with an explosion sprite
\
\ ------------------------------------------------------------------------------
\
\ This routine is very similar to the PTCLS section of the DOEXP subroutine,
\ except it draws an explosion sprite along with the explosion cloud. It is only
\ called once for each explosion cloud, at the start of the explosion process.
\
\ ******************************************************************************

.PTCLS2

 LDA #%101              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 1
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM except for
                        \ the I/O memory map at $D000-$DFFF, which gets mapped
                        \ to registers in the VIC-II video controller chip, the
                        \ SID sound chip, the two CIA I/O chips, and so on
                        \
                        \ See the memory map at the top of page 264 in the
                        \ Programmer's Reference Guide

                        \ We now set up sprite 1, so we can use it to show the
                        \ explosion burst as a colourful sprite (along with the
                        \ usual cloud of explosion particles)

 LDA INWK+7             \ If z_hi >= 7 then set the following:
 CMP #7                 \
 LDA #%11111101         \   * A = %11111101
 LDX #44                \   * X = 44
 LDY #40                \   * Y = 40
 BCS noexpand           \
 LDA #%11111111         \ otherwise set the following:
 LDX #32                \
 LDY #30                \   * A = %11111111
                        \   * X = 32
                        \   * Y = 30

.noexpand

 STA VIC+&17            \ Store A in VIC registers &17 and &1D, which determine
 STA VIC+&1D            \ whether sprites are double height and double width
                        \
                        \ So this set sprite 1 to be standard width and height
                        \ when z_hi >= 7 (as bit 1 of A is clear), or double
                        \ width and height when z_hi < 7 (as bit 1 of A is set)
                        \
                        \ We are about to use sprite 1 to display the explosion
                        \ sprite, so this means that explosions that are far
                        \ away will show a smaller sprite than explosions that
                        \ are closer

 STX sprx               \ Store X and Y in sprx and spry, to be used as the
 STY spry               \ x- and y-coordinate offsets for the explosion sprite
                        \ (i.e. the relative position of the sprite compared to
                        \ the centre of the explosion, which needs to be set
                        \ according to the size of the sprite)

                        \ This part of the routine actually draws the explosion
                        \ cloud

 LDY #0                 \ Fetch byte #0 of the ship line heap, which contains
 LDA (XX19),Y           \ the cloud size we stored above, and store it in Q
 STA Q

 INY                    \ Increment the index in Y to point to byte #1

 LDA (XX19),Y           \ Fetch byte #1 of the ship line heap, which contains
                        \ the cloud counter. We are now going to process this
                        \ into the number of particles in each vertex's cloud

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

 INY                    \ Increment the index in Y to point to byte #2

 LDA (XX19),Y           \ Fetch byte #2 of the ship line heap, which contains
 STA TGT                \ the explosion count for this ship (i.e. the number of
                        \ vertices used as origins for explosion clouds) and
                        \ store it in TGT

 LDA RAND+1             \ Fetch the current random number seed in RAND+1 and
 PHA                    \ store it on the stack, so we can re-randomise the
                        \ seeds when we are done

 LDY #6                 \ Set Y = 6 to point to the byte before the first vertex
                        \ coordinate we stored on the ship line heap above (we
                        \ increment it below so it points to the first vertex)

.EXL52

 LDX #3                 \ We are about to fetch a pair of coordinates from the
                        \ ship line heap, so set a counter in X for 4 bytes

.EXL32

 INY                    \ Increment the index in Y so it points to the next byte
                        \ from the coordinate we are copying

 LDA (XX19),Y           \ Copy the Y-th byte from the ship line heap to the X-th
 STA K3,X               \ byte of K3

 DEX                    \ Decrement the X index

 BPL EXL32              \ Loop back to EXL32 until we have copied all four bytes

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

                        \ We now draw sprite 1, so it shows the explosion burst
                        \ as a colourful sprite (along with the usual cloud of
                        \ explosion particles)

 LDA K3+3               \ Set (A SC) = K3(2 3) + (0 sprx)
 CLC                    \            = (x_hi x_lo) + x-coordinate offset
 ADC sprx
 STA SC
 LDA K3+2
 ADC #0

 BMI yonk               \ If the high byte of the result in (A SC) is negative,
                        \ then the explosion is off the left edge of the screen,
                        \ so jump to yonk to skip displaying the sprite

 CMP #2                 \ If A >= 2 then (A SC) >= &200 (i.e. 512), so the
 BCS yonk               \ explosion is way past the right edge of the screen, so
                        \ jump to yonk to skip displaying the sprite

 TAX                    \ Set (X SC) = (A SC)
                        \
                        \ so (X SC) contains the 9-bit x-coordinate of the
                        \ explosion

 LDA K3+1               \ Set (A Y) = K3(0 1) + (0 spry)
 CLC                    \            = (y_hi y_lo) + y-coordinate offset
 ADC spry
 TAY
 LDA K3
 ADC #0

 BNE yonk               \ If the high byte of the result in (A Y) is non-zero,
                        \ then the explosion is either off the top of bottom
                        \ edge of the screen, so jump to yonk to skip displaying
                        \ the sprite

 CPY #2*Y+50            \ If the low byte of the result in (A Y) is greater than
 BCS yonk               \ the height of the space view (2 * #Y) plus 50, then
                        \ explosion is behind the dashboard  (as it is more than
                        \ 50 pixels below the top edge of the dashboard), so
                        \ jump to yonk to skip displaying the sprite

                        \ If we get here then the explosion is visible in the
                        \ space view, so we now draw sprite 1, which contains
                        \ the explosion sprite

 LDA VIC+&10            \ The 9-bit x-coordinate of the sprite is in (X SC), so
 AND #%11111101         \ set bit 1 of VIC register &10 when X is 1, or clear
 ORA exlook,X           \ bit 1 of VIC register &10 when X is 1 (as VIC register
 STA VIC+&10            \ &10 contains the top bit of the x-coordinate for all
                        \ eight sprites, with sprite 1's bit appearing in bit 1)
                        \
                        \ The ORA exlook,X instruction is a neat way of setting
                        \ bit 1 of A to the value of X, as exlook contains %00
                        \ and %10 (you could achieve the same effect by shifting
                        \ X to the left by one place and OR'ing that, but that
                        \ would require quite a bit of register shuffling on the
                        \ 6502)

 LDX SC                 \ Set VIC registers &02 and &03 to the x-coordinate and
 STY VIC+&3             \ y-coordinate of sprite 1, which are in X and Y
 STX VIC+&2

 LDA VIC+&15            \ Set bit 1 of VIC register &15 to enable sprite 1 so
 ORA #%00000010         \ the explosion sprite appears on-screen in the correct
 STA VIC+&15            \ position

.yonk

 LDY #2                 \ Set Y = 2, which we will use to point to bytes #3 to
                        \ #6, after incrementing it

                        \ This next loop copies bytes #3 to #6 from the ship
                        \ line heap into the four random number seeds in RAND to
                        \ RAND+3, EOR'ing them with the vertex index so they are
                        \ different for every vertex. This enables us to
                        \ generate random numbers for drawing each vertex that
                        \ are random but repeatable, which we need when we
                        \ redraw the cloud to remove it
                        \
                        \ Note that we haven't actually set the values of bytes
                        \ #3 to #6 in the ship line heap, so we have no idea
                        \ what they are, we just use what's already there. But
                        \ the fact that those bytes are stored for this ship
                        \ means we can repeat the random generation of the
                        \ cloud, which is the important bit

.EXL22

 INY                    \ Increment the index in Y so it points to the next
                        \ random number seed to copy

 LDA (XX19),Y           \ Fetch the Y-th byte from the ship line heap

 EOR CNT                \ EOR with the vertex index, so the seeds are different
                        \ for each vertex

 STA &FFFF,Y            \ Y is going from 3 to 6, so this stores the four bytes
                        \ in memory locations &02, &03, &04 and &05, which are
                        \ the memory locations of RAND through RAND+3

 CPY #6                 \ Loop back to EXL22 until Y = 6, which means we have
 BNE EXL22              \ copied four bytes

 LDY U                  \ Set Y to the number of particles in the explosion for
                        \ each vertex, which we stored in U above. We will now
                        \ use this as a loop counter to iterate through all the
                        \ particles in the explosion

.EXL42

 JSR DORND2             \ Set ZZ to a random number, making sure the C flag
 STA ZZ                 \ doesn't affect the outcome

 LDA K3+1               \ Set (A R) = (y_hi y_lo)
 STA R                  \           = y
 LDA K3

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = y +/- random * cloud size

 BNE EX112              \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX112 to do
                        \ the next particle

 CPX #2*Y-1             \ If X > the y-coordinate of the bottom of the screen,
 BCS EX112              \ the particle is off the bottom of the screen, so jump
                        \ to EX112 to do the next particle

                        \ Otherwise X contains a random y-coordinate within the
                        \ cloud

 STX Y1                 \ Set Y1 = our random y-coordinate within the cloud

 LDA K3+3               \ Set (A R) = (x_hi x_lo)
 STA R
 LDA K3+2

 JSR EXS1               \ Set (A X) = (A R) +/- random * cloud size
                        \           = x +/- random * cloud size

 BNE EX42               \ If A is non-zero, the particle is off-screen as the
                        \ coordinate is bigger than 255), so jump to EX42 to do
                        \ the next particle

 LDA Y1                 \ Set A = our random y-coordinate within the cloud

 JSR PIXEL              \ Draw a point at screen coordinate (X, A) with the
                        \ point size determined by the distance in ZZ

.EX42

 DEY                    \ Decrement the loop counter for the next particle

 BPL EXL42              \ Loop back to EXL42 until we have done all the
                        \ particles in the cloud

 LDY CNT                \ Set Y to the index that points to the next vertex on
                        \ the ship line heap

 CPY TGT                \ If Y < TGT, which we set to the explosion count for
 BCS P%+5               \ this ship (i.e. the number of vertices used as origins
 JMP EXL52              \ for explosion clouds), loop back to EXL52 to do a
                        \ cloud for the next vertex

 PLA                    \ Restore the current random number seed to RAND+1 that
 STA RAND+1             \ we stored at the start of the routine

 LDA #%100              \ Call SETL1 to set the 6510 input/output port to the
 JSR SETL1              \ following:
                        \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

 LDA K%+6               \ Store the z_lo coordinate for the planet (which will
 STA RAND+3             \ be pretty random) in the RAND+3 seed

 RTS                    \ Return from the subroutine

.EX112

 JSR DORND2             \ Set A and X to random numbers, making sure the C flag
                        \ doesn't affect the outcome

 JMP EX42               \ We just skipped a particle, so jump up to EX42 to do
                        \ the next one

