\ ******************************************************************************
\
\       Name: LL9 (Part 6 of 11)
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw ship: Calculate the visibility of each of the ship's vertices
\
\ ------------------------------------------------------------------------------
\
\ This section calculates the visibility of each of the ship's vertices, and for
\ those that are visible, it starts the process of calculating the screen
\ coordinates of each vertex
\
\ ******************************************************************************

.LL42

                        \ The first task is to set up the inverse matrix, ready
                        \ for us to send to the dot product routine at LL51.
                        \ Back up in part 3, we set up the following variables:
                        \
                        \   * XX16(1 0) = sidev_x
                        \   * XX16(3 2) = sidev_y
                        \   * XX16(5 4) = sidev_z
                        \
                        \   * XX16(7 6) = roofv_x
                        \   * XX16(9 8) = roofv_y
                        \   * XX16(11 10) = roofv_z
                        \
                        \   * XX16(13 12) = nosev_x
                        \   * XX16(15 14) = nosev_y
                        \   * XX16(17 16) = nosev_z
                        \
                        \ and we then scaled the vectors to give the following:
                        \
                        \   * XX16   = scaled |sidev_x|
                        \   * XX16+2 = scaled |sidev_y|
                        \   * XX16+4 = scaled |sidev_z|
                        \
                        \   * XX16+6  = scaled |roofv_x|
                        \   * XX16+8  = scaled |roofv_y|
                        \   * XX16+10 = scaled |roofv_z|
                        \
                        \   * XX16+12 = scaled |nosev_x|
                        \   * XX16+14 = scaled |nosev_y|
                        \   * XX16+16 = scaled |nosev_z|
                        \
                        \ We now need to rearrange these locations so they
                        \ effectively transpose the matrix into its inverse

 LDY XX16+2             \ Set XX16+2 = XX16+6 = scaled |roofv_x|
 LDX XX16+3             \ Set XX16+3 = XX16+7 = roofv_x_hi
 LDA XX16+6             \ Set XX16+6 = XX16+2 = scaled |sidev_y|
 STA XX16+2             \ Set XX16+7 = XX16+3 = sidev_y_hi
 LDA XX16+7
 STA XX16+3
 STY XX16+6
 STX XX16+7

 LDY XX16+4             \ Set XX16+4 = XX16+12 = scaled |nosev_x|
 LDX XX16+5             \ Set XX16+5 = XX16+13 = nosev_x_hi
 LDA XX16+12            \ Set XX16+12 = XX16+4 = scaled |sidev_z|
 STA XX16+4             \ Set XX16+13 = XX16+5 = sidev_z_hi
 LDA XX16+13
 STA XX16+5
 STY XX16+12
 STX XX16+13

 LDY XX16+10            \ Set XX16+10 = XX16+14 = scaled |nosev_y|
 LDX XX16+11            \ Set XX16+11 = XX16+15 = nosev_y_hi
 LDA XX16+14            \ Set XX16+14 = XX16+10 = scaled |roofv_z|
 STA XX16+10            \ Set XX16+15 = XX16+11 = roofv_z
 LDA XX16+15
 STA XX16+11
 STY XX16+14
 STX XX16+15

                        \ So now we have the following sign-magnitude variables
                        \ containing parts of the scaled orientation vectors:
                        \
                        \   XX16(1 0)   = scaled sidev_x
                        \   XX16(3 2)   = scaled roofv_x
                        \   XX16(5 4)   = scaled nosev_x
                        \
                        \   XX16(7 6)   = scaled sidev_y
                        \   XX16(9 8)   = scaled roofv_y
                        \   XX16(11 10) = scaled nosev_y
                        \
                        \   XX16(13 12) = scaled sidev_z
                        \   XX16(15 14) = scaled roofv_z
                        \   XX16(17 16) = scaled nosev_z
                        \
                        \ which is what we want, as the various vectors are now
                        \ arranged so we can use LL51 to multiply by the
                        \ transpose (i.e. the inverse of the matrix)

 LDY #8                 \ Fetch byte #8 of the ship's blueprint, which is the
 LDA (XX0),Y            \ number of vertices * 8, and store it in XX20
 STA XX20

                        \ We now set V(1 0) = XX0(1 0) + 20, so V(1 0) points
                        \ to byte #20 of the ship's blueprint, which is always
                        \ where the vertex data starts (i.e. just after the 20
                        \ byte block that define the ship's characteristics)

 LDA XX0                \ We start with the low bytes
 CLC
 ADC #20
 STA V

 LDA XX0+1              \ And then do the high bytes
 ADC #0
 STA V+1

 LDY #0                 \ We are about to step through all the vertices, using
                        \ Y as a counter. There are six data bytes for each
                        \ vertex, so we will increment Y by 6 for each iteration
                        \ so it can act as an offset from V(1 0) to the current
                        \ vertex's data

 STY CNT                \ Set CNT = 0, which we will use as a pointer to the
                        \ heap at XX3, starting it at zero so the heap starts
                        \ out empty

.LL48

 STY XX17               \ Set XX17 = Y, so XX17 now contains the offset of the
                        \ current vertex's data

 LDA (V),Y              \ Fetch byte #0 for this vertex into XX15, so:
 STA XX15               \
                        \   XX15 = magnitude of the vertex's x-coordinate

 INY                    \ Increment Y to point to byte #1

 LDA (V),Y              \ Fetch byte #1 for this vertex into XX15+2, so:
 STA XX15+2             \
                        \   XX15+2 = magnitude of the vertex's y-coordinate

 INY                    \ Increment Y to point to byte #2

 LDA (V),Y              \ Fetch byte #2 for this vertex into XX15+4, so:
 STA XX15+4             \
                        \   XX15+4 = magnitude of the vertex's z-coordinate

 INY                    \ Increment Y to point to byte #3

 LDA (V),Y              \ Fetch byte #3 for this vertex into T, so:
 STA T                  \
                        \   T = %xyz vvvvv, where:
                        \
                        \     * Bits 0-4 = visibility distance, beyond which the
                        \                  vertex is not shown
                        \
                        \     * Bits 7-5 = the sign bits of x, y and z

 AND #%00011111         \ Extract bits 0-4 to get the visibility distance

 CMP XX4                \ If XX4 > the visibility distance, where XX4 contains
 BCC LL49-3             \ the ship's z-distance reduced to 0-31 (which we set in
                        \ part 2), then this vertex is too far away to be
                        \ visible, so jump down to LL50 (via the JMP instruction
                        \ in LL49-3) to move on to the next vertex

 INY                    \ Increment Y to point to byte #4

 LDA (V),Y              \ Fetch byte #4 for this vertex into P, so:
 STA P                  \
                        \  P = %ffff ffff, where:
                        \
                        \    * Bits 0-3 = the number of face 1
                        \
                        \    * Bits 4-7 = the number of face 2

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 1 is visible, so jump to LL49

 LDA P                  \ Fetch byte #4 for this vertex into A

 LSR A                  \ Shift right four times to extract the number of face 2
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 2 is visible, so jump to LL49

 INY                    \ Increment Y to point to byte #5

 LDA (V),Y              \ Fetch byte #5 for this vertex into P, so:
 STA P                  \
                        \  P = %ffff ffff, where:
                        \
                        \    * Bits 0-3 = the number of face 3
                        \
                        \    * Bits 4-7 = the number of face 4

 AND #%00001111         \ Extract the number of face 1 into X
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 3 is visible, so jump to LL49

 LDA P                  \ Fetch byte #5 for this vertex into A

 LSR A                  \ Shift right four times to extract the number of face 4
 LSR A                  \ from bits 4-7 into X
 LSR A
 LSR A
 TAX

 LDA XX2,X              \ If XX2+X is non-zero then we decided in part 5 that
 BNE LL49               \ face 4 is visible, so jump to LL49

 JMP LL50               \ If we get here then none of the four faces associated
                        \ with this vertex are visible, so this vertex is also
                        \ not visible, so jump to LL50 to move on to the next
                        \ vertex

.LL49

 LDA T                  \ Fetch byte #5 for this vertex into A and store it, so
 STA XX15+1             \ XX15+1 now has the sign of the vertex's x-coordinate

 ASL A                  \ Shift A left and store it, so XX15+3 now has the sign
 STA XX15+3             \ of the vertex's y-coordinate

 ASL A                  \ Shift A left and store it, so XX15+5 now has the sign
 STA XX15+5             \ of the vertex's z-coordinate

                        \ By this point we have the following:
                        \
                        \   XX15(1 0) = vertex x-coordinate
                        \   XX15(3 2) = vertex y-coordinate
                        \   XX15(5 4) = vertex z-coordinate
                        \
                        \   XX16(1 0)   = scaled sidev_x
                        \   XX16(3 2)   = scaled roofv_x
                        \   XX16(5 4)   = scaled nosev_x
                        \
                        \   XX16(7 6)   = scaled sidev_y
                        \   XX16(9 8)   = scaled roofv_y
                        \   XX16(11 10) = scaled nosev_y
                        \
                        \   XX16(13 12) = scaled sidev_z
                        \   XX16(15 14) = scaled roofv_z
                        \   XX16(17 16) = scaled nosev_z

 JSR LL51               \ Call LL51 to set XX12 to the dot products of XX15 and
                        \ XX16, as follows:
                        \
                        \   XX12(1 0) = [ x y z ] . [ sidev_x roofv_x nosev_x ]
                        \
                        \   XX12(3 2) = [ x y z ] . [ sidev_y roofv_y nosev_y ]
                        \
                        \   XX12(5 4) = [ x y z ] . [ sidev_z roofv_z nosev_z ]
                        \
                        \ XX12 contains the vector from the ship's centre to
                        \ the vertex, transformed from the orientation vector
                        \ space to the universe orientated around our ship. So
                        \ we can refer to this vector below, let's call it
                        \ vertv, so:
                        \
                        \   vertv_x = [ x y z ] . [ sidev_x roofv_x nosev_x ]
                        \
                        \   vertv_y = [ x y z ] . [ sidev_y roofv_y nosev_y ]
                        \
                        \   vertv_z = [ x y z ] . [ sidev_z roofv_z nosev_z ]
                        \
                        \ To finish the calculation, we now want to calculate:
                        \
                        \   vertv + [ x y z ]
                        \
                        \ So let's start with the vertv_x + x

 LDA XX1+2              \ Set A = x_sign of the ship's location

 STA XX15+2             \ Set XX15+2 = x_sign

 EOR XX12+1             \ If the sign of x_sign * the sign of vertv_x is
 BMI LL52               \ negative (i.e. they have different signs), skip to
                        \ LL52

 CLC                    \ Set XX15(2 1 0) = XX1(2 1 0) + XX12(1 0)
 LDA XX12               \                 = (x_sign x_hi x_lo) + vertv_x
 ADC XX1                \
 STA XX15               \ Starting with the low bytes

 LDA XX1+1              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_x is 0)
 STA XX15+1

 JMP LL53               \ We've added the x-coordinates, so jump to LL53 to do
                        \ the y-coordinates

.LL52

                        \ If we get here then x_sign and vertv_x have different
                        \ signs, so we need to subtract them to get the result

 LDA XX1                \ Set XX15(2 1 0) = XX1(2 1 0) - XX12(1 0)
 SEC                    \                 = (x_sign x_hi x_lo) - vertv_x
 SBC XX12               \
 STA XX15               \ Starting with the low bytes

 LDA XX1+1              \ And then doing the high bytes (we can subtract 0 here
 SBC #0                 \ as we know the sign byte of vertv_x is 0)
 STA XX15+1

 BCS LL53               \ If the subtraction didn't underflow, then the sign of
                        \ the result is the same sign as x_sign, and that's what
                        \ we want, so we can jump down to LL53 to do the
                        \ y-coordinates

 EOR #%11111111         \ Otherwise we need to negate the result using two's
 STA XX15+1             \ complement, so first we flip the bits of the high byte

 LDA #1                 \ And then subtract the low byte from 1
 SBC XX15
 STA XX15

 BCC P%+4               \ If the above subtraction underflowed then we need to
 INC XX15+1             \ bump the high byte of the result up by 1

 LDA XX15+2             \ And now we flip the sign of the result to get the
 EOR #%10000000         \ correct result
 STA XX15+2

.LL53

                        \ Now for the y-coordinates, vertv_y + y

 LDA XX1+5              \ Set A = y_sign of the ship's location

 STA XX15+5             \ Set XX15+5 = y_sign

 EOR XX12+3             \ If the sign of y_sign * the sign of vertv_y is
 BMI LL54               \ negative (i.e. they have different signs), skip to
                        \ LL54

 CLC                    \ Set XX15(5 4 3) = XX1(5 4 3) + XX12(3 2)
 LDA XX12+2             \                 = (y_sign y_hi y_lo) + vertv_y
 ADC XX1+3              \
 STA XX15+3             \ Starting with the low bytes

 LDA XX1+4              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_y is 0)
 STA XX15+4

 JMP LL55               \ We've added the y-coordinates, so jump to LL55 to do
                        \ the z-coordinates

.LL54

                        \ If we get here then y_sign and vertv_y have different
                        \ signs, so we need to subtract them to get the result

 LDA XX1+3              \ Set XX15(5 4 3) = XX1(5 4 3) - XX12(3 2)
 SEC                    \                 = (y_sign y_hi y_lo) - vertv_y
 SBC XX12+2             \
 STA XX15+3             \ Starting with the low bytes

 LDA XX1+4              \ And then doing the high bytes (we can subtract 0 here
 SBC #0                 \ as we know the sign byte of vertv_z is 0)
 STA XX15+4

 BCS LL55               \ If the subtraction didn't underflow, then the sign of
                        \ the result is the same sign as y_sign, and that's what
                        \ we want, so we can jump down to LL55 to do the
                        \ z-coordinates

 EOR #%11111111         \ Otherwise we need to negate the result using two's
 STA XX15+4             \ complement, so first we flip the bits of the high byte

 LDA XX15+3             \ And then flip the bits of the low byte and add 1
 EOR #%11111111
 ADC #1
 STA XX15+3

 LDA XX15+5             \ And now we flip the sign of the result to get the
 EOR #%10000000         \ correct result
 STA XX15+5

 BCC LL55               \ If the above subtraction underflowed then we need to
 INC XX15+4             \ bump the high byte of the result up by 1

.LL55

                        \ Now for the z-coordinates, vertv_z + z

 LDA XX12+5             \ If vertv_z_hi is negative, jump down to LL56
 BMI LL56

 LDA XX12+4             \ Set (U T) = XX1(7 6) + XX12(5 4)
 CLC                    \           = (z_hi z_lo) + vertv_z
 ADC XX1+6              \
 STA T                  \ Starting with the low bytes

 LDA XX1+7              \ And then doing the high bytes (we can add 0 here as
 ADC #0                 \ we know the sign byte of vertv_y is 0)
 STA U

 JMP LL57               \ We've added the z-coordinates, so jump to LL57

                        \ The adding process is continued in part 7, after a
                        \ couple of subroutines that we don't need quite yet

